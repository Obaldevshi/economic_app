#!/bin/sh
set -e

export PYTHONUNBUFFERED=1

PORT=8080

echo "=== entrypoint start ==="

if [ -z "$DATABASE_URL" ]; then
  echo "ERROR: DATABASE_URL is empty"
  exit 1
fi

echo "DATABASE_URL is set"
echo "Testing DB connection (10s timeout)..."

python - <<'PY'
import sys

import psycopg2
from app.config.settings import settings

url = settings.database_url
try:
    conn = psycopg2.connect(url, connect_timeout=10)
    conn.close()
    print("DB connection: OK")
except Exception as exc:
    print(f"DB connection: FAIL — {exc}")
    sys.exit(1)
PY

echo "Running migrations..."
alembic upgrade head
echo "Starting API on 0.0.0.0:${PORT}..."
exec uvicorn app.main:app --host 0.0.0.0 --port "${PORT}"
