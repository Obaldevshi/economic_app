import hashlib
import json
from datetime import date, datetime, timezone
from decimal import Decimal
from pydantic import ValidationError as InputError
from sqlalchemy.orm import Session
from app.core.exceptions import ConflictError, NotFoundError, ValidationError
from app.models.savings_sync import SavingsSyncOperation
from app.repositories.savings_sync_repository import SavingsSyncRepository
from app.schemas.savings import (ImpulseItemCreate, ImpulseItemUpdate, SavingEventCreate,
    SavingEventUpdate, SavingsGoalCreate, SavingsGoalUpdate, GoalAllocationUpdate, SavingsSettingsUpdate,
    SpentEventCreate, SpentEventUpdate)
from app.services.savings_service import SavingsService


def _equal(current, previous):
    if isinstance(current, (Decimal, float, int)) and not isinstance(current, bool):
        try:
            return Decimal(str(current)) == Decimal(str(previous))
        except Exception:
            return False
    if isinstance(current, datetime):
        try:
            other = datetime.fromisoformat(str(previous).replace("Z", "+00:00"))
            def utc(value):
                return value.replace(tzinfo=timezone.utc) if value.tzinfo is None else value.astimezone(timezone.utc)
            return utc(current) == utc(other)
        except ValueError:
            return False
    if isinstance(current, date):
        return current.isoformat() == previous
    return current == previous


class SavingsSyncService:
    def __init__(self, db, region="RU"):
        self.repository = SavingsSyncRepository(db)
        self.region = region

    def apply(self, user_id, request):
        db = self.repository.db
        fingerprint = hashlib.sha256(json.dumps(request.model_dump(mode="json"), sort_keys=True,
            separators=(",", ":"), ensure_ascii=False).encode()).hexdigest()
        try:
            self.repository.lock_account(user_id)
            previous = self.repository.find(user_id, str(request.operation_id))
            if previous:
                if previous.request_hash != fingerprint:
                    raise ConflictError("Offline operation identifier reused")
                result = previous.result
                db.commit()
                return result
            # Existing services commit internally. SAVEPOINT-bound sessions keep
            # those commits inside this outer transaction, together with its ack.
            with Session(bind=db.connection(), join_transaction_mode="create_savepoint") as inner:
                ledger = request.payload.get("currency_code") if request.kind.startswith("create_") else None
                service = SavingsService(inner, self.region, ledger_currency=ledger)
                # Match the normal mutation lock order: settings, then record.
                # Both remain locked until the outer transaction stores its ack.
                service._lock_balance(user_id)
                kind, key = request.kind, request.entity_id
                getters = {"event": service.repository.get_event,
                           "spent": service.repository.get_spent,
                           "impulse": service.repository.get_impulse,
                           "goal": service.repository.get_goal}
                if not kind.startswith("create_"):
                    if kind == "update_settings":
                        record = service.get_settings(user_id)
                    else:
                        if key is None:
                            raise ValidationError("Offline record identifier required")
                        record = getters[kind.split("_")[-1]](key, user_id)
                        if record is None:
                            raise NotFoundError("Offline record no longer exists")
                        record = service.repository.lock_record(record)
                    if not request.force and any(
                        not hasattr(record, field) or not _equal(getattr(record, field), value)
                        for field, value in request.before.items()
                    ):
                        raise ConflictError("Offline changes conflict with server")
                schemas = {"create_event": SavingEventCreate, "update_event": SavingEventUpdate,
                    "create_spent": SpentEventCreate, "update_spent": SpentEventUpdate,
                    "create_impulse": ImpulseItemCreate, "update_impulse": ImpulseItemUpdate,
                    "create_goal": SavingsGoalCreate, "update_goal": SavingsGoalUpdate,
                    "allocate_goal": GoalAllocationUpdate, "update_settings": SavingsSettingsUpdate}
                data = schemas[kind].model_validate(request.payload) if kind in schemas else None
                actions = {
                    "create_spent": lambda: service.create_spent(user_id, data),
                    "update_spent": lambda: service.update_spent(key, user_id, data),
                    "delete_spent": lambda: service.delete_spent(key, user_id),
                    "create_event": lambda: service.create_event(user_id, data),
                    "update_event": lambda: service.update_event(key, user_id, data),
                    "delete_event": lambda: service.delete_event(key, user_id),
                    "create_impulse": lambda: service.create_impulse(user_id, data),
                    "update_impulse": lambda: service.update_impulse(key, user_id, data),
                    "delete_impulse": lambda: service.delete_impulse(key, user_id),
                    "create_goal": lambda: service.create_goal(user_id, data),
                    "update_goal": lambda: service.update_goal(key, user_id, data),
                    "allocate_goal": lambda: service.allocate_goal(key, user_id, data.allocated_amount),
                    "update_settings": lambda: service.update_settings(user_id, data),
                }
                value = actions[kind]()
                result = {"entity_id": getattr(value, "id", key)}
            db.add(SavingsSyncOperation(user_id=user_id, operation_id=str(request.operation_id),
                request_hash=fingerprint, result=result))
            db.commit()
            return result
        except InputError:
            db.rollback()
            raise ValidationError("Invalid offline operation")
        except Exception:
            db.rollback()
            raise
