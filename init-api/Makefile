.PHONY: dev migrate seed smoke

dev:
	docker compose up --build

migrate:
	alembic upgrade head

seed:
	python3 scripts/seed.py

smoke:
	BASE_URL=$${BASE_URL:-http://localhost:8000}; \
	python3 scripts/smoke_http.py --base-url "$$BASE_URL"
