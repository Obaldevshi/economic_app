import hashlib
import hmac
import logging
import secrets
from datetime import datetime, timedelta

from app.config.database import SessionLocal
from app.config.settings import settings
from app.core.exceptions import BaseError, ValidationError
from app.core.security import get_password_hash
from app.models.password_reset import PasswordResetChallenge, PasswordResetLimit
from app.repositories.password_reset_repository import PasswordResetRepository
from app.services.gmail_service import gmail_service

logger = logging.getLogger(__name__)
INVALID_CODE = "Password reset code is invalid or expired"


def _digest(value):
    return hmac.new(settings.secret_key.encode(), value.encode(), hashlib.sha256).hexdigest()


def _email_key(email):
    return _digest("password-reset-email:" + email.strip().lower())


def _code_hash(key, generation, code):
    return _digest(f"password-reset-code:{key}:{generation}:{code}")


class PasswordResetService:
    def __init__(self, db):
        self.repository = PasswordResetRepository(db)

    def request_code(self, data, client_ip):
        if not gmail_service.configured:
            raise BaseError("Password reset email is unavailable", 503)
        repo, now = self.repository, datetime.utcnow()
        key = _email_key(str(data.email))
        try:
            if not repo.allow(_digest("reset-request-ip:" + client_ip), now, 3600, 60):
                repo.db.commit()
                return None
            # Both known and unknown emails consume the same identity limits.
            repo.lock_key(key)
            challenge = repo.challenge(key)
            if challenge and now - challenge.last_requested_at < timedelta(seconds=60):
                repo.db.commit()
                return None
            if not repo.allow(_digest("reset-request-email:" + key), now, 3600, 5):
                repo.db.commit()
                return None
            user = repo.user_for_email(str(data.email))
            allowed = repo.allow(_digest("reset-send-daily"), now, 86400, settings.password_reset_daily_limit) if user else False
            if user and not allowed and challenge is not None:
                # A resend blocked by the global mail quota must not invalidate
                # a still-valid code already delivered to the user.
                challenge.last_requested_at = now
                repo.db.commit()
                return None
            generation, code = secrets.token_hex(16), f"{secrets.randbelow(1_000_000):06d}"
            if challenge is None:
                challenge = PasswordResetChallenge(email_key=key)
                repo.db.add(challenge)
            challenge.user_id = user.id if user else None
            challenge.generation = generation
            challenge.code_hash = _code_hash(key, generation, code) if user and allowed else None
            challenge.expires_at = now + timedelta(minutes=10)
            challenge.last_requested_at = now
            challenge.attempts = 0
            recipient = user.email if user and allowed else None
            repo.db.commit()
            # Only the in-memory delivery task sees the raw code.
            return (key, generation, recipient, code, data.language) if recipient else None
        except Exception:
            repo.db.rollback()
            raise

    def confirm(self, data, client_ip):
        repo, now = self.repository, datetime.utcnow()
        key = _email_key(str(data.email))
        try:
            if not repo.allow(_digest("reset-confirm-ip:" + client_ip), now, 3600, 300):
                repo.db.commit()
                raise BaseError("Too many password reset attempts", 429)
            repo.lock_key(key)
            challenge = repo.challenge(key)
            if (challenge is None or challenge.code_hash is None or challenge.user_id is None
                    or challenge.attempts >= 5 or challenge.expires_at <= now):
                repo.db.commit()
                raise ValidationError(INVALID_CODE)
            challenge.attempts += 1
            if not hmac.compare_digest(challenge.code_hash, _code_hash(key, challenge.generation, data.code)):
                if challenge.attempts >= 5:
                    challenge.code_hash = None
                repo.db.commit()
                raise ValidationError(INVALID_CODE)
            user = repo.user_for_update(challenge.user_id)
            if user is None or _email_key(user.email) != key:
                challenge.code_hash = None
                repo.db.commit()
                raise ValidationError(INVALID_CODE)
            # Password replacement, session revocation and consuming the code
            # are one commit. No token or new password is returned to the caller.
            user.hashed_password = get_password_hash(data.new_password)
            user.session_version += 1
            challenge.code_hash = None
            repo.db.commit()
        except Exception:
            repo.db.rollback()
            raise


def deliver_reset_email(key, generation, recipient, code, language):
    try:
        with SessionLocal() as db:
            current = db.query(PasswordResetChallenge).filter_by(email_key=key).first()
            if (current is None or current.generation != generation or current.code_hash is None
                    or current.expires_at <= datetime.utcnow()):
                return
        gmail_service.send_reset(recipient, code, language)
    except Exception as error:
        # Google errors may contain credentials/MIME contents; log no raw detail.
        logger.error("Password reset delivery failed: %s", type(error).__name__)
        try:
            with SessionLocal() as db:
                db.query(PasswordResetChallenge).filter_by(email_key=key, generation=generation).update({"code_hash": None})
                db.commit()
        except Exception:
            logger.error("Password reset delivery status could not be stored")
    finally:
        # No scheduler/Redis needed. Expired security metadata is lazily pruned;
        # never delete a fresh challenge or active rate-limit window.
        try:
            with SessionLocal() as db:
                cutoff = datetime.utcnow() - timedelta(days=2)
                db.query(PasswordResetChallenge).filter(PasswordResetChallenge.last_requested_at < cutoff).delete(synchronize_session=False)
                db.commit()
                db.query(PasswordResetLimit).filter(PasswordResetLimit.window_start < cutoff).delete(synchronize_session=False)
                db.commit()
        except Exception:
            logger.warning("Expired password reset metadata cleanup deferred")
