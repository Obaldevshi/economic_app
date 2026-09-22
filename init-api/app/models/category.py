from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from .base import Base


class Category(Base):
    __tablename__ = "categories"

    user_id = Column(Integer, ForeignKey("users.id"), index=True)
    name = Column(String, index=True)

    user = relationship("User", back_populates="categories")
