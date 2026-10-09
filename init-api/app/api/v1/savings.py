from fastapi import APIRouter, Query, status

from app.core.dependencies import CurrentUserDep, SavingsServiceDep
from app.core.responses import PaginatedResponse, SuccessResponse
from app.schemas.savings import (
    ImpulseItemCreate,
    ImpulseItemResponse,
    ImpulseItemUpdate,
    SavingEventCreate,
    SavingEventResponse,
    SavingEventUpdate,
    SavingsDashboardResponse,
    SavingsGoalCreate,
    SavingsGoalResponse,
    SavingsGoalUpdate,
    SavingsSettingsResponse,
    SavingsSettingsUpdate,
    GoalAllocationUpdate,
    WeeklyReceiptResponse,
)

router = APIRouter()


@router.get("/receipts/week", response_model=SuccessResponse)
async def weekly_receipt(service: SavingsServiceDep, current_user: CurrentUserDep):
    return SuccessResponse(message="Weekly receipt retrieved", data=WeeklyReceiptResponse.model_validate(
        service.get_weekly_receipt(current_user["user_id"]),
    ))


@router.put("/goals/{goal_id}/allocation", response_model=SuccessResponse)
async def allocate_goal(goal_id: int, service: SavingsServiceDep, current_user: CurrentUserDep, data: GoalAllocationUpdate):
    goal = service.allocate_goal(goal_id, current_user["user_id"], data.allocated_amount)
    return SuccessResponse(message="Goal allocation updated", data=SavingsGoalResponse.model_validate(goal))


@router.get("/dashboard", response_model=SuccessResponse)
async def get_dashboard(service: SavingsServiceDep, current_user: CurrentUserDep):
    data = SavingsDashboardResponse.model_validate(service.get_dashboard(current_user["user_id"]))
    return SuccessResponse(message="Savings dashboard retrieved", data=data)


@router.get("/impulses", response_model=SuccessResponse)
async def get_impulses(
    service: SavingsServiceDep,
    current_user: CurrentUserDep,
    include_inactive: bool = Query(False),
):
    items = service.get_impulses(current_user["user_id"], include_inactive)
    return SuccessResponse(message="Impulse items retrieved", data=[ImpulseItemResponse.model_validate(item) for item in items])


@router.post("/impulses", status_code=status.HTTP_201_CREATED, response_model=SuccessResponse)
async def create_impulse(service: SavingsServiceDep, current_user: CurrentUserDep, data: ImpulseItemCreate):
    item = service.create_impulse(current_user["user_id"], data)
    return SuccessResponse(message="Impulse item created", data=ImpulseItemResponse.model_validate(item))


@router.put("/impulses/{item_id}", response_model=SuccessResponse)
async def update_impulse(item_id: int, service: SavingsServiceDep, current_user: CurrentUserDep, data: ImpulseItemUpdate):
    item = service.update_impulse(item_id, current_user["user_id"], data)
    return SuccessResponse(message="Impulse item updated", data=ImpulseItemResponse.model_validate(item))


@router.delete("/impulses/{item_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_impulse(item_id: int, service: SavingsServiceDep, current_user: CurrentUserDep):
    service.delete_impulse(item_id, current_user["user_id"])


@router.get("/events", response_model=PaginatedResponse)
async def get_events(
    service: SavingsServiceDep,
    current_user: CurrentUserDep,
    page: int = Query(1, ge=1),
    per_page: int = Query(50, ge=1, le=100),
):
    items, total, page, per_page = service.get_events(current_user["user_id"], page, per_page)
    return PaginatedResponse(
        message="Saving events retrieved",
        total=total,
        page=page,
        per_page=per_page,
        data=[SavingEventResponse.model_validate(item) for item in items],
    )


@router.post("/events", status_code=status.HTTP_201_CREATED, response_model=SuccessResponse)
async def create_event(service: SavingsServiceDep, current_user: CurrentUserDep, data: SavingEventCreate):
    event = service.create_event(current_user["user_id"], data)
    return SuccessResponse(message="Saving recorded", data=SavingEventResponse.model_validate(event))


@router.put("/events/{event_id}", response_model=SuccessResponse)
async def update_event(event_id: int, service: SavingsServiceDep, current_user: CurrentUserDep, data: SavingEventUpdate):
    event = service.update_event(event_id, current_user["user_id"], data)
    return SuccessResponse(message="Saving updated", data=SavingEventResponse.model_validate(event))


@router.delete("/events/{event_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_event(event_id: int, service: SavingsServiceDep, current_user: CurrentUserDep):
    service.delete_event(event_id, current_user["user_id"])


@router.get("/goals", response_model=SuccessResponse)
async def get_goals(service: SavingsServiceDep, current_user: CurrentUserDep):
    goals = service.get_goals(current_user["user_id"])
    return SuccessResponse(message="Savings goals retrieved", data=[SavingsGoalResponse.model_validate(goal) for goal in goals])


@router.post("/goals", status_code=status.HTTP_201_CREATED, response_model=SuccessResponse)
async def create_goal(service: SavingsServiceDep, current_user: CurrentUserDep, data: SavingsGoalCreate):
    goal = service.create_goal(current_user["user_id"], data)
    return SuccessResponse(message="Savings goal created", data=SavingsGoalResponse.model_validate(goal))


@router.put("/goals/{goal_id}", response_model=SuccessResponse)
async def update_goal(goal_id: int, service: SavingsServiceDep, current_user: CurrentUserDep, data: SavingsGoalUpdate):
    goal = service.update_goal(goal_id, current_user["user_id"], data)
    return SuccessResponse(message="Savings goal updated", data=SavingsGoalResponse.model_validate(goal))


@router.delete("/goals/{goal_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_goal(goal_id: int, service: SavingsServiceDep, current_user: CurrentUserDep):
    service.delete_goal(goal_id, current_user["user_id"])


@router.get("/settings", response_model=SuccessResponse)
async def get_settings(service: SavingsServiceDep, current_user: CurrentUserDep):
    settings = service.get_settings(current_user["user_id"])
    return SuccessResponse(message="Savings settings retrieved", data=SavingsSettingsResponse.model_validate(settings))


@router.put("/settings", response_model=SuccessResponse)
async def update_settings(service: SavingsServiceDep, current_user: CurrentUserDep, data: SavingsSettingsUpdate):
    settings = service.update_settings(current_user["user_id"], data)
    return SuccessResponse(message="Savings settings updated", data=SavingsSettingsResponse.model_validate(settings))
