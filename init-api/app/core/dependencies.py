from typing import Annotated
from fastapi import Depends
from sqlalchemy.orm import Session

from app.config.database import get_db
from app.services.auth_service import AuthService
from app.services.category_service import CategoryService
from app.services.user_service import UserService
from app.core.security import get_current_user


DatabaseDep = Annotated[Session, Depends(get_db)]
CurrentUserDep = Annotated[dict, Depends(get_current_user)]


def get_user_service(db: DatabaseDep) -> UserService:
    return UserService(db)


def get_auth_service(db: DatabaseDep) -> AuthService:
    return AuthService(db)


def get_category_service(db: DatabaseDep) -> CategoryService:
    return CategoryService(db)


UserServiceDep = Annotated[UserService, Depends(get_user_service)]
AuthServiceDep = Annotated[AuthService, Depends(get_auth_service)]
CategoryServiceDep = Annotated[CategoryService, Depends(get_category_service)]
