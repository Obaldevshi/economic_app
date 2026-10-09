.PHONY: gen gen-l10n gen-build pub-get gen-icons check-prod-env build-apk-prod build-web-prod build-prod

PROD_TARGET ?= lib/main.dart

## Install dependencies
pub-get:
	flutter pub get

## Generate ARB localizations → lib/generated/l10n/
gen-l10n:
	flutter gen-l10n

## Generate assets, Retrofit, JSON → via build_runner
gen-build:
	dart run build_runner build

## Generate iOS/Android launcher icons from assets/images/app_icon.png
gen-icons:
	dart run flutter_launcher_icons

## Full autogen: pub get + l10n + build_runner (assets, retrofit, json)
gen: pub-get gen-l10n gen-build
	@echo "Code generation complete."

## Stop before a release build when the production API config is missing
check-prod-env:
	@$(if $(wildcard assets/env/.env),echo "Production env: assets/env/.env",$(error Missing assets/env/.env. Copy assets/env/.env.example and set the Timeweb API URL))

## Build a release APK connected to the API from assets/env/.env
## Output: build/app/outputs/flutter-apk/app-release.apk
build-apk-prod: check-prod-env pub-get
	flutter build apk --release --target=$(PROD_TARGET)
	@echo "APK: build/app/outputs/flutter-apk/app-release.apk"

## Build release Flutter Web for Timeweb Static App
## Output: build/web/
build-web-prod: check-prod-env pub-get
	flutter build web --release --no-web-resources-cdn --target=$(PROD_TARGET)
	@echo "Web: build/web/"

## Build both production artifacts
build-prod: build-apk-prod build-web-prod
	@echo "Production APK and Web artifacts are ready."
