import hashlib
from datetime import timedelta

from sqlalchemy import func, text

from app.models.password_reset import PasswordResetChallenge, PasswordResetLimit
from app.models.user import User
from app.repositories.base import BaseRepository


class PasswordResetRepository(BaseRepository):
    def __init__(self, db):
        super().__init__(db, PasswordResetChallenge)

    def lock_key(self, key):
        lock_id = int.from_bytes(hashlib.sha256(("password-reset:" + key).encode()).digest()[:8],
                                 byteorder="big", signed=True)
        self.db.execute(text("SELECT pg_advisory_xact_lock(:key)"), {"key": lock_id})

    def allow(self, key, now, seconds, maximum):
        # Locks survive until the caller commits: counters work across workers.
        self.lock_key(key)
        row = self.db.query(PasswordResetLimit).filter_by(bucket_key=key).first()
        if row is None:
            row = PasswordResetLimit(bucket_key=key, window_start=now, hits=0)
            self.db.add(row)
        if now - row.window_start >= timedelta(seconds=seconds):
            row.window_start, row.hits = now, 0
        if row.hits >= maximum:
            return False
        row.hits += 1
        self.db.flush()
        return True

    def challenge(self, email_key):
        return self.db.query(PasswordResetChallenge).filter_by(email_key=email_key).populate_existing().with_for_update().first()

    def user_for_email(self, email):
        # Older accounts were case-sensitive. Never choose an arbitrary account
        # if legacy addresses differ only in letter case.
        users = self.db.query(User).filter(func.lower(User.email) == email.lower()).limit(2).all()
        return users[0] if len(users) == 1 else None

    def user_for_update(self, user_id):
        return self.db.query(User).filter_by(id=user_id).populate_existing().with_for_update().first()
