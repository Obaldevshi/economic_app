import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_template/core/interceptors/auth_interceptor.dart';
import 'package:mobile_template/core/services/connectivity_service.dart';
import 'package:mobile_template/core/services/locale_service.dart';
import 'package:mobile_template/core/services/session_service.dart';
import 'package:mobile_template/core/services/savings_native_service.dart';
import 'package:mobile_template/core/services/theme_service.dart';
import 'package:mobile_template/data/datasources/remote/api_service.dart';
import 'package:mobile_template/data/repositories/auth_repository_impl.dart';
import 'package:mobile_template/data/repositories/category_repository.dart';
import 'package:mobile_template/data/repositories/savings_repository.dart';
import 'package:mobile_template/domain/repositories/auth_repository.dart';
import 'package:mobile_template/features/auth/domain/usecases/login_usecase.dart';
import 'package:mobile_template/features/auth/domain/usecases/register_usecase.dart';
import 'package:mobile_template/features/auth/presentation/pages/login/bloc/login_bloc.dart';
import 'package:mobile_template/features/auth/presentation/pages/register/bloc/register_bloc.dart';
import 'package:mobile_template/features/category/presentation/pages/bloc/category_bloc.dart';
import 'package:mobile_template/features/savings/presentation/pages/bloc/savings_bloc.dart';
import 'package:mobile_template/features/profile/domain/usecases/change_password_usecase.dart';
import 'package:mobile_template/features/profile/domain/usecases/delete_account_usecase.dart';
import 'package:mobile_template/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:mobile_template/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:mobile_template/features/profile/presentation/pages/bloc/profile_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final preferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(preferences);
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ),
  );

  // Restore the session before creating the router or making API requests.
  final session = await SessionService.create(
    getIt<FlutterSecureStorage>(),
    preferences,
  );
  getIt.registerSingleton<SessionService>(session);
  final nativeSavings = SavingsNativeService(preferences, session);
  await nativeSavings.init();
  getIt.registerSingleton<SavingsNativeService>(nativeSavings);
  getIt.registerLazySingleton<LocaleService>(
    () =>
        LocaleService(preferences, onChanged: nativeSavings.setLanguage)
          ..init(),
    dispose: (service) => service.dispose(),
  );
  getIt.registerLazySingleton<ThemeService>(
    () => ThemeService(preferences)..init(),
  );
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  getIt.registerLazySingleton<ConnectivityService>(
    () => ConnectivityService(getIt<Connectivity>())..init(),
    dispose: (service) => service.dispose(),
  );
  getIt.registerLazySingleton<GlobalKey<NavigatorState>>(
    () => GlobalKey<NavigatorState>(),
    instanceName: 'navigatorKey',
  );

  getIt.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(getIt<SessionService>()),
  );
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );
    dio.interceptors.add(getIt<AuthInterceptor>());
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final language =
              (getIt<LocaleService>().locale ??
                      WidgetsBinding.instance.platformDispatcher.locale)
                  .languageCode;
          options.headers['X-Financial-Region'] = switch (language) {
            'ru' => 'RU',
            'es' => 'ES',
            'fr' => 'FR',
            'de' => 'DE',
            'pt' => 'BR',
            'zh' => 'CN',
            'hi' => 'IN',
            'ar' => 'SA',
            _ => 'US',
          };
          handler.next(options);
        },
      ),
    );
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
    return dio;
  });
  getIt.registerLazySingleton<ApiService>(
    () => ApiService(
      getIt<Dio>(),
      baseUrl: kIsWeb
          ? dotenv.env['BASE_URL_WEB'] ?? dotenv.env['BASE_URL'] ?? ''
          : dotenv.env['BASE_URL'] ?? '',
    ),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<ApiService>(), getIt<SessionService>()),
  );
  getIt.registerFactory<LoginUsecase>(
    () => LoginUsecase(getIt<AuthRepository>()),
  );
  getIt.registerFactory<RegisterUsecase>(
    () => RegisterUsecase(getIt<AuthRepository>()),
  );
  getIt.registerFactory<GetProfileUsecase>(
    () => GetProfileUsecase(getIt<AuthRepository>()),
  );
  getIt.registerFactory<UpdateProfileUsecase>(
    () => UpdateProfileUsecase(getIt<AuthRepository>()),
  );
  getIt.registerFactory<DeleteAccountUsecase>(
    () => DeleteAccountUsecase(getIt<AuthRepository>()),
  );
  getIt.registerFactory<ChangePasswordUsecase>(
    () => ChangePasswordUsecase(getIt<AuthRepository>()),
  );
  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(loginUsecase: getIt<LoginUsecase>()),
  );
  getIt.registerFactory<RegisterBloc>(
    () => RegisterBloc(getIt<RegisterUsecase>()),
  );
  getIt.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      getIt<GetProfileUsecase>(),
      getIt<UpdateProfileUsecase>(),
      getIt<DeleteAccountUsecase>(),
      getIt<ChangePasswordUsecase>(),
    ),
  );

  // New features follow the category pattern: one repository and one BLoC.
  getIt.registerLazySingleton<CategoryRepository>(
    () => CategoryRepository(getIt<ApiService>()),
  );
  getIt.registerFactory<CategoryBloc>(
    () => CategoryBloc(getIt<CategoryRepository>()),
  );
  getIt.registerLazySingleton<SavingsRepository>(
    () => SavingsRepository(getIt<ApiService>()),
  );
  getIt.registerFactory<SavingsBloc>(
    () =>
        SavingsBloc(getIt<SavingsRepository>(), getIt<SavingsNativeService>()),
  );
}
