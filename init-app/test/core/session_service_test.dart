import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_template/core/services/session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/memory_secure_storage.dart';

String _token(int account) =>
    'test.${base64Url.encode(utf8.encode(jsonEncode({'user_id': account})))}.signature';

Map<String, String> _stored(int account) => {
  'access_token': _token(account),
  'token_type': 'Bearer',
  'expires_in': '3600',
  'login_time': '${DateTime.now().millisecondsSinceEpoch}',
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MemorySecureStorage storage;

  Future<SessionService> restore() async =>
      SessionService.create(storage, await SharedPreferences.getInstance());

  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    SharedPreferences.setMockInitialValues({});
    storage = MemorySecureStorage();
  });

  tearDown(() => debugDefaultTargetPlatformOverride = null);

  test('secure account takes precedence over stale legacy account', () async {
    storage.values.addAll(_stored(42));
    SharedPreferences.setMockInitialValues({
      'access_token': _token(99),
      'token_type': 'Bearer',
      'expires_in': 3600,
      'login_time': DateTime.now().millisecondsSinceEpoch,
    });
    final session = await restore();
    expect(session.accountId, 42);
    expect((await SharedPreferences.getInstance()).getKeys(), isEmpty);
    session.dispose();
  });

  test('legacy session migrates when secure session is absent', () async {
    SharedPreferences.setMockInitialValues({
      'access_token': _token(99),
      'token_type': 'Bearer',
      'expires_in': 3600,
      'login_time': DateTime.now().millisecondsSinceEpoch,
    });
    final session = await restore();
    expect(session.accountId, 99);
    expect(session.needsOnlineLogin, isFalse);
    expect(storage.values['access_token'], _token(99));
    session.dispose();
  });

  for (final missing in ['token_type', 'expires_in', 'login_time']) {
    test(
      'partial session ($missing) retains journal identity, not API access',
      () async {
        storage.values.addAll(_stored(42)..remove(missing));
        final session = await restore();
        expect(session.accountId, 42);
        expect(session.isLoggedIn(), isTrue);
        expect(session.needsOnlineLogin, isTrue);
        if (missing == 'token_type') expect(session.getAuthHeader(), isNull);
        session.dispose();
      },
    );
  }

  test('empty token type cannot produce an authorization header', () async {
    storage.values.addAll(_stored(42)..['token_type'] = '');
    final session = await restore();
    expect(session.getAuthHeader(), isNull);
    expect(session.needsOnlineLogin, isTrue);
    session.dispose();
  });

  test(
    'expired mobile session keeps journal accessible and requires login',
    () async {
      storage.values.addAll(_stored(42)..['login_time'] = '1');
      final session = await restore();
      expect(session.isLoggedIn(), isTrue);
      expect(session.needsOnlineLogin, isTrue);
      session.dispose();
    },
  );

  test('desktop never treats partial session as logged in', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    storage.values.addAll(_stored(42)..remove('token_type'));
    final session = await restore();
    expect(session.isLoggedIn(), isFalse);
    session.dispose();
  });

  test(
    'logout notifies and attempts every credential deletion after failure',
    () async {
      storage.values.addAll(_stored(42));
      storage.values['offline-journal-42'] = 'preserve';
      final session = await restore();
      var notifications = 0;
      session.addListener(() => notifications++);
      storage.failDeletes.add('access_token');
      await expectLater(session.clearSession(), throwsStateError);
      expect(session.accountId, isNull);
      expect(notifications, 1);
      expect(storage.values.containsKey('token_type'), isFalse);
      expect(storage.values.containsKey('expires_in'), isFalse);
      expect(storage.values.containsKey('login_time'), isFalse);
      expect(storage.values['offline-journal-42'], 'preserve');
      session.dispose();
    },
  );
}
