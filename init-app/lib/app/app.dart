import 'package:mobile_template/app/app_router.dart';
import 'package:mobile_template/core/di/di.dart';
import 'package:mobile_template/core/services/connectivity_service.dart';
import 'package:mobile_template/core/services/locale_service.dart';
import 'package:mobile_template/core/services/theme_service.dart';
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
  final _connectivityService = getIt<ConnectivityService>();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_themeService, _localeService]),
      builder: (context, _) {
        return MaterialApp.router(
          title: 'Template App',
          debugShowCheckedModeBanner: false,
          routerConfig: _router,
          locale: _localeService.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('ru')],
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _themeService.themeMode,
          builder: (context, child) {
            return StreamBuilder<bool>(
              stream: _connectivityService.onlineStream,
              initialData: _connectivityService.isOnline,
              builder: (context, snapshot) {
                final isOnline = snapshot.data ?? true;
                final appChild = child == null
                    ? null
                    : ColoredBox(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: child,
                      );
                return Stack(
                  children: [
                    ?appChild,
                    if (!isOnline)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Material(
                          color: Colors.red.shade700,
                          child: SafeArea(
                            bottom: false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)?.offlineBanner ??
                                      'No internet connection',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
