from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship
from .base import Base


class User(Base):
    __tablename__ = "users"

    email = Column(String, unique=True, index=True)
    first_name = Column(String)
    last_name = Column(String)
    hashed_password = Column(String)
    session_version = Column(Integer, nullable=False, default=0, server_default="0")

    categories = relationship("Category", back_populates="user", cascade="all, delete-orphan")
    impulse_items = relationship("ImpulseItem", back_populates="user", cascade="all, delete-orphan")
    saving_events = relationship("SavingEvent", back_populates="user", cascade="all, delete-orphan")
    savings_goals = relationship("SavingsGoal", back_populates="user", cascade="all, delete-orphan")
    savings_settings = relationship("SavingsSettings", back_populates="user", cascade="all, delete-orphan", uselist=False)
