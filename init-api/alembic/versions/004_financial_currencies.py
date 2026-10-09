"""Separate currency ledgers; existing records retain their original RUB unit."""
from alembic import op
import sqlalchemy as sa

revision = "004_financial_currencies"
down_revision = "003_goal_allocations"
branch_labels = None
depends_on = None


def upgrade():
    op.create_table("exchange_rate_cache",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("created_at", sa.DateTime()), sa.Column("updated_at", sa.DateTime()),
        sa.Column("as_of", sa.Date(), nullable=False),
        sa.Column("fetched_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("rub_per_unit", sa.JSON(), nullable=False),
    )
    for table in ("impulse_items", "saving_events", "savings_goals", "savings_settings"):
        op.add_column(table, sa.Column("currency_code", sa.String(3), nullable=False, server_default="RUB"))
    op.add_column("savings_settings", sa.Column("financial_region", sa.String(2), nullable=False, server_default="RU"))
    op.add_column("savings_settings", sa.Column("display_currency", sa.String(3), nullable=False, server_default="RUB"))


def downgrade():
    op.drop_table("exchange_rate_cache")
    op.drop_column("savings_settings", "display_currency")
    op.drop_column("savings_settings", "financial_region")
    for table in ("savings_settings", "savings_goals", "saving_events", "impulse_items"):
        op.drop_column(table, "currency_code")
