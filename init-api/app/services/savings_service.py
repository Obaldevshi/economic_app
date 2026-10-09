from datetime import datetime, timedelta
from decimal import Decimal, ROUND_HALF_UP

from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from app.models.savings import ImpulseItem
from app.services.financial_presets import REGIONS, default_impulses

from app.core.exceptions import NotFoundError, ValidationError
from app.repositories.savings_repository import SavingsRepository
from app.schemas.savings import (
    ImpulseItemCreate,
    ImpulseItemUpdate,
    SavingEventCreate,
    SavingEventUpdate,
    SavingsGoalCreate,
    SavingsGoalUpdate,
    SavingsSettingsUpdate,
    SavingEventResponse,
    SavingsGoalResponse,
)


MONEY = Decimal("0.01")


def _money(value) -> Decimal:
    return Decimal(value or 0).quantize(MONEY, rounding=ROUND_HALF_UP)


class SavingsService:
    def __init__(self, db: Session, region: str = "RU"):
        self.repository = SavingsRepository(db)
        self.initial_region = region if region in REGIONS else "RU"

    def get_impulses(self, user_id: int, include_inactive: bool = False):
        settings = self.get_settings(user_id)
        # Serialize first-use seeding with settings changes and other GETs.
        settings = self.repository.lock_balance(user_id)
        try:
            items = self.repository.get_impulses(user_id, include_inactive=True)
            if not items:
                defaults = default_impulses(settings.financial_region, settings.currency_code)
                items = [ImpulseItem(user_id=user_id, **item) for item in defaults]
                self.repository.db.add_all(items)
            self.repository.db.commit()
        except Exception:
            self.repository.db.rollback()
            raise
        if include_inactive:
            return items
        return [item for item in items if item.is_active]

    def create_impulse(self, user_id: int, data: ImpulseItemCreate):
        self._lock_balance(user_id)
        values = self._currency_values(user_id, data)
        return self.repository.impulses.create({"user_id": user_id, **values})

    def update_impulse(self, item_id: int, user_id: int, data: ImpulseItemUpdate):
        item = self.repository.get_impulse(item_id, user_id)
        if not item:
            raise NotFoundError("Impulse item not found")
        return self.repository.impulses.update(item, self._currency_values(user_id, data, item))

    def delete_impulse(self, item_id: int, user_id: int):
        item = self.repository.get_impulse(item_id, user_id)
        if not item:
            raise NotFoundError("Impulse item not found")
        return self.repository.impulses.delete(item.id)

    def get_events(self, user_id: int, page: int = 1, per_page: int = 50):
        self.get_settings(user_id)
        page = max(page, 1)
        per_page = min(max(per_page, 1), 100)
        items, total = self.repository.get_events(user_id, page, per_page)
        return items, total, page, per_page

    def create_event(self, user_id: int, data: SavingEventCreate):
        self._lock_balance(user_id)
        if data.impulse_item_id is not None and not self.repository.get_impulse(data.impulse_item_id, user_id):
            raise NotFoundError("Impulse item not found")
        values = self._currency_values(user_id, data)
        if data.impulse_item_id is not None:
            item = self.repository.get_impulse(data.impulse_item_id, user_id)
            if item.currency_code != values["currency_code"]:
                raise ValidationError("Currency changed; refresh and try again")
        values["occurred_at"] = values["occurred_at"] or datetime.now()
        return self.repository.events.create({"user_id": user_id, **values})

    def update_event(self, event_id: int, user_id: int, data: SavingEventUpdate):
        self._lock_balance(user_id)
        try:
            event = self.repository.get_event(event_id, user_id)
            if not event:
                raise NotFoundError("Saving event not found")
            if data.impulse_item_id is not None and not self.repository.get_impulse(data.impulse_item_id, user_id):
                raise NotFoundError("Impulse item not found")
            if data.impulse_item_id is not None:
                item = self.repository.get_impulse(data.impulse_item_id, user_id)
                if item.currency_code != event.currency_code:
                    raise ValidationError("Currency changed; refresh and try again")
            for field, value in self._currency_values(user_id, data, event).items():
                setattr(event, field, value)
            self.repository.db.flush()
            self._check_allocation_balance(user_id, event.currency_code)
            self.repository.db.commit()
            self.repository.db.refresh(event)
            return event
        except Exception:
            self.repository.db.rollback()
            raise

    def delete_event(self, event_id: int, user_id: int):
        self._lock_balance(user_id)
        try:
            event = self.repository.get_event(event_id, user_id)
            if not event:
                raise NotFoundError("Saving event not found")
            self.repository.db.delete(event)
            self.repository.db.flush()
            self._check_allocation_balance(user_id, event.currency_code)
            self.repository.db.commit()
        except Exception:
            self.repository.db.rollback()
            raise

    def get_goals(self, user_id: int):
        self.get_settings(user_id)
        return self.repository.get_goals(user_id)

    def create_goal(self, user_id: int, data: SavingsGoalCreate):
        self._lock_balance(user_id)
        return self.repository.goals.create({"user_id": user_id, **self._currency_values(user_id, data)})

    def update_goal(self, goal_id: int, user_id: int, data: SavingsGoalUpdate):
        self._lock_balance(user_id)
        goal = self.repository.get_goal(goal_id, user_id)
        if not goal:
            raise NotFoundError("Savings goal not found")
        if data.target_amount is not None and data.target_amount < goal.allocated_amount:
            raise ValidationError("Release goal funds before reducing its target")
        return self.repository.goals.update(goal, self._currency_values(user_id, data, goal))

    def delete_goal(self, goal_id: int, user_id: int):
        self._lock_balance(user_id)
        goal = self.repository.get_goal(goal_id, user_id)
        if not goal:
            raise NotFoundError("Savings goal not found")
        return self.repository.goals.delete(goal.id)

    def _lock_balance(self, user_id: int):
        self.get_settings(user_id)
        self.repository.lock_balance(user_id)

    def _check_allocation_balance(self, user_id: int, currency: str):
        if self.repository.allocated_total(user_id, currency) > self.repository.invested_total(user_id, currency):
            raise ValidationError("Release goal allocations before reducing saved funds")

    def allocate_goal(self, goal_id: int, user_id: int, amount: Decimal):
        self._lock_balance(user_id)
        try:
            goal = self.repository.get_goal(goal_id, user_id)
            if not goal:
                raise NotFoundError("Savings goal not found")
            if amount > goal.target_amount:
                raise ValidationError("Allocation must not exceed the goal target")
            goal.allocated_amount = amount
            self.repository.db.flush()
            self._check_allocation_balance(user_id, goal.currency_code)
            self.repository.db.commit()
            self.repository.db.refresh(goal)
            return goal
        except Exception:
            self.repository.db.rollback()
            raise

    def get_weekly_receipt(self, user_id: int):
        settings = self.get_settings(user_id)
        now = datetime.now()
        start = now.replace(hour=0, minute=0, second=0, microsecond=0) - timedelta(days=6)
        events = [item for item in self.repository.get_events_since(user_id, start) if item.occurred_at <= now]
        return {
            "currency_code": settings.currency_code,
            "start_date": start.date(), "end_date": now.date(),
            "total_saved": _money(sum((item.amount for item in events), Decimal(0))),
            "invested_total": _money(sum((item.amount for item in events if item.is_invested), Decimal(0))),
            "decision_count": len(events),
        }

    def get_settings(self, user_id: int):
        settings = self.repository.get_settings(user_id)
        if settings:
            return settings
        # A pre-existing ledger is always RUB, even if the UI language changed.
        region = "RU" if self.repository.has_ledger(user_id) else self.initial_region
        currency, rate, _, _, _ = REGIONS[region]
        try:
            return self.repository.settings.create(
                {"user_id": user_id, "annual_rate": Decimal(rate), "projection_years": 5,
                 "financial_region": region, "currency_code": currency, "display_currency": currency}
            )
        except IntegrityError:
            self.repository.db.rollback()
            settings = self.repository.get_settings(user_id)
            if settings is None:
                raise
            return settings

    def update_settings(self, user_id: int, data: SavingsSettingsUpdate):
        self._lock_balance(user_id)
        settings = self.repository.get_settings(user_id)
        values = data.model_dump(exclude_none=True)
        return self.repository.settings.update(settings, values)

    def _currency_values(self, user_id, data, record=None):
        currency = record.currency_code if record is not None else self.get_settings(user_id).currency_code
        # Old clients entered RUB. They must not silently create foreign money.
        expected_currency = data.currency_code or "RUB"
        if expected_currency != currency:
            raise ValidationError("Currency changed; refresh and try again")
        values = data.model_dump(exclude_unset=record is not None)
        values["currency_code"] = currency
        return values

    def get_dashboard(self, user_id: int):
        now = datetime.now()
        self._lock_balance(user_id)
        settings = self.repository.get_settings(user_id)
        events = self.repository.get_events_since(user_id, now - timedelta(days=365))
        recent_events = self.repository.get_recent_events(user_id)
        goals = self.repository.get_goals(user_id)

        today_total = sum((event.amount for event in events if event.occurred_at.date() == now.date()), Decimal(0))
        month_total = sum((event.amount for event in events if event.occurred_at.year == now.year and event.occurred_at.month == now.month), Decimal(0))
        total_events, _ = self.repository.get_events(user_id, 1, 100000)
        total_saved = sum((event.amount for event in total_events), Decimal(0))
        invested_total = sum((event.amount for event in total_events if event.is_invested), Decimal(0))

        ninety_days_ago = now - timedelta(days=90)
        ninety_day_total = sum((event.amount for event in events if event.occurred_at >= ninety_days_ago), Decimal(0))
        monthly_pace = ninety_day_total / Decimal(3)
        if not events:
            monthly_pace = Decimal(0)

        monthly_series = []
        for offset in range(5, -1, -1):
            year = now.year
            month = now.month - offset
            while month <= 0:
                month += 12
                year -= 1
            amount = sum((event.amount for event in events if event.occurred_at.year == year and event.occurred_at.month == month), Decimal(0))
            monthly_series.append({"month": f"{year:04d}-{month:02d}", "amount": _money(amount)})

        annual_rate = Decimal(settings.annual_rate)
        monthly_rate = annual_rate / Decimal(100 * 12)
        projection_series = []
        for year in range(1, settings.projection_years + 1):
            months = year * 12
            contributions = total_saved + monthly_pace * months
            if monthly_rate > 0:
                future_current = total_saved * ((Decimal(1) + monthly_rate) ** months)
                future_payments = monthly_pace * (((Decimal(1) + monthly_rate) ** months - Decimal(1)) / monthly_rate)
                total = future_current + future_payments
            else:
                total = contributions
            projection_series.append({
                "year": year,
                "contributions": _money(contributions),
                "interest": _money(total - contributions),
                "total": _money(total),
            })

        final_projection = projection_series[-1] if projection_series else {
            "total": _money(total_saved), "interest": Decimal(0)
        }
        impulse_totals = [
            {"name": name, "amount": _money(amount)}
            for name, amount in self.repository.totals_by_impulse(user_id)
        ]

        data = {
            "currency_code": settings.currency_code,
            "display_currency": settings.display_currency,
            "financial_region": settings.financial_region,
            "today_total": _money(today_total),
            "month_total": _money(month_total),
            "total_saved": _money(total_saved),
            "invested_total": _money(invested_total),
            "monthly_pace": _money(monthly_pace),
            "annual_rate": _money(annual_rate),
            "projection_years": settings.projection_years,
            "projected_total": final_projection["total"],
            "projected_interest": final_projection["interest"],
            "monthly_series": monthly_series,
            "projection_series": projection_series,
            "impulse_totals": impulse_totals,
            "recent_events": recent_events,
            "goals": goals,
        }
        # Materialize ORM records before releasing the stable currency snapshot.
        data["recent_events"] = [SavingEventResponse.model_validate(event) for event in recent_events]
        data["goals"] = [SavingsGoalResponse.model_validate(goal) for goal in goals]
        self.repository.db.commit()
        return data
