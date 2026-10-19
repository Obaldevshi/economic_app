import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_template/core/errors/failure.dart';
import 'package:mobile_template/core/services/connectivity_service.dart';
import 'package:mobile_template/core/services/offline_savings_service.dart';
import 'package:mobile_template/core/services/session_service.dart';
import 'package:mobile_template/data/datasources/remote/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../support/memory_secure_storage.dart';

class _Connection extends ConnectivityService {
  _Connection() : super(Connectivity());
  bool online = true;
  final changes = StreamController<bool>.broadcast();
  @override
  bool get isOnline => online;
  @override
  Stream<bool> get onlineStream => changes.stream;
  @override
  void dispose() {
    changes.close();
    super.dispose();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MemorySecureStorage storage;
  late SessionService session;
  late _Connection connection;
  late OfflineSavingsService offline;
  late Dio dio;

  Future<void> signIn(int account) async {
    final payload = base64Url.encode(
      utf8.encode(
        jsonEncode({'user_id': account, 'email': 'user$account@example.test'}),
      ),
    );
    await session.saveToken(
      accessToken: 'test.$payload.signature',
      tokenType: 'Bearer',
      expiresIn: 3600,
    );
  }

  setUp(() async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    SharedPreferences.setMockInitialValues({});
    storage = MemorySecureStorage();
    session = await SessionService.create(
      storage,
      await SharedPreferences.getInstance(),
    );
    await signIn(42);
    connection = _Connection();
    dio = Dio();
    offline = OfflineSavingsService(
      storage,
      session,
      connection,
      ApiService(dio, baseUrl: 'https://example.test/api/v1'),
      () => false,
    );
    await offline.init();
    await offline.read(
      'dashboard',
      () async => {
        'currency_code': 'RUB',
        'display_currency': 'RUB',
        'financial_region': 'RU',
        'annual_rate': 12,
        'projection_years': 5,
        'today_total': 0,
        'month_total': 0,
        'total_saved': 0,
        'invested_total': 0,
        'monthly_pace': 0,
        'monthly_series': [],
        'impulse_totals': [],
        'recent_events': [],
        'goals': [],
      },
    );
    await offline.read(
      'spent:1',
      () async => {
        'currency_code': 'RUB',
        'total': 0,
        'total_amount': 0,
        'page': 1,
        'per_page': 50,
        'items': [],
      },
    );
    connection.online = false;
  });

  tearDown(() {
    offline.dispose();
    connection.dispose();
    session.dispose();
    dio.close();
    debugDefaultTargetPlatformOverride = null;
  });

  Future<dynamic> cached(String resource) => offline.read(
    resource,
    () async => throw StateError('Unexpected network request'),
  );

  Map<String, dynamic> event(num amount, {bool invested = false}) => {
    'impulse_name': 'Coffee',
    'amount': amount,
    'is_invested': invested,
    'impulse_item_id': null,
  };

  test(
    'offline decisions distinguish recorded savings from money set aside',
    () async {
      await offline.write('create_event', event(300));
      await offline.write('create_event', event(200, invested: true));
      final dashboard = await cached('dashboard');
      expect(dashboard['total_saved'], 500);
      expect(dashboard['invested_total'], 200);
      expect(dashboard['today_total'], 500);
      expect(offline.pendingCount, 2);
      final projections = dashboard['projection_series'] as List;
      expect(projections, hasLength(5));
      expect(projections.last['total'], greaterThan(500));
    },
  );

  test(
    'durable outbox survives application service restart without duplicates',
    () async {
      await offline.write('create_event', event(300));
      offline.dispose();
      offline = OfflineSavingsService(
        storage,
        session,
        connection,
        ApiService(dio, baseUrl: 'https://example.test/api/v1'),
        () => false,
      );
      await offline.init();
      expect(offline.pendingCount, 1);
      expect((await cached('dashboard'))['total_saved'], 300);
      expect((await cached('events:1'))['data'], hasLength(1));
    },
  );

  test(
    'failed durable write does not report a saved or phantom decision',
    () async {
      storage.failWrites = true;
      await expectLater(
        offline.write('create_event', event(300)),
        throwsA(isA<CacheFailure>()),
      );
      expect(offline.pendingCount, 0);
      expect((await cached('dashboard'))['total_saved'], 0);
      storage.failWrites = false;
      await offline.write('create_event', event(300));
      expect(offline.pendingCount, 1);
      expect((await cached('dashboard'))['total_saved'], 300);
    },
  );

  test(
    'switching accounts never exposes the previous journal or outbox',
    () async {
      await offline.write('create_event', event(300));
      await signIn(99);
      await expectLater(cached('settings'), throwsA(isA<StateError>()));
      expect(offline.hasCachedJournal, isFalse);
      expect(offline.pendingCount, 0);
      await signIn(42);
      expect((await cached('dashboard'))['total_saved'], 300);
      expect(offline.pendingCount, 1);
    },
  );

  test('reauthentication requirement preserves the offline journal', () async {
    await offline.write('create_event', event(300));
    session.requireOnlineLogin();
    expect(offline.needsLogin, isTrue);
    expect((await cached('dashboard'))['total_saved'], 300);
    expect(offline.pendingCount, 1);
  });

  test(
    'an old account write failure cannot restore its data into a new account',
    () async {
      final started = Completer<void>(), release = Completer<void>();
      storage.beforeWrite = (key) async {
        if (key == 'offline_savings_v1_42') {
          started.complete();
          await release.future;
          throw StateError('Old account storage write failed');
        }
      };
      final write = offline.write('create_event', event(300));
      final rejected = expectLater(write, throwsA(isA<CacheFailure>()));
      await started.future;
      await signIn(99);
      release.complete();
      await rejected;
      expect(offline.hasCachedJournal, isFalse);
      expect(offline.pendingCount, 0);
      expect(offline.settings, isEmpty);
    },
  );

  test('spent impulses do not inflate recorded or set-aside savings', () async {
    await offline.write('create_spent', {
      'impulse_name': 'Coffee',
      'amount': 300,
    });
    final dashboard = await cached('dashboard');
    expect(dashboard['total_saved'], 0);
    expect(dashboard['invested_total'], 0);
    expect(offline.pendingCount, 1);
    expect((await cached('spent:1'))['total_amount'], 300);
  });
}
