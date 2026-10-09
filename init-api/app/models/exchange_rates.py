from sqlalchemy import Column, Date, DateTime, JSON
from .base import Base


class ExchangeRateCache(Base):
    __tablename__ = "exchange_rate_cache"
    as_of = Column(Date, nullable=False)
    fetched_at = Column(DateTime(timezone=True), nullable=False)
    rub_per_unit = Column(JSON, nullable=False)
