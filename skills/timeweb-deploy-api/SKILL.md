---
name: timeweb-deploy-api
description: Развернуть или обновить FastAPI Dockerfile App и необходимую PostgreSQL в Timeweb в рамках запрошенного деплоя. Локальный Docker Compose и документы pipeline не требуются.
---

# Timeweb: PostgreSQL и FastAPI

1. Возьми ветку, доступные ресурсы и результат проверки API из текущего контекста; существующий журнал прогресса прочитай при наличии.
2. Проверь доступ Timeweb к репозиторию. Переиспользуй подходящие PostgreSQL/App; перед созданием новых получи согласие на актуальную стоимость, если его ещё нет.
3. Для нового стенда используй managed PostgreSQL и API в одной приватной сети. Получи host/port/database/user из панели. Пароль URL-кодируй в `DATABASE_URL`, сам URL не записывай в git/отчёты.
4. Для Dockerfile App укажи директорию проекта `/init-api`, порт `8080`, ту же приватную сеть; build/start-команды оставь из Dockerfile. Настройки и доступность опций сверяй с текущей панелью.
5. Задай `DATABASE_URL`, `SECRET_KEY`, `ALGORITHM=HS256`, `ACCESS_TOKEN_EXPIRE_MINUTES=30`, `APP_NAME`, `APP_VERSION`, `DEBUG=false`, `CORS_ORIGINS` для нужных web origins, включая `http://localhost:3000` при локальной web-разработке.
6. Дождись завершения миграций и запуска Uvicorn. Проверь `/health` и `/ready`, при необходимости `/docs`; не считай один успешный build доказательством работы API.
7. Обнови локальный `init-app/assets/env/.env`: `BASE_URL` и `BASE_URL_WEB` — HTTPS URL API с `/api/v1`.
8. Сообщи публичный URL и фактический результат. Обнови журнал, только если он ведётся. При блокере API не выдавай web за рабочую интеграцию.
