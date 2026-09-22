import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_template/core/di/di.dart';
import 'package:mobile_template/core/services/session_service.dart';
import 'package:mobile_template/features/auth/presentation/pages/login/bloc/login_bloc.dart';
import 'package:mobile_template/features/auth/presentation/pages/login/login_page.dart';
import 'package:mobile_template/features/auth/presentation/pages/register/bloc/register_bloc.dart';
import 'package:mobile_template/features/auth/presentation/pages/register/register_page.dart';
import 'package:mobile_template/features/auth/presentation/pages/splash_page.dart';
import 'package:mobile_template/features/category/presentation/pages/bloc/category_bloc.dart';
import 'package:mobile_template/features/category/presentation/pages/categories_page.dart';
import 'package:mobile_template/features/home/presentation/pages/home_page.dart';
import 'package:mobile_template/features/profile/domain/dto/profile_dto.dart';
import 'package:mobile_template/features/profile/presentation/pages/bloc/profile_bloc.dart';
import 'package:mobile_template/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:mobile_template/features/profile/presentation/pages/profile_page.dart';
import 'package:mobile_template/features/shell/presentation/pages/main_navigation.dart';

class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const categories = '/categories';
  static const profile = '/profile';
  static const editProfile = '/profile/edit';
}

GoRouter createAppRouter() {
  final sessionService = getIt<SessionService>();
  final navigatorKey = getIt<GlobalKey<NavigatorState>>(
    instanceName: 'navigatorKey',
  );

  return GoRouter(
    navigatorKey: navigatorKey,
    refreshListenable: sessionService,
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final isLoggedIn = sessionService.isLoggedIn();
      final location = state.matchedLocation;
      final isAuthRoute =
          location == AppRoutes.login || location == AppRoutes.register;
      final isSplash = location == AppRoutes.splash;

      if (isSplash) return null;

      if (!isLoggedIn && !isAuthRoute) {
        return AppRoutes.login;
      }

      if (isLoggedIn && isAuthRoute) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
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
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.categories,
                builder: (context, state) => BlocProvider(
                  create: (_) => getIt<CategoryBloc>()..add(GetCategoryEvent()),
                  child: const CategoriesPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              ShellRoute(
                builder: (context, state, child) => BlocProvider(
                  create: (_) => getIt<ProfileBloc>()..add(GetProfileEvent()),
                  child: child,
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
