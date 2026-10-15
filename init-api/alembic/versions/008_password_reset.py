"""Email recovery challenges, shared throttling and session revocation."""
from alembic import op
import sqlalchemy as sa

revision = "008_password_reset"
down_revision = "007_spent_events"
branch_labels = None
depends_on = None


def upgrade():
    op.add_column("users", sa.Column("session_version", sa.Integer(), nullable=False, server_default="0"))
    op.create_table("password_reset_challenges",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("created_at", sa.DateTime()), sa.Column("updated_at", sa.DateTime()),
        sa.Column("email_key", sa.String(64), unique=True, nullable=False),
        sa.Column("user_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="CASCADE")),
        sa.Column("generation", sa.String(32), nullable=False),
        sa.Column("code_hash", sa.String(64)),
        sa.Column("expires_at", sa.DateTime(), nullable=False),
        sa.Column("last_requested_at", sa.DateTime(), nullable=False),
        sa.Column("attempts", sa.Integer(), nullable=False),
    )
    op.create_index("ix_password_reset_challenges_user_id", "password_reset_challenges", ["user_id"])
    op.create_table("password_reset_limits",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("created_at", sa.DateTime()), sa.Column("updated_at", sa.DateTime()),
        sa.Column("bucket_key", sa.String(64), unique=True, nullable=False),
        sa.Column("window_start", sa.DateTime(), nullable=False),
        sa.Column("hits", sa.Integer(), nullable=False),
    )


def downgrade():
    op.drop_table("password_reset_limits")
    op.drop_table("password_reset_challenges")
    op.drop_column("users", "session_version")
