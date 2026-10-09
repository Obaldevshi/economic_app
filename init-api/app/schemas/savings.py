from datetime import date, datetime
from decimal import Decimal
from typing import Optional

from pydantic import BaseModel, Field


class ImpulseItemCreate(BaseModel):
    name: str = Field(min_length=2, max_length=120)
    default_amount: Decimal = Field(gt=0, max_digits=12, decimal_places=2)
    icon_key: str = Field(default="other", max_length=40)
    weekly_frequency: int = Field(default=1, ge=0, le=50)


class ImpulseItemUpdate(BaseModel):
    name: Optional[str] = Field(default=None, min_length=2, max_length=120)
    default_amount: Optional[Decimal] = Field(default=None, gt=0, max_digits=12, decimal_places=2)
    icon_key: Optional[str] = Field(default=None, max_length=40)
    weekly_frequency: Optional[int] = Field(default=None, ge=0, le=50)
    is_active: Optional[bool] = None


class ImpulseItemResponse(BaseModel):
    id: int
    name: str
    default_amount: Decimal
    icon_key: str
    weekly_frequency: int
    is_active: bool

    model_config = {"from_attributes": True}


class SavingEventCreate(BaseModel):
    impulse_item_id: Optional[int] = None
    impulse_name: str = Field(min_length=2, max_length=120)
    amount: Decimal = Field(gt=0, max_digits=12, decimal_places=2)
    occurred_at: Optional[datetime] = None
    is_invested: bool = False
    note: Optional[str] = Field(default=None, max_length=500)


class SavingEventUpdate(BaseModel):
    impulse_item_id: Optional[int] = None
    impulse_name: Optional[str] = Field(default=None, min_length=2, max_length=120)
    amount: Optional[Decimal] = Field(default=None, gt=0, max_digits=12, decimal_places=2)
    occurred_at: Optional[datetime] = None
    is_invested: Optional[bool] = None
    note: Optional[str] = Field(default=None, max_length=500)


class SavingEventResponse(BaseModel):
    id: int
    impulse_item_id: Optional[int]
    impulse_name: str
    amount: Decimal
    occurred_at: datetime
    is_invested: bool
    note: Optional[str]

    model_config = {"from_attributes": True}


class SavingsGoalCreate(BaseModel):
    name: str = Field(min_length=2, max_length=120)
    target_amount: Decimal = Field(gt=0, max_digits=12, decimal_places=2)
    target_date: Optional[date] = None


class SavingsGoalUpdate(BaseModel):
    name: Optional[str] = Field(default=None, min_length=2, max_length=120)
    target_amount: Optional[Decimal] = Field(default=None, gt=0, max_digits=12, decimal_places=2)
    target_date: Optional[date] = None


class SavingsGoalResponse(BaseModel):
    id: int
    name: str
    target_amount: Decimal
    target_date: Optional[date]
    allocated_amount: Decimal = Decimal(0)

    model_config = {"from_attributes": True}


class GoalAllocationUpdate(BaseModel):
    allocated_amount: Decimal = Field(ge=0, max_digits=12, decimal_places=2)


class WeeklyReceiptResponse(BaseModel):
    start_date: date
    end_date: date
    total_saved: Decimal
    invested_total: Decimal
    decision_count: int


class SavingsSettingsUpdate(BaseModel):
    annual_rate: Decimal = Field(ge=0, le=100, max_digits=5, decimal_places=2)
    projection_years: int = Field(ge=1, le=30)


class SavingsSettingsResponse(BaseModel):
    annual_rate: Decimal
    projection_years: int

    model_config = {"from_attributes": True}


class MonthlySavingPoint(BaseModel):
    month: str
    amount: Decimal


class ProjectionPoint(BaseModel):
    year: int
    contributions: Decimal
    interest: Decimal
    total: Decimal


class ImpulseTotal(BaseModel):
    name: str
    amount: Decimal


class SavingsDashboardResponse(BaseModel):
    today_total: Decimal
    month_total: Decimal
    total_saved: Decimal
    invested_total: Decimal
    monthly_pace: Decimal
    annual_rate: Decimal
    projection_years: int
    projected_total: Decimal
    projected_interest: Decimal
    monthly_series: list[MonthlySavingPoint]
    projection_series: list[ProjectionPoint]
    impulse_totals: list[ImpulseTotal]
    recent_events: list[SavingEventResponse]
    goals: list[SavingsGoalResponse]
