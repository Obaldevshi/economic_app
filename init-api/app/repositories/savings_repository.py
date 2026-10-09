from datetime import datetime
from typing import Optional

from sqlalchemy import func
from sqlalchemy.orm import Session

from app.models.savings import ImpulseItem, SavingEvent, SavingsGoal, SavingsSettings
from app.repositories.base import BaseRepository


class SavingsRepository:
    def __init__(self, db: Session):
        self.db = db
        self.impulses = BaseRepository(db, ImpulseItem)
        self.events = BaseRepository(db, SavingEvent)
        self.goals = BaseRepository(db, SavingsGoal)
        self.settings = BaseRepository(db, SavingsSettings)

    def get_impulses(self, user_id: int, include_inactive: bool = False):
        query = self._ledger_query(ImpulseItem, user_id)
        if not include_inactive:
            query = query.filter(ImpulseItem.is_active.is_(True))
        return query.order_by(ImpulseItem.id.asc()).all()

    def get_impulse(self, item_id: int, user_id: int) -> Optional[ImpulseItem]:
        return self.db.query(ImpulseItem).filter(
            ImpulseItem.id == item_id,
            ImpulseItem.user_id == user_id,
        ).first()

    def create_default_impulses(self, user_id: int, items: list[dict]):
        db_items = [ImpulseItem(user_id=user_id, **item) for item in items]
        self.db.add_all(db_items)
        self.db.commit()
        return self.get_impulses(user_id)

    def get_events(self, user_id: int, page: int, per_page: int):
        query = self._ledger_query(SavingEvent, user_id)
        total = query.count()
        items = query.order_by(
            SavingEvent.occurred_at.desc(), SavingEvent.id.desc()
        ).offset((page - 1) * per_page).limit(per_page).all()
        return items, total

    def get_event(self, event_id: int, user_id: int) -> Optional[SavingEvent]:
        return self.db.query(SavingEvent).filter(
            SavingEvent.id == event_id,
            SavingEvent.user_id == user_id,
        ).first()

    def get_events_since(self, user_id: int, since: datetime):
        return self._ledger_query(SavingEvent, user_id).filter(
            SavingEvent.occurred_at >= since,
        ).all()

    def get_recent_events(self, user_id: int, limit: int = 5):
        return self._ledger_query(SavingEvent, user_id).order_by(
            SavingEvent.occurred_at.desc(), SavingEvent.id.desc()).limit(limit).all()

    def get_goals(self, user_id: int):
        return self._ledger_query(SavingsGoal, user_id).order_by(SavingsGoal.id.desc()).all()

    def get_goal(self, goal_id: int, user_id: int) -> Optional[SavingsGoal]:
        return self.db.query(SavingsGoal).filter(
            SavingsGoal.id == goal_id,
            SavingsGoal.user_id == user_id,
        ).first()

    def get_settings(self, user_id: int) -> Optional[SavingsSettings]:
        return self.db.query(SavingsSettings).filter(
            SavingsSettings.user_id == user_id,
        ).first()

    def totals_by_impulse(self, user_id: int, limit: int = 6):
        return self.db.query(
            SavingEvent.impulse_name,
            func.sum(SavingEvent.amount).label("amount"),
        ).filter(SavingEvent.user_id == user_id, SavingEvent.currency_code == self._currency(user_id)).group_by(
            SavingEvent.impulse_name
        ).order_by(func.sum(SavingEvent.amount).desc()).limit(limit).all()

    def lock_balance(self, user_id: int):
        # All writes which can reduce the available balance share this row lock.
        return self.db.query(SavingsSettings).filter(
            SavingsSettings.user_id == user_id,
        ).populate_existing().with_for_update().one()

    def has_ledger(self, user_id: int):
        return any(self.db.query(model.id).filter(model.user_id == user_id).first()
                   for model in (SavingEvent, SavingsGoal, ImpulseItem))

    def invested_total(self, user_id: int, currency: str):
        return self.db.query(func.coalesce(func.sum(SavingEvent.amount), 0)).filter(
            SavingEvent.user_id == user_id, SavingEvent.is_invested.is_(True),
            SavingEvent.currency_code == currency,
        ).scalar()

    def allocated_total(self, user_id: int, currency: str):
        return self.db.query(func.coalesce(func.sum(SavingsGoal.allocated_amount), 0)).filter(
            SavingsGoal.user_id == user_id,
            SavingsGoal.currency_code == currency,
        ).scalar()

    def _currency(self, user_id):
        return self.db.query(SavingsSettings.currency_code).filter(
            SavingsSettings.user_id == user_id).scalar_subquery()

    def _ledger_query(self, model, user_id):
        return self.db.query(model).filter(
            model.user_id == user_id, model.currency_code == self._currency(user_id))
