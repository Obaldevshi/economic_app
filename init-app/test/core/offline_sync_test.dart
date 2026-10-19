import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_template/app/theme/app_theme.dart';
import 'package:mobile_template/core/di/di.dart';
import 'package:mobile_template/core/interceptors/auth_interceptor.dart';
import 'package:mobile_template/core/services/app_lock_service.dart';
import 'package:mobile_template/core/services/connectivity_service.dart';
import 'package:mobile_template/core/services/offline_savings_service.dart';
import 'package:mobile_template/core/services/session_service.dart';
import 'package:mobile_template/data/datasources/remote/api_service.dart';
import 'package:mobile_template/features/savings/presentation/widgets/sync_status_strip.dart';
import 'package:mobile_template/generated/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../support/memory_secure_storage.dart';

class _Connection extends ConnectivityService {
  _Connection() : super(Connectivity());
  bool online = false;
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

/// Intercepts the real Retrofit contract before transport. No external server,
/// SMTP, real account, password or production financial records are involved.
class _SyncHarness {
  final storage = MemorySecureStorage();
  final connection = _Connection();
  final dio = Dio();
  late SessionService session;
  late OfflineSavingsService journal;
  bool allowSync = false, loseNextAck = false, failSnapshot = false;
  int? rejection;
  Future<void> Function(RequestOptions)? beforeReply;
  final wires = <Map<String, dynamic>>[];
  final serverEvents = <Map<String, dynamic>>[];
  final serverImpulses = <Map<String, dynamic>>[];
  final serverSpent = <Map<String, dynamic>>[];
  final accepted = <String, int>{};

  Map<String, dynamic> get settings => {
    'currency_code': 'RUB',
    'display_currency': 'RUB',
    'financial_region': 'RU',
    'annual_rate': 12,
    'projection_years': 5,
  };
  Map<String, dynamic> get dashboard => {
    ...settings,
    'today_total': total,
    'month_total': total,
    'total_saved': total,
    'invested_total': 0,
    'monthly_pace': total / 3,
    'projected_total': total,
    'projected_interest': 0,
    'monthly_series': [],
    'projection_series': [],
    'impulse_totals': [],
    'recent_events': serverEvents,
    'goals': [],
  };
  num get total =>
      serverEvents.fold<num>(0, (sum, row) => sum + (row['amount'] as num));
  Map<String, dynamic> get spentHistory => {
    'currency_code': 'RUB',
    'total': serverSpent.length,
    'total_amount': serverSpent.fold<num>(
      0,
      (sum, row) => sum + (row['amount'] as num),
    ),
    'page': 1,
    'per_page': 50,
    'items': serverSpent,
  };

  Future<void> signIn(int id) async {
    final payload = base64Url.encode(
      utf8.encode(jsonEncode({'user_id': id, 'email': 'user$id@example.test'})),
    );
    await session.saveToken(
      accessToken: 'test.$payload.signature',
      tokenType: 'Bearer',
      expiresIn: 3600,
    );
  }

  Future<void> init() async {
    SharedPreferences.setMockInitialValues({});
    session = await SessionService.create(
      storage,
      await SharedPreferences.getInstance(),
    );
    await signIn(42);
    dio.interceptors.add(AuthInterceptor(session));
    dio.interceptors.add(InterceptorsWrapper(onRequest: _reply));
    journal = _createJournal();
    await journal.init();
    await journal.read('dashboard', () async => dashboard);
    await journal.read('spent:1', () async => spentHistory);
  }

  OfflineSavingsService _createJournal() => OfflineSavingsService(
    storage,
    session,
    connection,
    ApiService(dio, baseUrl: 'https://example.test/api/v1'),
    () => allowSync,
  );

  Future<void> restart() async {
    allowSync = false;
    journal.dispose();
    journal = _createJournal();
    await journal.init();
  }

  void reject(
    RequestOptions request,
    RequestInterceptorHandler handler, [
    int? status,
  ]) {
    handler.reject(
      DioException(
        requestOptions: request,
        type: status == null
            ? DioExceptionType.connectionError
            : DioExceptionType.badResponse,
        response: status == null
            ? null
            : Response(
                requestOptions: request,
                statusCode: status,
                data: {'message': 'Synthetic conflict'},
              ),
      ),
      true,
    );
  }

  Future<void> _reply(
    RequestOptions request,
    RequestInterceptorHandler handler,
  ) async {
    Object? data;
    if (request.path == '/savings/sync') {
      final wire = Map<String, dynamic>.from(
        jsonDecode(jsonEncode(request.data)) as Map,
      );
      wires.add(wire);
      if (rejection != null) {
        await beforeReply?.call(request);
        reject(request, handler, rejection);
        return;
      }
      final operation = wire['operation_id'] as String;
      final kind = wire['kind'] as String;
      final payload = Map<String, dynamic>.from(wire['payload'] as Map);
      final impulse = payload['impulse_item_id'];
      if (impulse != null &&
          !serverImpulses.any((row) => row['id'] == impulse)) {
        reject(request, handler, 404);
        return;
      }
      final id = accepted.putIfAbsent(operation, () {
        final rows = switch (kind) {
          'create_impulse' => serverImpulses,
          'create_spent' => serverSpent,
          'create_event' => serverEvents,
          _ => throw StateError('Unsupported fixture mutation'),
        };
        final next =
            rows.length +
            (kind == 'create_impulse'
                ? 101
                : kind == 'create_spent'
                ? 201
                : 1);
        rows.add({
          ...payload,
          'id': next,
          'currency_code': 'RUB',
          if (kind == 'create_impulse') 'is_active': true,
          if (kind != 'create_impulse') 'note': payload['note'],
        });
        return next;
      });
      if (loseNextAck) {
        loseNextAck = false;
        reject(request, handler);
        return;
      }
      data = {'entity_id': id};
    } else if (request.path == '/savings/dashboard') {
      if (failSnapshot) {
        reject(request, handler);
        return;
      }
      data = dashboard;
    } else if (request.path == '/savings/settings') {
      data = settings;
    } else if (request.path == '/savings/impulses') {
      data = serverImpulses;
    } else if (request.path == '/savings/events') {
      await beforeReply?.call(request);
      handler.resolve(
        Response(
          requestOptions: request,
          statusCode: 200,
          data: {
            'message': 'OK',
            'page': 1,
            'per_page': 50,
            'total': serverEvents.length,
            'data': serverEvents,
          },
        ),
      );
      return;
    } else if (request.path == '/savings/spent') {
      data = spentHistory;
    } else {
      handler.reject(
        DioException(
          requestOptions: request,
          error: StateError('Unexpected test endpoint'),
        ),
      );
      return;
    }
    await beforeReply?.call(request);
    handler.resolve(
      Response(
        requestOptions: request,
        statusCode: 200,
        data: {'message': 'OK', 'data': data},
      ),
    );
  }

  Future<void> record([num amount = 300]) => journal.write('create_event', {
    'impulse_name': 'Coffee',
    'amount': amount,
    'is_invested': false,
    'impulse_item_id': null,
  });

  Future<dynamic> cached(String resource) async {
    final online = connection.online, syncingAllowed = allowSync;
    connection.online = false;
    allowSync = false;
    try {
      return await journal.read(
        resource,
        () async => throw StateError('Unexpected snapshot request'),
      );
    } finally {
      connection.online = online;
      allowSync = syncingAllowed;
    }
  }

  Future<void> sync() async {
    connection.online = true;
    allowSync = true;
    await journal.sync();
  }

  void dispose() {
    journal.dispose();
    connection.dispose();
    dio.close();
    session.dispose();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _SyncHarness h;
  setUp(() async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    h = _SyncHarness();
    await h.init();
  });
  tearDown(() {
    h.dispose();
    debugDefaultTargetPlatformOverride = null;
  });

  for (final locale in ['de', 'ru', 'ar']) {
    for (final scale in [1.4, 2.0]) {
      testWidgets('sync strip fits $locale at 320px and text scale $scale', (
        tester,
      ) async {
        final lock = AppLockService(h.storage, h.session);
        await tester.runAsync(() async {
          await h.record();
          await lock.init();
          await lock.skip();
        });
        getIt.registerSingleton<OfflineSavingsService>(h.journal);
        getIt.registerSingleton<AppLockService>(lock);
        addTearDown(() async {
          await getIt.unregister<OfflineSavingsService>();
          await getIt.unregister<AppLockService>();
          lock.dispose();
        });
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(320, 568);
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(locale),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.lightTheme,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            ),
            home: Scaffold(
              bottomNavigationBar: SyncStatusStrip(onLogin: () {}),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final action = find.byType(TextButton).first;
        final bounds = tester.getRect(action);
        expect(bounds.left, greaterThanOrEqualTo(0));
        expect(bounds.right, lessThanOrEqualTo(320));
        expect(action.hitTestable(), findsOneWidget);
        for (final width in [551.0, 1280.0]) {
          tester.view.physicalSize = Size(width, 720);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expect(action.hitTestable(), findsOneWidget);
          expect(tester.getRect(action).right, lessThanOrEqualTo(width));
        }
        await tester.pumpWidget(const SizedBox.shrink());
        debugDefaultTargetPlatformOverride = null;
      });
    }
  }

  test(
    'logout from a sync-state listener cannot start a stale request or throw',
    () async {
      await h.record();
      Future<void>? logout;
      var requested = false;
      h.journal.addListener(() {
        if (h.journal.syncing && !requested) {
          requested = true;
          logout = h.session.clearSession();
        }
      });
      await expectLater(h.sync(), completes);
      await logout;
      expect(h.wires, isEmpty);
      expect(h.journal.hasAccount, isFalse);
      expect(h.journal.syncing, isFalse);
    },
  );

  test(
    'late unauthorized response cannot invalidate a renewed same-account session',
    () async {
      await h.record();
      h.rejection = 401;
      h.beforeReply = (_) async {
        await h.session.saveToken(
          accessToken: '${h.session.getAccessToken()}.renewed',
          tokenType: 'Bearer',
          expiresIn: 3600,
        );
      };
      await h.sync();
      expect(h.session.needsOnlineLogin, isFalse);
      expect(h.journal.issue, isNull);
      expect(h.journal.pendingCount, 1);
    },
  );

  test(
    'discarding a failed offline habit also discards transitive event edits',
    () async {
      await h.journal.write('create_impulse', {
        'name': 'Coffee',
        'default_amount': 300,
        'icon_key': 'coffee',
        'weekly_frequency': 3,
      });
      final habit = (await h.cached('impulses') as List).single as Map;
      await h.journal.write('create_event', {
        'impulse_name': 'Coffee',
        'amount': 300,
        'is_invested': false,
        'impulse_item_id': habit['id'],
      });
      final event =
          ((await h.cached('events:1'))['data'] as List).single as Map;
      await h.journal.write('delete_event', {}, event['id'] as int);
      await h.record(
        70,
      ); // Independent record must not follow the discarded habit.
      h.rejection = 422;
      await h.sync();
      expect(h.journal.problemStatus, 422);
      h.allowSync = false;
      await h.journal.discardProblem();
      expect(h.journal.pendingCount, 1);
      expect((await h.cached('dashboard'))['total_saved'], 70);
      await h.restart();
      expect(h.journal.pendingCount, 1);
    },
  );

  test(
    'failed conflict discard persistence preserves the pending journal',
    () async {
      await h.record();
      h.rejection = 422;
      await h.sync();
      h.allowSync = false;
      h.storage.failWrites = true;
      await expectLater(h.journal.discardProblem(), throwsStateError);
      expect(h.journal.pendingCount, 1);
      expect(h.journal.problemStatus, 422);
    },
  );

  test(
    'temporary habit references survive lost acknowledgement and restart exactly once',
    () async {
      await h.journal.write('create_impulse', {
        'name': 'Coffee',
        'default_amount': 300,
        'icon_key': 'coffee',
        'weekly_frequency': 3,
      });
      final local = (await h.cached('impulses') as List).single['id'];
      await h.journal.write('create_event', {
        'impulse_name': 'Coffee',
        'amount': 300,
        'is_invested': false,
        'impulse_item_id': local,
      });
      await h.journal.write('create_spent', {
        'impulse_name': 'Coffee',
        'amount': 150,
        'impulse_item_id': local,
      });
      h.loseNextAck = true;
      await h.sync();
      expect(h.serverImpulses, hasLength(1));
      expect(h.serverEvents, isEmpty);
      await h.restart();
      h.failSnapshot = true;
      await h.sync();
      expect(h.wires[1], h.wires[0]);
      expect(h.serverEvents.single['impulse_item_id'], 101);
      expect(h.serverSpent.single['impulse_item_id'], 101);
      expect((await h.cached('dashboard'))['total_saved'], 300);
      expect((await h.cached('spent:1'))['total_amount'], 150);
      await h.restart();
      expect((await h.cached('dashboard'))['total_saved'], 300);
      expect((await h.cached('spent:1'))['total_amount'], 150);
      h.failSnapshot = false;
      await h.sync();
      expect(h.wires, hasLength(4));
      expect(h.serverImpulses, hasLength(1));
      expect(h.serverEvents, hasLength(1));
      expect(h.serverSpent, hasLength(1));
      expect(h.journal.hasLocalChanges, isFalse);
      expect((await h.cached('dashboard'))['total_saved'], 300);
      expect((await h.cached('spent:1'))['total_amount'], 150);
    },
  );

  test(
    'duplicate discard taps cannot remove the next independent operation',
    () async {
      await h.record();
      await h.record(70);
      h.rejection = 422;
      await h.sync();
      h.allowSync = false;
      final started = Completer<void>(), release = Completer<void>();
      var blocked = false;
      h.storage.beforeWrite = (key) async {
        if (key == 'offline_savings_v1_42' && !blocked) {
          blocked = true;
          started.complete();
          await release.future;
        }
      };
      final first = h.journal.discardProblem();
      await started.future;
      final duplicate = h.journal.discardProblem();
      release.complete();
      await Future.wait([first, duplicate]);
      expect(h.journal.pendingCount, 1);
      expect((await h.cached('dashboard'))['total_saved'], 70);
    },
  );

  test(
    'lost acknowledgement replays the same durable operation and counts it once',
    () async {
      await h.record();
      h.loseNextAck = true;
      await h.sync();
      expect(h.journal.pendingCount, 1);
      expect(h.serverEvents, hasLength(1));
      expect((await h.cached('dashboard'))['total_saved'], 300);
      await h.sync();
      expect(h.wires, hasLength(2));
      expect(h.wires[1], h.wires[0]);
      expect(h.serverEvents, hasLength(1));
      expect(h.journal.hasLocalChanges, isFalse);
      expect((await h.cached('dashboard'))['total_saved'], 300);
    },
  );

  test(
    'acknowledged overlay survives a failed snapshot and service restart',
    () async {
      await h.record();
      h.failSnapshot = true;
      await h.sync();
      expect(h.journal.pendingCount, 0);
      expect(h.journal.hasLocalChanges, isTrue);
      await h.restart();
      expect((await h.cached('dashboard'))['total_saved'], 300);
      h.failSnapshot = false;
      await h.sync();
      expect(h.wires, hasLength(1));
      expect(h.journal.hasLocalChanges, isFalse);
      expect((await h.cached('dashboard'))['total_saved'], 300);
    },
  );

  test(
    'a failed durable wire write cannot be bypassed by retrying sync',
    () async {
      await h.record();
      h.storage.failWrites = true;
      await h.sync();
      expect(h.wires, isEmpty);
      await h.sync();
      expect(h.wires, isEmpty);
      expect(h.journal.pendingCount, 1);
      h.storage.failWrites = false;
      await h.sync();
      expect(h.wires, hasLength(1));
      expect(h.journal.hasLocalChanges, isFalse);
    },
  );

  test(
    'server acknowledgement arriving after account switch cannot touch the new journal',
    () async {
      await h.record();
      h.beforeReply = (request) async {
        if (request.path == '/savings/sync') await h.signIn(99);
      };
      await h.sync();
      expect(h.journal.hasCachedJournal, isFalse);
      expect(h.journal.pendingCount, 0);
      expect(h.storage.values['offline_savings_v1_99'], isNull);
      h.allowSync = false;
      h.beforeReply = null;
      await h.signIn(42);
      expect((await h.cached('dashboard'))['total_saved'], 300);
      await h.sync();
      expect(h.serverEvents, hasLength(1));
    },
  );

  test(
    'queued snapshot replacement is dropped if the active account changes',
    () async {
      await h.record();
      final writeStarted = Completer<void>(), releaseWrite = Completer<void>();
      final snapshotSent = Completer<void>();
      Future<void>? additionalWrite;
      h.beforeReply = (request) async {
        if (request.path == '/savings/spent') {
          var blocked = false;
          h.storage.beforeWrite = (key) async {
            if (key == 'offline_savings_v1_42' && !blocked) {
              blocked = true;
              writeStarted.complete();
              await releaseWrite.future;
            }
          };
          additionalWrite = h.record(100);
          await writeStarted.future;
          snapshotSent.complete();
        }
      };
      final syncing = h.sync();
      await snapshotSent.future;
      await Future<void>.delayed(
        Duration.zero,
      ); // Drain response microtasks; final swap is now queued.
      await h.signIn(99);
      releaseWrite.complete();
      await additionalWrite;
      await syncing;
      expect(h.journal.hasCachedJournal, isFalse);
      expect(h.journal.settings, isEmpty);
      expect(h.storage.values['offline_savings_v1_99'], isNull);
    },
  );

  test(
    'storage failure while recording a conflict stays a handled sync state',
    () async {
      await h.record();
      h.rejection = 409;
      h.beforeReply = null;
      var writes = 0;
      h.storage.beforeWrite = (key) async {
        if (key == 'offline_savings_v1_42' && ++writes == 2) {
          throw StateError('Conflict metadata could not be saved');
        }
      };
      await expectLater(h.sync(), completes);
      expect(h.journal.issue, 'storage');
      expect(h.journal.pendingCount, 1);
    },
  );
}
