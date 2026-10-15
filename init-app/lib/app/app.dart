import 'package:mobile_template/app/app_router.dart';
import 'package:mobile_template/core/di/di.dart';
import 'package:mobile_template/core/services/locale_service.dart';
import 'package:mobile_template/core/services/theme_service.dart';
import 'package:mobile_template/core/services/app_lock_service.dart';
import 'package:mobile_template/features/savings/presentation/widgets/sync_status_strip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import '../generated/l10n/app_localizations.dart';
import 'theme/app_theme.dart';

class MobileTemplateApp extends StatefulWidget {
  const MobileTemplateApp({super.key});

  @override
  State<MobileTemplateApp> createState() => _MobileTemplateAppState();
}

class _MobileTemplateAppState extends State<MobileTemplateApp> {
  late final GoRouter _router = createAppRouter();
  final _themeService = getIt<ThemeService>();
  final _localeService = getIt<LocaleService>();
  late final AppLifecycleListener _lifecycle;
  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onInactive: () => getIt<AppLockService>().lock(),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_themeService, _localeService]),
      builder: (context, _) {
        final language =
            (_localeService.locale ??
                    WidgetsBinding.instance.platformDispatcher.locale)
                .languageCode;
        ThemeData readableTheme(ThemeData theme) =>
            language == 'ar' || language == 'hi'
            ? theme.copyWith(
                textTheme: theme.textTheme.apply(letterSpacingFactor: 0),
              )
            : theme;
        return MaterialApp.router(
          title: 'Не потратил',
          debugShowCheckedModeBanner: false,
          routerConfig: _router,
          locale: _localeService.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          localeListResolutionCallback: (locales, supported) {
            for (final locale in locales ?? <Locale>[]) {
              for (final candidate in supported) {
                if (candidate.languageCode == locale.languageCode) {
                  return candidate;
                }
              }
            }
            return const Locale('en');
          },
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
          theme: readableTheme(
            AppTheme.withSeed(AppTheme.lightTheme, _themeService.lightSeed),
          ),
          darkTheme: readableTheme(
            AppTheme.withSeed(AppTheme.darkTheme, _themeService.darkSeed),
          ),
          themeMode: _themeService.themeMode,
          builder: (context, child) {
            return Column(
              children: [
                Expanded(
                  child: ColoredBox(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: child ?? const SizedBox.shrink(),
                  ),
                ),
                SyncStatusStrip(
                  onLogin: () => _router.go('${AppRoutes.login}?reauth=true'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
