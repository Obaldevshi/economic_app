import asyncio
import time

from fastapi import APIRouter, BackgroundTasks, Request, status
from starlette.concurrency import run_in_threadpool

from app.core.dependencies import AuthServiceDep, PasswordResetServiceDep
from app.schemas.password_reset import PasswordResetRequest, PasswordResetConfirm
from app.services.password_reset_service import deliver_reset_email
from app.core.responses import SuccessResponse
from app.schemas.auth import LoginRequest
from app.schemas.user import UserCreate, UserResponse
from app.constants.messages import AuthMessages

router = APIRouter()


@router.post("/password-reset/request", response_model=SuccessResponse)
async def request_password_reset(data: PasswordResetRequest, request: Request,
                                 background_tasks: BackgroundTasks, service: PasswordResetServiceDep):
    started = time.monotonic()
    # Do not trust a client-supplied X-Forwarded-For header. Uvicorn may populate
    # client.host from a reverse proxy only when that proxy is explicitly trusted.
    ip = request.client.host if request.client else "unknown"
    delivery = await run_in_threadpool(service.request_code, data, ip)
    if delivery:
        background_tasks.add_task(deliver_reset_email, *delivery)
    # Mail delivery is never awaited and most DB timing differences are padded.
    await asyncio.sleep(max(0, 0.35 - (time.monotonic() - started)))
    return SuccessResponse(message="If this email is registered, a reset code will be sent")


@router.post("/password-reset/confirm", response_model=SuccessResponse)
async def confirm_password_reset(data: PasswordResetConfirm, request: Request, service: PasswordResetServiceDep):
    started = time.monotonic()
    try:
        await run_in_threadpool(service.confirm, data, request.client.host if request.client else "unknown")
    finally:
        await asyncio.sleep(max(0, 0.35 - (time.monotonic() - started)))
    return SuccessResponse(message="Password reset complete")


@router.post("/register", status_code=status.HTTP_201_CREATED)
async def register(
    auth_service: AuthServiceDep,
    user_data: UserCreate
) -> SuccessResponse:
    user = auth_service.create_user(user_data)
    user_response = UserResponse.model_validate(user)
    return SuccessResponse(message=AuthMessages.REGISTER_SUCCESS.value, data=user_response)


@router.post("/login", status_code=status.HTTP_200_OK)
async def login(
    auth_service: AuthServiceDep,
    login_data: LoginRequest
) -> SuccessResponse:
    token = auth_service.authenticate_user(login_data)
    return SuccessResponse(message=AuthMessages.LOGIN_SUCCESS.value, data=token)
