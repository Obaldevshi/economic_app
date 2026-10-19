import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_template/core/services/app_lock_service.dart';
import 'package:mobile_template/core/services/session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../support/memory_secure_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SessionService session;
  late AppLockService lock;
  late MemorySecureStorage storage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = MemorySecureStorage();
    session = await SessionService.create(
      storage,
      await SharedPreferences.getInstance(),
    );
    // Synthetic, unsigned token for isolated storage tests; no server or user.
    final claims = base64Url.encode(
      utf8.encode(jsonEncode({'user_id': 42, 'email': 'test@example.test'})),
    );
    await session.saveToken(
      accessToken: 'test.$claims.signature',
      tokenType: 'Bearer',
      expiresIn: 3600,
    );
    lock = AppLockService(storage, session);
  });

  tearDown(() {
    lock.dispose();
    session.dispose();
    debugDefaultTargetPlatformOverride = null;
  });

  for (final platform in TargetPlatform.values) {
    test('PIN availability on $platform respects web boundary', () async {
      debugDefaultTargetPlatformOverride = platform;
      await lock.init();
      final mobile =
          !kIsWeb &&
          (platform == TargetPlatform.android ||
              platform == TargetPlatform.iOS);
      expect(lock.supported, mobile);
      expect(lock.prompt, mobile);
      expect(lock.accessible, !mobile);
    });
  }

  test(
    'unsupported platforms cannot enable PIN or password recovery',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      await lock.init();
      lock.configure();
      lock.requestRemove();
      lock.lock();
      lock.usePassword();
      await lock.skip();
      expect(lock.hasPin, isFalse);
      expect(lock.prompt, isFalse);
      expect(lock.passwordRecovery, isFalse);
      expect(lock.accessible, isTrue);
      expect(await lock.unlock('1234'), isFalse);
      await expectLater(lock.setPin('1234'), throwsUnsupportedError);
    },
  );

  test('mobile setup can be skipped and restored without blocking', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    await lock.init();
    if (kIsWeb) {
      expect(lock.accessible, isTrue);
      return;
    }
    expect(lock.prompt, isTrue);
    await lock.skip();
    expect(lock.accessible, isTrue);
    lock.dispose();
    lock = AppLockService(storage, session);
    await lock.init();
    expect(lock.prompt, isFalse);
    expect(lock.accessible, isTrue);
    lock.configure();
    expect(lock.prompt, isTrue);
    await lock.cancelSetup();
    expect(lock.accessible, isTrue);
  });

  test(
    'mobile PIN locks, verifies, cancels a change and removes only after verification',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      await lock.init();
      if (kIsWeb) return;
      await lock.setPin('1234');
      expect(lock.hasPin, isTrue);
      expect(lock.accessible, isTrue);
      final record = jsonDecode(storage.values['app_pin_v1_42']!) as Map;
      expect(record['hash'], isNot('1234'));
      expect(record.containsKey('pin'), isFalse);
      lock.lock();
      expect(lock.accessible, isFalse);
      expect(await lock.unlock('4321'), isFalse);
      expect(lock.locked, isTrue);
      expect(await lock.unlock('1234'), isTrue);
      lock.configure();
      expect(lock.locked, isTrue);
      expect(await lock.unlock('1234'), isTrue);
      expect(lock.prompt, isTrue);
      await lock.cancelSetup();
      expect(lock.accessible, isTrue);
      expect(lock.hasPin, isTrue);
      lock.requestRemove();
      expect(lock.hasPin, isTrue);
      expect(await lock.unlock('1234'), isTrue);
      expect(lock.hasPin, isFalse);
      expect(lock.accessible, isTrue);
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );

  test(
    'backgrounding during first PIN setup cannot leave the app unlocked',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      if (kIsWeb) return;
      await lock.init();
      final setting = lock.setPin('1234');
      lock.lock(); // Same callback used by AppLifecycleListener.onInactive.
      await setting;
      expect(lock.hasPin, isTrue);
      expect(lock.locked, isTrue);
      expect(lock.accessible, isFalse);
    },
  );

  test(
    'backgrounding during PIN verification invalidates the pending unlock',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      if (kIsWeb) return;
      await lock.init();
      await lock.setPin('1234');
      lock.lock();
      final unlocking = lock.unlock('1234');
      lock.lock();
      expect(await unlocking, isFalse);
      expect(lock.locked, isTrue);
      expect(lock.accessible, isFalse);
    },
  );

  test(
    'backgrounding during verification persistence keeps the app locked',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      if (kIsWeb) return;
      await lock.init();
      await lock.setPin('1234');
      lock.lock();
      storage.beforeWrite = (key) async {
        if (key == 'app_pin_v1_42') lock.lock();
      };
      expect(await lock.unlock('1234'), isFalse);
      expect(lock.locked, isTrue);
      expect(lock.accessible, isFalse);
    },
  );

  test('a delayed PIN skip cannot unlock a different account', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    if (kIsWeb) return;
    await lock.init();
    final started = Completer<void>(), release = Completer<void>();
    storage.beforeWrite = (key) async {
      if (key == 'app_pin_v1_42') {
        started.complete();
        await release.future;
      }
    };
    final skipping = lock.skip();
    await started.future;
    storage.values['app_pin_v1_99'] = jsonEncode({
      'hash': 'AA==',
      'salt': 'AA==',
      'attempts': 0,
      'until': 0,
    });
    final claims = base64Url.encode(utf8.encode(jsonEncode({'user_id': 99})));
    await session.saveToken(
      accessToken: 'test.$claims.signature',
      tokenType: 'Bearer',
      expiresIn: 3600,
    );
    await Future<void>.delayed(Duration.zero);
    expect(lock.hasPin, isTrue);
    expect(lock.locked, isTrue);
    release.complete();
    await skipping;
    expect(lock.hasPin, isTrue);
    expect(lock.locked, isTrue);
    expect(lock.accessible, isFalse);
  });

  test(
    'PIN setup begun before logout cannot overwrite a later same-account session',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      if (kIsWeb) return;
      await lock.init();
      final token = session.getAccessToken()!; // Synthetic fixture only.
      final setting = lock.setPin('1234');
      await session.clearSession();
      await session.saveToken(
        accessToken: token,
        tokenType: 'Bearer',
        expiresIn: 3600,
      );
      await Future<void>.delayed(Duration.zero);
      await setting;
      expect(storage.values.containsKey('app_pin_v1_42'), isFalse);
      expect(lock.hasPin, isFalse);
      expect(lock.prompt, isTrue);
    },
  );

  test(
    'renewed session while loading PIN cannot leave loading stuck',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      if (kIsWeb) return;
      final started = Completer<void>(), release = Completer<void>();
      var blocked = false;
      storage.beforeRead = (key) async {
        if (key == 'app_pin_v1_42' && !blocked) {
          blocked = true;
          started.complete();
          await release.future;
        }
      };
      final initializing = lock.init();
      await started.future;
      await session.saveToken(
        accessToken: '${session.getAccessToken()}.renewed',
        tokenType: 'Bearer',
        expiresIn: 3600,
      );
      await Future<void>.delayed(Duration.zero);
      release.complete();
      await initializing;
      expect(lock.loading, isFalse);
      expect(lock.prompt, isTrue);
    },
  );

  test(
    'failed PIN removal keeps the verified record available for retry',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      if (kIsWeb) return;
      await lock.init();
      await lock.setPin('1234');
      lock.requestRemove();
      var writes = 0;
      storage.beforeWrite = (key) async {
        if (key == 'app_pin_v1_42' && ++writes == 2) {
          throw StateError('Simulated removal storage failure');
        }
      };
      await expectLater(lock.unlock('1234'), throwsStateError);
      expect(lock.hasPin, isTrue);
      expect(lock.accessible, isFalse);
      storage.beforeWrite = null;
      expect(await lock.unlock('1234'), isTrue);
      expect(lock.hasPin, isFalse);
    },
  );

  test(
    'persisted retry delay blocks verification without clearing PIN',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      if (kIsWeb) return;
      storage.values['app_pin_v1_42'] = jsonEncode({
        'hash': 'AA==',
        'salt': 'AA==',
        'attempts': 5,
        'until': DateTime.now()
            .add(const Duration(minutes: 1))
            .millisecondsSinceEpoch,
      });
      await lock.init();
      expect(lock.retryAfter, greaterThan(Duration.zero));
      expect(await lock.unlock('1234'), isFalse);
      expect(lock.hasPin, isTrue);
      expect(lock.accessible, isFalse);
    },
  );

  test(
    'corrupt PIN record fails closed and offers password recovery',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      if (kIsWeb) return;
      storage.values['app_pin_v1_42'] = 'not-json';
      await lock.init();
      expect(lock.storageError, isTrue);
      expect(lock.accessible, isFalse);
      lock.usePassword();
      expect(lock.passwordRecovery, isTrue);
    },
  );
}
