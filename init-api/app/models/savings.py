from sqlalchemy import Boolean, CheckConstraint, Column, Date, DateTime, ForeignKey, Integer, Numeric, String
from sqlalchemy.orm import relationship

from .base import Base


class ImpulseItem(Base):
    __tablename__ = "impulse_items"

    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    name = Column(String(120), nullable=False)
    currency_code = Column(String(3), nullable=False, default="RUB", server_default="RUB")
    default_amount = Column(Numeric(12, 2), nullable=False)
    icon_key = Column(String(40), nullable=False, default="other")
    weekly_frequency = Column(Integer, nullable=False, default=1)
    is_active = Column(Boolean, nullable=False, default=True)

    user = relationship("User", back_populates="impulse_items")
    saving_events = relationship("SavingEvent", back_populates="impulse_item")


class SavingEvent(Base):
    __tablename__ = "saving_events"

    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    impulse_item_id = Column(
        Integer,
        ForeignKey("impulse_items.id", ondelete="SET NULL"),
        nullable=True,
        index=True,
    )
    impulse_name = Column(String(120), nullable=False)
    amount = Column(Numeric(12, 2), nullable=False)
    currency_code = Column(String(3), nullable=False, default="RUB", server_default="RUB")
    occurred_at = Column(DateTime, nullable=False)
    is_invested = Column(Boolean, nullable=False, default=False)
    note = Column(String(500), nullable=True)

    user = relationship("User", back_populates="saving_events")
    impulse_item = relationship("ImpulseItem", back_populates="saving_events")


class SavingsGoal(Base):
    __tablename__ = "savings_goals"
    __table_args__ = (
        CheckConstraint("allocated_amount >= 0", name="ck_goal_allocation_nonnegative"),
    )

    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    name = Column(String(120), nullable=False)
    currency_code = Column(String(3), nullable=False, default="RUB", server_default="RUB")
    target_amount = Column(Numeric(12, 2), nullable=False)
    target_date = Column(Date, nullable=True)
    allocated_amount = Column(Numeric(12, 2), nullable=False, default=0, server_default="0")

    user = relationship("User", back_populates="savings_goals")


class SavingsSettings(Base):
    __tablename__ = "savings_settings"

    user_id = Column(
        Integer,
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        unique=True,
        index=True,
    )
    annual_rate = Column(Numeric(5, 2), nullable=False, default=12)
    projection_years = Column(Integer, nullable=False, default=5)
    currency_code = Column(String(3), nullable=False, default="RUB", server_default="RUB")
    financial_region = Column(String(2), nullable=False, default="RU", server_default="RU")
    display_currency = Column(String(3), nullable=False, default="RUB", server_default="RUB")

    user = relationship("User", back_populates="savings_settings")
