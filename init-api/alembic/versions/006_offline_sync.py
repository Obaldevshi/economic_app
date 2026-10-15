"""Durable per-account acknowledgements for exactly-once offline replay."""
from alembic import op
import sqlalchemy as sa

revision = "006_offline_sync"
down_revision = "005_projection_periods"
branch_labels = None
depends_on = None


def upgrade():
    op.create_table("savings_sync_operations",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("created_at", sa.DateTime()), sa.Column("updated_at", sa.DateTime()),
        sa.Column("user_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False),
        sa.Column("operation_id", sa.String(36), nullable=False),
        sa.Column("request_hash", sa.String(64), nullable=False),
        sa.Column("result", sa.JSON(), nullable=False),
        sa.UniqueConstraint("user_id", "operation_id", name="uq_savings_sync_user_operation"),
    )
    op.create_index("ix_savings_sync_operations_user_id", "savings_sync_operations", ["user_id"])


def downgrade():
    op.drop_table("savings_sync_operations")
