import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_template/core/errors/failure.dart';
import 'package:mobile_template/core/interceptors/auth_interceptor.dart';
import 'package:mobile_template/core/services/session_service.dart';
import 'package:mobile_template/data/datasources/remote/api_service.dart';
import 'package:mobile_template/data/repositories/password_reset_repository.dart';
import 'package:mobile_template/features/auth/presentation/pages/password_reset/bloc/password_reset_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SessionService session;
  late Dio dio;
  late PasswordResetBloc bloc;
  late List<RequestOptions> requests;
  DioExceptionType? networkError;
  int status = 200;

  setUp(() async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    session = await SessionService.create(
      const FlutterSecureStorage(),
      await SharedPreferences.getInstance(),
    );
    final claims = base64Url.encode(
      utf8.encode(jsonEncode({'user_id': 42, 'email': 'test@example.test'})),
    );
    await session.saveToken(
      accessToken: 'test.$claims.signature',
      tokenType: 'Bearer',
      expiresIn: 3600,
    );
    requests = [];
    networkError = null;
    status = 200;
    dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1'));
    dio.interceptors.add(AuthInterceptor(session));
    // Intercept before transport: these tests never send mail or touch accounts.
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) {
          requests.add(request);
          if (networkError != null) {
            handler.reject(
              DioException(requestOptions: request, type: networkError!),
              true,
            );
          } else if (status >= 400) {
            handler.reject(
              DioException(
                requestOptions: request,
                type: DioExceptionType.badResponse,
                response: Response(
                  requestOptions: request,
                  statusCode: status,
                  data: {'message': 'Invalid code'},
                ),
              ),
              true,
            );
          } else {
            handler.resolve(
              Response(
                requestOptions: request,
                statusCode: status,
                data: {'message': 'OK', 'data': null},
              ),
            );
          }
        },
      ),
    );
    bloc = PasswordResetBloc(PasswordResetRepository(ApiService(dio), session));
  });

  tearDown(() async {
    await bloc.close();
    dio.close();
    session.dispose();
    debugDefaultTargetPlatformOverride = null;
  });

  Future<PasswordResetState> perform(PasswordResetEvent event) {
    final finished = bloc.stream.firstWhere((state) => !state.busy);
    bloc.add(event);
    return finished.timeout(const Duration(seconds: 5));
  }

  const request = RequestPasswordResetCode('test@example.test', 'ru');
  // Deliberately synthetic credentials, usable only by the intercepted test API.
  const confirm = ConfirmPasswordReset(
    'test@example.test',
    '123456',
    'test-only-password',
  );

  test('request uses public API contract without a bearer token', () async {
    final state = await perform(request);
    expect(state.codeRequested, isTrue);
    expect(state.completed, isFalse);
    expect(state.resendAt!.isAfter(DateTime.now()), isTrue);
    expect(requests.single.path, '/auth/password-reset/request');
    expect(requests.single.data, {
      'email': 'test@example.test',
      'language': 'ru',
    });
    expect(requests.single.headers.containsKey('Authorization'), isFalse);
  });

  test('rapid duplicate requests do not send multiple emails', () async {
    final finished = bloc.stream.firstWhere((state) => state.codeRequested);
    bloc.add(request);
    bloc.add(request);
    await finished;
    bloc.add(request);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(requests, hasLength(1));
  });

  test('network error leaves a retryable email form', () async {
    networkError = DioExceptionType.connectionError;
    final failed = await perform(request);
    expect(failed.failure, isA<NoInternetFailure>());
    expect(failed.codeRequested, isFalse);
    expect(failed.busy, isFalse);
    networkError = null;
    final retried = await perform(request);
    expect(retried.codeRequested, isTrue);
    expect(retried.failure, isNull);
    expect(requests, hasLength(2));
  });

  test('confirm before requesting a code is ignored', () async {
    bloc.add(confirm);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(requests, isEmpty);
    expect(bloc.state.completed, isFalse);
  });

  test('invalid code keeps the confirmation form and session intact', () async {
    await perform(request);
    status = 400;
    final failed = await perform(confirm);
    expect(failed.failure, isA<ValidationFailure>());
    expect(failed.codeRequested, isTrue);
    expect(failed.completed, isFalse);
    expect(session.needsOnlineLogin, isFalse);
  });

  test(
    'successful reset requires reauthentication without erasing local identity',
    () async {
      await perform(request);
      final state = await perform(confirm);
      expect(state.completed, isTrue);
      expect(session.accountId, 42);
      expect(session.needsOnlineLogin, isTrue);
      expect(session.getAccessToken(), isNotNull);
      expect(requests.last.data, {
        'email': 'test@example.test',
        'code': '123456',
        'new_password': 'test-only-password',
      });
      expect(requests.last.headers.containsKey('Authorization'), isFalse);
      bloc.add(confirm);
      bloc.add(request);
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(requests, hasLength(2));
    },
  );

  test('changing email clears code stage and cooldown', () async {
    await perform(request);
    final changed = await perform(const ChangePasswordResetEmail());
    expect(changed.codeRequested, isFalse);
    expect(changed.resendAt, isNull);
    expect(changed.failure, isNull);
  });

  test(
    '401 on public recovery does not revoke an unrelated active session',
    () async {
      status = 401;
      await perform(request);
      expect(session.needsOnlineLogin, isFalse);
    },
  );

  test(
    '401 on a private resource retains local identity but revokes online access',
    () async {
      status = 401;
      await expectLater(
        dio.get<Object>('/users/me'),
        throwsA(isA<DioException>()),
      );
      expect(session.needsOnlineLogin, isTrue);
      expect(session.accountId, 42);
      expect(requests.single.headers['Authorization'], isNotNull);
    },
  );
}
