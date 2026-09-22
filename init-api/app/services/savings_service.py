from datetime import datetime, timedelta
from decimal import Decimal, ROUND_HALF_UP

from sqlalchemy.orm import Session

from app.core.exceptions import NotFoundError
from app.repositories.savings_repository import SavingsRepository
from app.schemas.savings import (
    ImpulseItemCreate,
    ImpulseItemUpdate,
    SavingEventCreate,
    SavingEventUpdate,
    SavingsGoalCreate,
    SavingsGoalUpdate,
    SavingsSettingsUpdate,
)


MONEY = Decimal("0.01")
DEFAULT_IMPULSES = [
    {"name": "Кофе навынос", "default_amount": Decimal("300"), "icon_key": "coffee", "weekly_frequency": 3},
    {"name": "Кафе и фастфуд", "default_amount": Decimal("900"), "icon_key": "restaurant", "weekly_frequency": 1},
    {"name": "Доставка еды", "default_amount": Decimal("1200"), "icon_key": "delivery", "weekly_frequency": 1},
    {"name": "Сигареты", "default_amount": Decimal("250"), "icon_key": "smoking", "weekly_frequency": 5},
    {"name": "Такси", "default_amount": Decimal("700"), "icon_key": "taxi", "weekly_frequency": 2},
    {"name": "Маркетплейсы", "default_amount": Decimal("1500"), "icon_key": "shopping", "weekly_frequency": 1},
    {"name": "Ненужная подписка", "default_amount": Decimal("399"), "icon_key": "subscription", "weekly_frequency": 0},
]


def _money(value) -> Decimal:
    return Decimal(value or 0).quantize(MONEY, rounding=ROUND_HALF_UP)


class SavingsService:
    def __init__(self, db: Session):
        self.repository = SavingsRepository(db)

    def get_impulses(self, user_id: int, include_inactive: bool = False):
        items = self.repository.get_impulses(user_id, include_inactive=True)
        if not items:
            items = self.repository.create_default_impulses(user_id, DEFAULT_IMPULSES)
        if include_inactive:
            return items
        return [item for item in items if item.is_active]

    def create_impulse(self, user_id: int, data: ImpulseItemCreate):
        return self.repository.impulses.create({"user_id": user_id, **data.model_dump()})

    def update_impulse(self, item_id: int, user_id: int, data: ImpulseItemUpdate):
        item = self.repository.get_impulse(item_id, user_id)
        if not item:
            raise NotFoundError("Impulse item not found")
        return self.repository.impulses.update(item, data.model_dump(exclude_unset=True))

    def delete_impulse(self, item_id: int, user_id: int):
        item = self.repository.get_impulse(item_id, user_id)
        if not item:
            raise NotFoundError("Impulse item not found")
        return self.repository.impulses.delete(item.id)

    def get_events(self, user_id: int, page: int = 1, per_page: int = 50):
        page = max(page, 1)
        per_page = min(max(per_page, 1), 100)
        items, total = self.repository.get_events(user_id, page, per_page)
        return items, total, page, per_page

    def create_event(self, user_id: int, data: SavingEventCreate):
        if data.impulse_item_id is not None and not self.repository.get_impulse(data.impulse_item_id, user_id):
            raise NotFoundError("Impulse item not found")
        values = data.model_dump()
        values["occurred_at"] = values["occurred_at"] or datetime.now()
        return self.repository.events.create({"user_id": user_id, **values})

    def update_event(self, event_id: int, user_id: int, data: SavingEventUpdate):
        event = self.repository.get_event(event_id, user_id)
        if not event:
            raise NotFoundError("Saving event not found")
        if data.impulse_item_id is not None and not self.repository.get_impulse(data.impulse_item_id, user_id):
            raise NotFoundError("Impulse item not found")
        return self.repository.events.update(event, data.model_dump(exclude_unset=True))

    def delete_event(self, event_id: int, user_id: int):
        event = self.repository.get_event(event_id, user_id)
        if not event:
            raise NotFoundError("Saving event not found")
        return self.repository.events.delete(event.id)

    def get_goals(self, user_id: int):
        return self.repository.get_goals(user_id)

    def create_goal(self, user_id: int, data: SavingsGoalCreate):
        return self.repository.goals.create({"user_id": user_id, **data.model_dump()})

    def update_goal(self, goal_id: int, user_id: int, data: SavingsGoalUpdate):
        goal = self.repository.get_goal(goal_id, user_id)
        if not goal:
            raise NotFoundError("Savings goal not found")
        return self.repository.goals.update(goal, data.model_dump(exclude_unset=True))

    def delete_goal(self, goal_id: int, user_id: int):
        goal = self.repository.get_goal(goal_id, user_id)
        if not goal:
            raise NotFoundError("Savings goal not found")
        return self.repository.goals.delete(goal.id)

    def get_settings(self, user_id: int):
        settings = self.repository.get_settings(user_id)
        if settings:
            return settings
        return self.repository.settings.create(
            {"user_id": user_id, "annual_rate": Decimal("12"), "projection_years": 5}
        )

    def update_settings(self, user_id: int, data: SavingsSettingsUpdate):
        settings = self.get_settings(user_id)
        return self.repository.settings.update(settings, data.model_dump())

    def get_dashboard(self, user_id: int):
        now = datetime.now()
        settings = self.get_settings(user_id)
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

        return {
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
