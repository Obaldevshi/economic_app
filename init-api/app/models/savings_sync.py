from sqlalchemy import Column, ForeignKey, Integer, JSON, String, UniqueConstraint
from .base import Base


class SavingsSyncOperation(Base):
    __tablename__ = "savings_sync_operations"
    __table_args__ = (UniqueConstraint("user_id", "operation_id", name="uq_savings_sync_user_operation"),)

    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    operation_id = Column(String(36), nullable=False)
    request_hash = Column(String(64), nullable=False)
    result = Column(JSON, nullable=False)
