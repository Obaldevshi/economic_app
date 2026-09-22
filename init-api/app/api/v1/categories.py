from fastapi import APIRouter, status, Query
from app.core.dependencies import CategoryServiceDep, CurrentUserDep, DatabaseDep
from app.core.responses import SuccessResponse, PaginatedResponse
from app.schemas.category import CategoryCreate, CategoryUpdate, CategoryResponse
from app.constants.messages import CategoryMessages

router = APIRouter()


@router.get("/", status_code=status.HTTP_200_OK)
async def get_categories(
    category_service: CategoryServiceDep,
    current_user: CurrentUserDep,
    page: int = Query(1, ge=1),
    per_page: int = Query(20, ge=1, le=100),
    sort_by: str = Query("id"),
    sort_order: str = Query("desc"),
) -> PaginatedResponse:
    categories, total, page, per_page = category_service.get_user_categories(
        current_user["user_id"],
        page=page,
        per_page=per_page,
        sort_by=sort_by,
        sort_order=sort_order,
    )
    category_responses = [CategoryResponse.model_validate(category) for category in categories]
    return PaginatedResponse(
        message=CategoryMessages.RETRIEVED_SUCCESS.value,
        total=total,
        page=page,
        per_page=per_page,
        data=category_responses,
    )


@router.post("/", status_code=status.HTTP_201_CREATED)
async def create_category(
    category_service: CategoryServiceDep,
    current_user: CurrentUserDep,
    category_data: CategoryCreate
) -> SuccessResponse:
    category = category_service.create_category(current_user["user_id"], category_data)
    category_response = CategoryResponse.model_validate(category)
    return SuccessResponse(message=CategoryMessages.CREATED_SUCCESS.value, data=category_response)


@router.put("/{category_id}", status_code=status.HTTP_200_OK)
async def update_category(
    category_service: CategoryServiceDep,
    current_user: CurrentUserDep,
    category_id: int,
    category_data: CategoryUpdate
) -> SuccessResponse:
    category = category_service.update_category(category_id, current_user["user_id"], category_data)
    category_response = CategoryResponse.model_validate(category)
    return SuccessResponse(message=CategoryMessages.UPDATED_SUCCESS.value, data=category_response)


@router.delete("/{category_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_category(
    category_service: CategoryServiceDep,
    current_user: CurrentUserDep,
    category_id: int
):
    category_service.delete_category(category_id, current_user["user_id"])
