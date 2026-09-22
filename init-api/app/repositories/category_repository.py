from typing import Optional, List, Tuple
from sqlalchemy.orm import Session

from app.models.category import Category
from app.repositories.base import BaseRepository


class CategoryRepository(BaseRepository[Category]):
    def __init__(self, db: Session):
        super().__init__(db, Category)

    def get_by_user_id_and_name(self, user_id: int, name: str) -> Optional[Category]:
        return self.db.query(Category).filter(
            Category.user_id == user_id,
            Category.name == name
        ).first()

    def get_by_user_id(self, user_id: int) -> List[Category]:
        return self.db.query(Category).filter(
            Category.user_id == user_id
        ).order_by(Category.id.desc()).all()

    def get_paginated_by_user_id(
        self,
        user_id: int,
        page: int,
        per_page: int,
        sort_by: str = "id",
        sort_order: str = "desc",
    ) -> Tuple[List[Category], int]:
        query = self.db.query(Category).filter(Category.user_id == user_id)
        total = query.count()

        allowed_sort_fields = {"id", "name", "created_at", "updated_at"}
        sort_field = sort_by if sort_by in allowed_sort_fields else "id"
        sort_column = getattr(Category, sort_field)

        if sort_order.lower() == "asc":
            query = query.order_by(sort_column.asc())
        else:
            query = query.order_by(sort_column.desc())

        items = query.offset((page - 1) * per_page).limit(per_page).all()
        return items, total
