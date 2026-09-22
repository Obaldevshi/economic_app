"""Seed demo data for local development."""

from app.config.database import SessionLocal
from app.core.security import get_password_hash
from app.models.user import User
from app.models.category import Category


def seed() -> None:
    db = SessionLocal()
    try:
        demo_email = "demo@template.local"
        user = db.query(User).filter(User.email == demo_email).first()
        if not user:
            user = User(
                email=demo_email,
                first_name="Demo",
                last_name="User",
                hashed_password=get_password_hash("password123"),
            )
            db.add(user)
            db.commit()
            db.refresh(user)
            print(f"Created demo user: {demo_email} / password123")

        existing = db.query(Category).filter(Category.user_id == user.id).count()
        if existing == 0:
            for name in ["Work", "Personal", "Ideas"]:
                db.add(Category(user_id=user.id, name=name))
            db.commit()
            print("Created demo categories")
        else:
            print("Demo categories already exist")
    finally:
        db.close()


if __name__ == "__main__":
    seed()
