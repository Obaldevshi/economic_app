"""Limit forecast horizons to one, three, and five years."""
from alembic import op
import sqlalchemy as sa

revision = "005_projection_periods"
down_revision = "004_financial_currencies"
branch_labels = None
depends_on = None


def upgrade():
    # Only preferences change; savings, allocations, and amounts are untouched.
    # Round unsupported horizons up to the next available period, capped at 5.
    op.execute(sa.text("""
        UPDATE savings_settings
        SET projection_years = CASE
            WHEN projection_years <= 1 THEN 1
            WHEN projection_years <= 3 THEN 3
            ELSE 5
        END
        WHERE projection_years NOT IN (1, 3, 5)
    """))


def downgrade():
    # Previous preferences cannot be recovered; all new values were valid before.
    pass
