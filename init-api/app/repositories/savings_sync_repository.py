from sqlalchemy import text
from app.models.savings_sync import SavingsSyncOperation
from app.repositories.base import BaseRepository


class SavingsSyncRepository(BaseRepository):
    def __init__(self, db):
        super().__init__(db, SavingsSyncOperation)

    def lock_account(self, user_id):
        self.db.execute(text("SELECT pg_advisory_xact_lock(166759, :user_id)"), {"user_id": user_id})

    def find(self, user_id, operation_id):
        return self.db.query(SavingsSyncOperation).filter_by(
            user_id=user_id, operation_id=operation_id).first()
