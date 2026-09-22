from fastapi import APIRouter
from . import auth, categories, user

api_router = APIRouter(prefix="/api/v1")

api_router.include_router(auth.router, prefix="/auth", tags=["authentication"])
api_router.include_router(categories.router, prefix="/categories", tags=["categories"])
api_router.include_router(user.router, prefix="/users", tags=["users"])
