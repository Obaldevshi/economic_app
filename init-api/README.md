# Backend Template API

Локальный FastAPI backend: JWT auth, профиль, Category CRUD, SQLAlchemy, Alembic и PostgreSQL.

## Запуск

```bash
cp .env.example .env
docker compose up --build
```

- API: `http://localhost:8000`
- Swagger: `http://localhost:8000/docs`
- health: `http://localhost:8000/health`
- readiness: `http://localhost:8000/ready`

## Команды

```bash
make dev
make migrate
make seed
make smoke
```

Для доступа с физического телефона используйте LAN IP компьютера в `init-app/assets/env/.env` и разрешите порт `8000` в firewall.

## Зависимости

Единственный список runtime-зависимостей — `requirements.txt`. Docker и локальный `pip install -r requirements.txt` используют его напрямую; `pip install .` читает тот же файл через `pyproject.toml`. Новую зависимость добавляйте только в `requirements.txt`.

Контейнер слушает `8080`, Docker Compose публикует его на локальном `8000`.
