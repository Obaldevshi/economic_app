from typing import Literal
from uuid import UUID
from pydantic import BaseModel, Field


class SavingsSyncRequest(BaseModel):
    operation_id: UUID
    kind: Literal["create_event", "update_event", "delete_event", "create_impulse",
                  "update_impulse", "delete_impulse", "create_goal", "update_goal",
                  "allocate_goal", "update_settings", "create_spent", "update_spent", "delete_spent"]
    entity_id: int | None = Field(default=None, gt=0)
    payload: dict = Field(default_factory=dict, max_length=16)
    before: dict = Field(default_factory=dict, max_length=16)
    force: bool = False
