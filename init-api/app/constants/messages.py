from enum import Enum


class ValidationMessages(Enum):
    PASSWORD_TOO_SHORT = "Password must be at least 8 characters long"
    INVALID_EMAIL = "Invalid email format"


class AuthMessages(Enum):
    LOGIN_SUCCESS = "Login successful"
    REGISTER_SUCCESS = "Register successful"
    USER_NOT_FOUND = "User not found"
    INVALID_PASSWORD = "Invalid password"
    ALREADY_EXISTS = "User already exists"
    TOKEN_EXPIRED = "Token has expired"
    UNAUTHORIZED = "Unauthorized access"


class UserMessages(Enum):
    RETRIEVED_SUCCESS = "Profile retrieved successfully"
    UPDATED_SUCCESS = "Profile updated successfully"
    PASSWORD_CHANGED_SUCCESS = "Password changed successfully"
    INVALID_CURRENT_PASSWORD = "Invalid current password"


class CategoryMessages(Enum):
    CREATED_SUCCESS = "Category created successfully"
    UPDATED_SUCCESS = "Category updated successfully"
    DELETED_SUCCESS = "Category deleted successfully"
    RETRIEVED_SUCCESS = "Categories retrieved successfully"
    NOT_FOUND = "Category not found"
    ALREADY_EXISTS = "Category already exists"


class ErrorMessages(Enum):
    INTERNAL_SERVER_ERROR = "An internal server error occurred"
    NOT_FOUND = "Resource not found"
    FORBIDDEN = "Access forbidden"
    BAD_REQUEST = "Bad request"
