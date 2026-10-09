"""Explicit goal allocations; existing money starts unallocated."""
from alembic import op
import sqlalchemy as sa

revision = "003_goal_allocations"
down_revision = "002_savings"
branch_labels = None
depends_on = None


def upgrade():
    op.add_column("savings_goals", sa.Column(
        "allocated_amount", sa.Numeric(12, 2), nullable=False, server_default="0",
    ))
    op.create_check_constraint(
        "ck_goal_allocation_nonnegative", "savings_goals", "allocated_amount >= 0",
    )


def downgrade():
    op.drop_constraint("ck_goal_allocation_nonnegative", "savings_goals", type_="check")
    op.drop_column("savings_goals", "allocated_amount")
