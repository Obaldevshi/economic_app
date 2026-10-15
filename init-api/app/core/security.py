from datetime import datetime, timedelta, timezone

import bcrypt
from jose import JWTError, jwt
from fastapi import Depends
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session
from app.config.database import get_db
from app.repositories.user_repository import UserRepository

from app.config.settings import settings
from app.core.exceptions import UnauthorizedError
from app.constants.messages import AuthMessages

# JWT Bearer token
bearer_scheme = HTTPBearer(auto_error=False)


def verify_password(plain_password: str, hashed_password: str) -> bool:
    return bcrypt.checkpw(
        plain_password.encode("utf-8"),
        hashed_password.encode("utf-8"),
    )


def get_password_hash(password: str) -> str:
    return bcrypt.hashpw(
        password.encode("utf-8"),
        bcrypt.gensalt(),
    ).decode("utf-8")


def create_access_token(user_id: str, email: str, expires_delta: timedelta = None, session_version: int = 0) -> str:
    if expires_delta is None:
        expires_delta = timedelta(minutes=settings.access_token_expire_minutes)

    payload = {
        "user_id": user_id,
        "email": email,
        "session_version": session_version,
        "exp": datetime.now(timezone.utc) + expires_delta
    }

    return jwt.encode(payload, settings.secret_key, algorithm=settings.algorithm)


def verify_token(token: str) -> dict:
    try:
        payload = jwt.decode(token, settings.secret_key, algorithms=[settings.algorithm])
        user_id = payload.get("user_id")
        email = payload.get("email")

        if user_id is None or email is None:
            return None

        return payload
    except JWTError:
        return None


def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(bearer_scheme),
    db: Session = Depends(get_db),
) -> dict:
    token = credentials.credentials if credentials else None
    if not token:
        raise UnauthorizedError(AuthMessages.UNAUTHORIZED.value)

    payload = verify_token(token)
    if payload is None:
        raise UnauthorizedError(AuthMessages.UNAUTHORIZED.value)

    # Deleting an account also invalidates its previously issued tokens.
    try:
        user_id = int(payload["user_id"])
    except (TypeError, ValueError):
        raise UnauthorizedError(AuthMessages.UNAUTHORIZED.value)
    user = UserRepository(db).get_by_id(user_id) if user_id > 0 else None
    # Tokens issued before migration 008 belong to version zero. The first
    # password change invalidates them without logging everyone out on deploy.
    if user is None or payload.get("session_version", 0) != user.session_version:
        raise UnauthorizedError(AuthMessages.UNAUTHORIZED.value)

    return payload
