from sqlalchemy import Column, String
from sqlalchemy.orm import relationship
from .base import Base


class User(Base):
    __tablename__ = "users"

    email = Column(String, unique=True, index=True)
    first_name = Column(String)
    last_name = Column(String)
    hashed_password = Column(String)

    categories = relationship("Category", back_populates="user", cascade="all, delete-orphan")
