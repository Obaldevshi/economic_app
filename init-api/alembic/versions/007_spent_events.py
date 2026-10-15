"""Keep actual impulse purchases separate from avoided spending."""
from alembic import op
import sqlalchemy as sa

revision = "007_spent_events"
down_revision = "006_offline_sync"
branch_labels = None
depends_on = None


def upgrade():
    op.create_table("spent_events",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("created_at", sa.DateTime()), sa.Column("updated_at", sa.DateTime()),
        sa.Column("user_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False),
        sa.Column("impulse_item_id", sa.Integer(), sa.ForeignKey("impulse_items.id", ondelete="SET NULL")),
        sa.Column("impulse_name", sa.String(120), nullable=False),
        sa.Column("amount", sa.Numeric(12, 2), nullable=False),
        sa.Column("currency_code", sa.String(3), nullable=False, server_default="RUB"),
        sa.Column("occurred_at", sa.DateTime(), nullable=False),
        sa.Column("note", sa.String(500)),
        sa.CheckConstraint("amount > 0", name="ck_spent_amount_positive"),
    )
    op.create_index("ix_spent_events_user_id", "spent_events", ["user_id"])
    op.create_index("ix_spent_events_impulse_item_id", "spent_events", ["impulse_item_id"])


def downgrade():
    op.drop_table("spent_events")
