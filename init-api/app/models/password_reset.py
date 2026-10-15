from sqlalchemy import Column, DateTime, ForeignKey, Integer, String

from .base import Base


class PasswordResetChallenge(Base):
    __tablename__ = "password_reset_challenges"

    email_key = Column(String(64), unique=True, nullable=False)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=True, index=True)
    generation = Column(String(32), nullable=False)
    code_hash = Column(String(64), nullable=True)
    expires_at = Column(DateTime, nullable=False)
    last_requested_at = Column(DateTime, nullable=False)
    attempts = Column(Integer, nullable=False, default=0)


class PasswordResetLimit(Base):
    __tablename__ = "password_reset_limits"

    bucket_key = Column(String(64), unique=True, nullable=False)
    window_start = Column(DateTime, nullable=False)
    hits = Column(Integer, nullable=False, default=0)
