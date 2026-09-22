---
name: build-fastapi-feature
description: Добавить или изменить FastAPI endpoint по существующей структуре категорий. Использовать для запросов к БД и бизнес-правил, без новой архитектуры и инфраструктуры.
---

# FastAPI-фича

Структура, общие ограничения и проверки описаны в корневом `AGENTS.md`. Образец — `categories`.

1. Переиспользуй `BaseRepository` для CRUD; недостающие запросы добавь в repository, правила — в service. Сохраняй `Service(db) → Repository(db)` и sync SQLAlchemy.
2. Согласуй routes/schemas с Flutter: используй текущие response envelopes и общие ошибки. Сохрани ограничения pagination и whitelist сортировки.
3. При многошаговой записи учти, что методы `BaseRepository` коммитят отдельные операции. Составному сценарию нужна одна транзакция без промежуточных commit.
4. Подключи dependency в `core/dependencies.py`, router в `api/v1/router.py`. Для новой модели обнови Alembic imports/metadata и создай миграцию.
5. Зависимости добавляй только в `init-api/requirements.txt`; `pyproject.toml` читает этот же список.
