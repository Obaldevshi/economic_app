"""Savings feature

Revision ID: 002_savings
Revises: 001_initial
Create Date: 2026-09-22
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


revision: str = "002_savings"
down_revision: Union[str, None] = "001_initial"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        "impulse_items",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("created_at", sa.DateTime(), nullable=True),
        sa.Column("updated_at", sa.DateTime(), nullable=True),
        sa.Column("user_id", sa.Integer(), nullable=False),
        sa.Column("name", sa.String(length=120), nullable=False),
        sa.Column("default_amount", sa.Numeric(12, 2), nullable=False),
        sa.Column("icon_key", sa.String(length=40), nullable=False),
        sa.Column("weekly_frequency", sa.Integer(), nullable=False),
        sa.Column("is_active", sa.Boolean(), nullable=False),
        sa.ForeignKeyConstraint(["user_id"], ["users.id"], ondelete="CASCADE"),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(op.f("ix_impulse_items_id"), "impulse_items", ["id"])
    op.create_index(op.f("ix_impulse_items_user_id"), "impulse_items", ["user_id"])

    op.create_table(
        "saving_events",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("created_at", sa.DateTime(), nullable=True),
        sa.Column("updated_at", sa.DateTime(), nullable=True),
        sa.Column("user_id", sa.Integer(), nullable=False),
        sa.Column("impulse_item_id", sa.Integer(), nullable=True),
        sa.Column("impulse_name", sa.String(length=120), nullable=False),
        sa.Column("amount", sa.Numeric(12, 2), nullable=False),
        sa.Column("occurred_at", sa.DateTime(), nullable=False),
        sa.Column("is_invested", sa.Boolean(), nullable=False),
        sa.Column("note", sa.String(length=500), nullable=True),
        sa.ForeignKeyConstraint(["impulse_item_id"], ["impulse_items.id"], ondelete="SET NULL"),
        sa.ForeignKeyConstraint(["user_id"], ["users.id"], ondelete="CASCADE"),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(op.f("ix_saving_events_id"), "saving_events", ["id"])
    op.create_index(op.f("ix_saving_events_impulse_item_id"), "saving_events", ["impulse_item_id"])
    op.create_index(op.f("ix_saving_events_user_id"), "saving_events", ["user_id"])

    op.create_table(
        "savings_goals",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("created_at", sa.DateTime(), nullable=True),
        sa.Column("updated_at", sa.DateTime(), nullable=True),
        sa.Column("user_id", sa.Integer(), nullable=False),
        sa.Column("name", sa.String(length=120), nullable=False),
        sa.Column("target_amount", sa.Numeric(12, 2), nullable=False),
        sa.Column("target_date", sa.Date(), nullable=True),
        sa.ForeignKeyConstraint(["user_id"], ["users.id"], ondelete="CASCADE"),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(op.f("ix_savings_goals_id"), "savings_goals", ["id"])
    op.create_index(op.f("ix_savings_goals_user_id"), "savings_goals", ["user_id"])

    op.create_table(
        "savings_settings",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("created_at", sa.DateTime(), nullable=True),
        sa.Column("updated_at", sa.DateTime(), nullable=True),
        sa.Column("user_id", sa.Integer(), nullable=False),
        sa.Column("annual_rate", sa.Numeric(5, 2), nullable=False),
        sa.Column("projection_years", sa.Integer(), nullable=False),
        sa.ForeignKeyConstraint(["user_id"], ["users.id"], ondelete="CASCADE"),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint("user_id"),
    )
    op.create_index(op.f("ix_savings_settings_id"), "savings_settings", ["id"])
    op.create_index(op.f("ix_savings_settings_user_id"), "savings_settings", ["user_id"])


def downgrade() -> None:
    op.drop_table("savings_settings")
    op.drop_table("savings_goals")
    op.drop_table("saving_events")
    op.drop_table("impulse_items")
