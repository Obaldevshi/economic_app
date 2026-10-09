# Mobile + Web Template

Готовая Flutter-база для Android/iOS/Web: BLoC, GetIt, Dio/Retrofit, go_router, авторизация, профиль, категории, UI-kit, темы и ARB-локализация.

## Новые функции

Следуйте [AGENTS.md](../AGENTS.md) и [Flutter helper](../skills/helper-skill/build-flutter-feature/SKILL.md). Общие API-модели и repositories остаются в `lib/data/`, экраны — в `lib/features/<feature>/presentation/`. Для новой фичи достаточно `page → BLoC → repository → ApiService`; дополнительные use cases, DTO-копии и mock-реализации не обязательны. Категории уже реализованы по этому образцу; auth/profile сохраняют прежние контракты.

Каждая UI/UX-фича по умолчанию реализуется сразу для мобильного приложения и Flutter Web. Правила адаптива, ввода и навигации — в разделе «UI/UX в init-app» файла [AGENTS.md](../AGENTS.md).

Адаптив через `AppLayoutItemBuilder`: narrow ≤ 550 логических пикселей, wide > 550. Узкий браузер использует narrow; mobile/web разделяют маршруты, состояние и компоненты. При изменении ширины сохраняются введённые данные и текущий сценарий.

## Подключение API и запуск

```bash
cp assets/env/.env.example assets/env/.env
flutter pub get
```

В `.env` укажите API с `/api/v1`: телефон использует `BASE_URL`, браузер — `BASE_URL_WEB`. Для размещённого API используйте HTTPS. В CORS разрешите origin web-клиента, включая `http://localhost:3000` для локального Chrome. Клиентский env не должен содержать секретов.

```bash
flutter run -d <device-id>
flutter run -d chrome --web-port 3000
```

Mock-режима нет; для входа, профиля и категорий нужен доступный API.

На Windows запустите `./tool/start_web.ps1` из PowerShell и откройте
`http://localhost:3000`. Оставьте терминал открытым на время работы.
Файл `web/index.html` — исходный шаблон Flutter, через `file://` он не запускается.

## Генерация по изменению источников

```bash
# Только после изменения ARB
flutter gen-l10n

# После изменения Retrofit / JSON models / assets
# Один запуск после всех связанных правок
dart run build_runner build --delete-conflicting-outputs
```

DI регистрируется вручную в `lib/core/di/di.dart`: repository через `registerLazySingleton`, BLoC через `registerFactory`. Для изменения DI или обычной правки виджета генерация не нужна. `make gen` — необязательная полная подготовка, а не завершение каждой фичи. Анализатор, тесты, запуск приложения и сборки не выполняются агентом автоматически.

## Сборки по запросу

Перед сборкой нужен `assets/env/.env` с целевым API. Production target — `lib/main.dart`, переопределяется через `PROD_TARGET`.

```bash
make build-apk-prod
make build-web-prod
# Обе сборки, только если нужны обе:
make build-prod
```

APK: `build/app/outputs/flutter-apk/app-release.apk`. Web: `build/web/`. После смены API URL web нужно пересобрать.
