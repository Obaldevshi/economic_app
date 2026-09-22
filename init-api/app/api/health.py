from sqlalchemy import text
from fastapi import APIRouter

from app.core.dependencies import DatabaseDep

router = APIRouter(tags=["health"])


@router.get("/health")
async def health():
    return {"status": "ok"}


@router.get("/ready")
async def ready(db: DatabaseDep):
    db.execute(text("SELECT 1"))
    return {"status": "ready"}
