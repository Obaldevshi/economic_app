# Скиллы шаблона

Общие правила — в [AGENTS.md](../AGENTS.md), выбор пути — в [WORKFLOW.md](WORKFLOW.md). Основные команды: `$10-add-feature` и `$10b-fix-feature`.

## Основные скиллы

- [01-plan](../.agents/skills/01-plan/SKILL.md) — объединённое необязательное планирование идеи, MVP, экранов, сценариев и данных.
- [06-branding](../.agents/skills/06-branding/SKILL.md) — внешний вид приложения.
- [10-add-feature](../.agents/skills/10-add-feature/SKILL.md) — реализация, включая короткий путь для мелких правок.
- [10b-fix-feature](../.agents/skills/10b-fix-feature/SKILL.md) — исправление конкретной ошибки.
- [11-check-feature](../.agents/skills/11-check-feature/SKILL.md) — ручной чек-лист по запросу.
- [13-check-api-timeweb](../.agents/skills/13-check-api-timeweb/SKILL.md) — проверка API перед размещением.

Скиллы из `.agents/skills/` обнаруживаются по descriptions или вызываются явно. Восемь прежних подготовительных скиллов объединены в `01-plan`.

## Helpers

Их читает скилл реализации по необходимости; для мелкой UI-правки helpers не нужны.

- [build-flutter-feature](helper-skill/build-flutter-feature/SKILL.md) — интеграция API по образцу `CategoryRepository` и `CategoryBloc`.
- [build-fastapi-feature](helper-skill/build-fastapi-feature/SKILL.md) — фича на готовых backend-слоях.
- [design-flutter-ui](helper-skill/design-flutter-ui/SKILL.md) — новый экран или существенная переработка UI.

## Timeweb

Начало — [timeweb-deploy](timeweb-deploy/SKILL.md). Отдельные этапы:

- [timeweb-deploy-api](timeweb-deploy-api/SKILL.md) — PostgreSQL и FastAPI.
- [timeweb-deploy-web](timeweb-deploy-web/SKILL.md) — Flutter Web.
- [timeweb-domains](timeweb-domains/SKILL.md) — домены, HTTPS и CORS.
