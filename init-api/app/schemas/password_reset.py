from typing import Literal

from pydantic import BaseModel, EmailStr, Field, field_validator


class PasswordResetRequest(BaseModel):
    email: EmailStr = Field(max_length=254)
    language: Literal["ru", "en", "es", "pt", "fr", "de", "zh", "hi", "ar"] = "en"


class PasswordResetConfirm(BaseModel):
    email: EmailStr = Field(max_length=254)
    code: str = Field(pattern=r"^[0-9]{6}$")
    new_password: str = Field(min_length=8, max_length=72)

    @field_validator("new_password")
    @classmethod
    def bcrypt_length(cls, value):
        if len(value.encode("utf-8")) > 72:
            raise ValueError("Password exceeds 72 UTF-8 bytes")
        return value
