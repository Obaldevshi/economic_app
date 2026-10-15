import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_template/core/di/di.dart';
import 'package:mobile_template/core/services/session_service.dart';
import 'package:mobile_template/core/services/app_lock_service.dart';
import 'package:mobile_template/core/services/offline_savings_service.dart';
import 'package:mobile_template/features/auth/presentation/pages/pin_page.dart';
import 'package:mobile_template/features/auth/presentation/pages/password_reset/password_reset_page.dart';
import 'package:mobile_template/features/auth/presentation/pages/password_reset/bloc/password_reset_bloc.dart';
import 'package:mobile_template/features/auth/presentation/pages/login/bloc/login_bloc.dart';
import 'package:mobile_template/features/auth/presentation/pages/login/login_page.dart';
import 'package:mobile_template/features/auth/presentation/pages/register/bloc/register_bloc.dart';
import 'package:mobile_template/features/auth/presentation/pages/register/register_page.dart';
import 'package:mobile_template/features/auth/presentation/pages/splash_page.dart';
import 'package:mobile_template/features/savings/presentation/pages/bloc/savings_bloc.dart';
import 'package:mobile_template/features/savings/presentation/pages/impulse_items_page.dart';
import 'package:mobile_template/features/savings/presentation/pages/saving_history_page.dart';
import 'package:mobile_template/features/savings/presentation/pages/savings_dashboard_page.dart';
import 'package:mobile_template/features/savings/presentation/pages/spent_page.dart';
import 'package:mobile_template/features/savings/presentation/widgets/savings_branch_content.dart';
import 'package:mobile_template/features/profile/domain/dto/profile_dto.dart';
import 'package:mobile_template/features/profile/presentation/pages/bloc/profile_bloc.dart';
import 'package:mobile_template/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:mobile_template/features/profile/presentation/pages/profile_page.dart';
import 'package:mobile_template/features/profile/presentation/pages/privacy_page.dart';
import 'package:mobile_template/features/shell/presentation/pages/main_navigation.dart';
import 'package:mobile_template/features/shell/presentation/widgets/navigation_branch_scope.dart';

class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const passwordReset = '/password-reset';
  static const home = '/home';
  static const history = '/history';
  static const habits = '/habits';
  static const spent = '/spent';
  static const forecast = '/forecast';
  static const profile = '/profile';
  static const editProfile = '/profile/edit';
  static const privacy = '/privacy';
  static const pin = '/pin';
}

GoRouter createAppRouter() {
  final sessionService = getIt<SessionService>();
  final lock = getIt<AppLockService>();
  final offline = getIt<OfflineSavingsService>();
  final navigatorKey = getIt<GlobalKey<NavigatorState>>(
    instanceName: 'navigatorKey',
  );

  return GoRouter(
    navigatorKey: navigatorKey,
    refreshListenable: Listenable.merge([sessionService, lock]),
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final isLoggedIn = sessionService.isLoggedIn();
      final location = state.matchedLocation;
      final isAuthRoute =
          location == AppRoutes.login || location == AppRoutes.register;
      final isSplash = location == AppRoutes.splash;

      if (location == AppRoutes.privacy) return null;
      // Recovery must stay reachable with an expired session or a locked PIN.
      if (location == AppRoutes.passwordReset) return null;
      if (isSplash) return null;

      if (isLoggedIn &&
          offline.enabled &&
          sessionService.needsOnlineLogin &&
          !offline.hasCachedJournal) {
        return isAuthRoute ? null : '${AppRoutes.login}?reauth=true';
      }

      if (isLoggedIn && lock.passwordRecovery) {
        return isAuthRoute ? null : '${AppRoutes.login}?reauth=true';
      }
      if (isLoggedIn && !lock.accessible) {
        return location == AppRoutes.pin ? null : AppRoutes.pin;
      }
      if (isLoggedIn && location == AppRoutes.pin) return AppRoutes.home;

      if (!isLoggedIn && !isAuthRoute) {
        return AppRoutes.login;
      }

      if (isLoggedIn &&
          isAuthRoute &&
          state.uri.queryParameters['reauth'] != 'true') {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.passwordReset,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<PasswordResetBloc>(),
          child: PasswordResetPage(
            initialEmail: state.extra is String ? state.extra as String : '',
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.pin,
        builder: (context, state) => const PinPage(),
      ),
      GoRoute(
        path: AppRoutes.privacy,
        builder: (context, state) => const PrivacyPage(),
      ),
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<LoginBloc>(),
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<RegisterBloc>(),
          child: const RegisterPage(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainNavigation(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => BlocProvider(
                  create: (_) => getIt<SavingsBloc>()
                    ..add(const LoadSavingsDashboard())
                    ..add(const LoadImpulseItems()),
                  child: const SavingsBranchContent(
                    branch: AppNavigationBranch.home,
                    refreshEvents: [LoadSavingsDashboard(), LoadImpulseItems()],
                    child: SavingsDashboardPage(),
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.history,
                builder: (context, state) => BlocProvider(
                  create: (_) => getIt<SavingsBloc>()
                    ..add(const LoadSavingHistory())
                    ..add(const LoadSavingsDashboard()),
                  child: const SavingsBranchContent(
                    branch: AppNavigationBranch.history,
                    refreshEvents: [
                      LoadSavingHistory(),
                      LoadSavingsDashboard(),
                    ],
                    child: SavingHistoryPage(),
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.habits,
                builder: (context, state) => BlocProvider(
                  create: (_) => getIt<SavingsBloc>()
                    ..add(const LoadSavingsDashboard())
                    ..add(const LoadImpulseItems(withSettings: true)),
                  child: const SavingsBranchContent(
                    branch: AppNavigationBranch.habits,
                    refreshEvents: [
                      LoadSavingsDashboard(),
                      LoadImpulseItems(withSettings: true),
                    ],
                    child: ImpulseItemsPage(),
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.spent,
                builder: (context, state) => BlocProvider(
                  create: (_) => getIt<SavingsBloc>()
                    ..add(const LoadSavingsDashboard())
                    ..add(const LoadImpulseItems())
                    ..add(const LoadSpentHistory()),
                  child: const SavingsBranchContent(
                    branch: AppNavigationBranch.spent,
                    refreshEvents: [
                      LoadSavingsDashboard(),
                      LoadImpulseItems(),
                      LoadSpentHistory(),
                    ],
                    child: SpentPage(),
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.forecast,
                builder: (context, state) => BlocProvider(
                  create: (_) => getIt<SavingsBloc>()
                    ..add(const LoadSavingsDashboard())
                    ..add(const LoadImpulseItems()),
                  child: const SavingsBranchContent(
                    branch: AppNavigationBranch.forecast,
                    refreshEvents: [LoadSavingsDashboard(), LoadImpulseItems()],
                    child: SavingsForecastPage(),
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              ShellRoute(
                builder: (context, state, child) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (_) =>
                          getIt<ProfileBloc>()..add(GetProfileEvent()),
                    ),
                    BlocProvider(
                      create: (_) =>
                          getIt<SavingsBloc>()
                            ..add(const LoadSavingsDashboard()),
                    ),
                  ],
                  child: SavingsBranchContent(
                    branch: AppNavigationBranch.profile,
                    refreshEvents: const [LoadSavingsDashboard()],
                    child: child,
                  ),
                ),
                routes: [
                  GoRoute(
                    path: AppRoutes.profile,
                    builder: (context, state) => const ProfilePage(),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        builder: (context, state) {
                          final profile = state.extra as ProfileDto;
                          return EditProfilePage(profile: profile);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
