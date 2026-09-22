from sqlalchemy.orm import Session

from app.core.exceptions import ConflictError, NotFoundError
from app.repositories.category_repository import CategoryRepository
from app.schemas.category import CategoryCreate, CategoryUpdate
from app.constants.messages import CategoryMessages


class CategoryService:
    def __init__(self, db: Session):
        self.repository = CategoryRepository(db)

    def get_user_categories(
        self,
        user_id: int,
        page: int = 1,
        per_page: int = 20,
        sort_by: str = "id",
        sort_order: str = "desc",
    ):
        page = max(page, 1)
        per_page = min(max(per_page, 1), 100)
        items, total = self.repository.get_paginated_by_user_id(
            user_id, page, per_page, sort_by, sort_order
        )
        return items, total, page, per_page

    def create_category(self, user_id: int, category_data: CategoryCreate):
        category = self.repository.get_by_user_id_and_name(user_id, category_data.name)

        if category:
            raise ConflictError(CategoryMessages.ALREADY_EXISTS.value)

        category_dict = category_data.model_dump()
        category_dict.update({'user_id': user_id})

        return self.repository.create(category_dict)

    def update_category(self, category_id: int, user_id: int, category_data: CategoryUpdate):
        category = self.repository.get_by_id(category_id)

        if not category or category.user_id != user_id:
            raise NotFoundError(CategoryMessages.NOT_FOUND.value)

        if category_data.name:
            category_exists = self.repository.get_by_user_id_and_name(user_id, category_data.name)
            if category_exists and category_exists.id != category_id:
                raise ConflictError(CategoryMessages.ALREADY_EXISTS.value)

        return self.repository.update(category, category_data.model_dump(exclude_unset=True))

    def delete_category(self, category_id: int, user_id: int) -> bool:
        category = self.repository.get_by_id(category_id)
        if not category or category.user_id != user_id:
            raise NotFoundError(CategoryMessages.NOT_FOUND.value)

        return self.repository.delete(category_id)
