import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_template/core/errors/failure.dart';
import 'package:mobile_template/core/services/connectivity_service.dart';
import 'package:mobile_template/core/services/session_service.dart';
import 'package:mobile_template/data/datasources/remote/api_service.dart';
import 'package:mobile_template/data/models/request/savings_request.dart';

typedef Json = Map<String, dynamic>;
Json _map(dynamic value) =>
    value == null ? {} : Map<String, dynamic>.from(value as Map);
double _number(dynamic value) => double.tryParse('$value') ?? 0;
double _money(num value) => (value * 100).round() / 100;
dynamic _clone(dynamic value) => jsonDecode(jsonEncode(value));

/// Account-scoped, encrypted snapshots plus a durable outbox. No passwords or
/// access tokens are copied into the journal; each replay needs a live session.
class OfflineSavingsService extends ChangeNotifier {
  OfflineSavingsService(
    this._storage,
    this._session,
    this._connectivity,
    this._api,
    this._canSync, {
    this.onImpulseRemapped,
  });
  final Future<void> Function(int, int)? onImpulseRemapped;
  final FlutterSecureStorage _storage;
  final SessionService _session;
  final ConnectivityService _connectivity;
  final ApiService _api;
  final bool Function() _canSync;
  bool get enabled =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);
  int? _account;
  Json _data = {};
  Future<void> _ready = Future.value();
  Future<void> _tail = Future.value();
  final _fetchTimes = <String, DateTime>{};
  final _refreshing = <String>{};
  final _warmingHistory = <String>{};
  int _profileGeneration = 0;
  StreamSubscription<bool>? _connection;
  Timer? _retry;
  bool syncing = false;
  String? issue;
  int revision = 0;
  bool _storageReadable = true;
  List<Json> get _operations =>
      (_data['operations'] as List? ?? []).map(_map).toList();
  int get pendingCount =>
      _operations.where((op) => op['synced'] != true).length;
  bool get hasLocalChanges => _operations.isNotEmpty;
  bool get needsLogin => _session.needsOnlineLogin;
  bool get offline => !_connectivity.isOnline || issue == 'network';
  int? get problemStatus => _data['problem_status'] as int?;
  bool get hasAccount => _account != null;
  bool get hasCachedJournal => _ledger()['dashboard'] != null;

  Future<void> init() async {
    if (!enabled) return;
    _session.addListener(_sessionChanged);
    await _activate();
    _connection = _connectivity.onlineStream.listen((online) {
      if (online) {
        if (issue == 'network') issue = null;
        _fetchTimes.clear();
        revision++;
        unawaited(sync());
      }
      notifyListeners();
    });
    _retry = Timer.periodic(const Duration(seconds: 30), (_) {
      if (issue == 'network' && _connectivity.isOnline) {
        issue = null;
        _fetchTimes.clear();
        revision++;
      }
      notifyListeners();
      unawaited(sync());
    });
  }

  void _sessionChanged() {
    if (_account != _session.accountId) {
      _ready = _activate();
    } else {
      if (!_session.needsOnlineLogin && issue == 'login') {
        issue = null;
        _fetchTimes.clear();
        revision++;
      }
      unawaited(sync());
      notifyListeners();
    }
  }

  Future<void> _activate() async {
    final id = _session.accountId;
    _account = id;
    _data = {};
    _fetchTimes.clear();
    _refreshing.clear();
    _profileGeneration++;
    issue = null;
    _storageReadable = true;
    revision++;
    notifyListeners();
    if (id == null) return;
    try {
      final raw = await _storage.read(key: 'offline_savings_v1_$id');
      if (_account != id) return;
      _data = raw == null ? {} : _map(jsonDecode(raw));
    } catch (_) {
      if (_account == id) {
        issue = 'storage';
        _storageReadable = false;
      }
    }
    if (_account == id) {
      revision++;
      notifyListeners();
    }
  }

  Future<T> _serial<T>(Future<T> Function() action) {
    final done = Completer<T>();
    _tail = _tail.then((_) async {
      try {
        done.complete(await action());
      } catch (e, st) {
        done.completeError(e, st);
      }
    });
    return done.future;
  }

  Future<void> _persist(int id) async {
    if (_account != id) {
      throw const CacheFailure(message: 'Local account changed');
    }
    await _storage.write(
      key: 'offline_savings_v1_$id',
      value: jsonEncode(_data),
    );
  }

  Json get settings {
    final value = _map(_clone(_data['settings']));
    for (final op in _operations.where(
      (op) => op['kind'] == 'update_settings',
    )) {
      value.addAll(_map(op['payload']));
    }
    return value;
  }

  String get _currency => settings['currency_code'] as String? ?? 'RUB';
  Json _ledger([String? code]) =>
      _map(_map(_data['ledgers'])[code ?? _currency]);
  void _saveLedger(Json value, String code) {
    final ledgers = _map(_data['ledgers']);
    ledgers[code] = value;
    _data['ledgers'] = ledgers;
  }

  Future<dynamic> read(
    String resource,
    Future<dynamic> Function() remote,
  ) async {
    if (!enabled) return remote();
    final expectedAccount = _session.accountId;
    await _ready;
    final id = _account;
    if (id != expectedAccount) {
      throw const CacheFailure(message: 'Local account changed');
    }
    final profileVersion = _profileGeneration;
    if (id == null) throw const AuthFailure();
    if (hasLocalChanges || offline || needsLogin) {
      final cached = _view(resource);
      if (cached != null) {
        unawaited(sync());
        return cached;
      }
      if (hasLocalChanges || needsLogin) {
        throw const CacheFailure(message: 'Offline journal unavailable');
      }
    }
    // Render restored data immediately, even while Android is still discovering
    // its network. Refresh these read-only snapshots without a blocking dialog.
    final restored = _view(resource), refreshKey = '$id:$_currency:$resource';
    if (restored != null &&
        ['dashboard', 'settings', 'impulses', 'profile'].contains(resource)) {
      final fetched = _fetchTimes[refreshKey];
      if (!_refreshing.contains(refreshKey) &&
          (fetched == null ||
              DateTime.now().difference(fetched).inSeconds >= 30)) {
        _refreshing.add(refreshKey);
        unawaited(_refreshSnapshot(id, resource, refreshKey, remote));
      }
      return restored;
    }
    try {
      final value = await remote();
      if (_account != id) {
        throw const CacheFailure(message: 'Local account changed');
      }
      await _serial(() async {
        if (_account != id) return;
        if (!hasLocalChanges &&
            _storageReadable &&
            (resource != 'profile' || profileVersion == _profileGeneration)) {
          _cache(resource, value);
          try {
            await _persist(id);
          } catch (_) {
            issue = 'storage';
          }
        }
      });
      if (_account != id) {
        throw const CacheFailure(message: 'Local account changed');
      }
      if (issue == 'network') {
        issue = null;
        notifyListeners();
      }
      if (resource == 'dashboard') unawaited(_warmHistory(id));
      return hasLocalChanges ||
              (resource == 'profile' && profileVersion != _profileGeneration)
          ? (_view(resource) ?? value)
          : value;
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      if (status == null || status == 401 || (status >= 500)) {
        if (_account != id) rethrow;
        issue = status == 401 ? 'login' : 'network';
        notifyListeners();
        final cached = _view(resource);
        if (cached != null) return cached;
      }
      rethrow;
    }
  }

  Future<void> _refreshSnapshot(
    int id,
    String resource,
    String key,
    Future<dynamic> Function() remote,
  ) async {
    final token = _session.getAccessToken(),
        profileVersion = _profileGeneration;
    try {
      final value = await remote();
      if (_account != id ||
          _session.getAccessToken() != token ||
          hasLocalChanges ||
          (resource == 'profile' && profileVersion != _profileGeneration)) {
        return;
      }
      await _serial(() async {
        if (_account != id || hasLocalChanges || !_storageReadable) return;
        _cache(resource, value);
        await _persist(id);
        _fetchTimes[key] = DateTime.now();
        if (issue == 'network') issue = null;
        revision++;
        notifyListeners();
        if (resource == 'dashboard') unawaited(_warmHistory(id));
      });
    } on DioException catch (error) {
      if (_account == id) {
        issue = error.response?.statusCode == 401 ? 'login' : 'network';
        notifyListeners();
      }
    } catch (_) {
      if (_account == id) {
        issue = 'storage';
        notifyListeners();
      }
    } finally {
      _refreshing.remove(key);
    }
  }

  Future<void> updateCachedProfile(Json values) async {
    if (!enabled) return;
    final account = _session.accountId;
    await _ready;
    final id = _account;
    if (id == null || id != account) return;
    await _serial(() async {
      if (_account != id) return;
      _profileGeneration++;
      final profile = _map(_data['profile']);
      if (profile.isEmpty) return;
      for (final item in values.entries.where((e) => e.value != null)) {
        profile[item.key] = item.value;
      }
      _data['profile'] = profile;
      await _persist(id);
    });
  }

  Future<void> _warmHistory(int id) async {
    final code = _currency, key = '$id:$_currency';
    if (_warmingHistory.contains(key) ||
        _ledger()['events_complete'] == true ||
        hasLocalChanges ||
        !_canSync() ||
        !_connectivity.isOnline ||
        _session.needsOnlineLogin) {
      return;
    }
    _warmingHistory.add(key);
    final token = _session.getAccessToken();
    try {
      final rows = <Json>[];
      var total = 0;
      for (var page = 1; page <= 10; page++) {
        final response = await _api.getSavingEvents(page, 100);
        if (_account != id ||
            _session.getAccessToken() != token ||
            _currency != code ||
            hasLocalChanges) {
          return;
        }
        if (response.data.any((e) => e.currencyCode != code)) return;
        rows.addAll(response.data.map((e) => e.toJson()));
        total = response.total;
        if (rows.length >= total || response.data.isEmpty) break;
      }
      await _serial(() async {
        if (_account != id || _currency != code || hasLocalChanges) return;
        final ledger = _ledger(code);
        ledger['events'] = {for (final row in rows) '${row['id']}': row};
        ledger['events_complete'] = rows.length == total;
        ledger['first_page_oldest'] = rows.isEmpty
            ? null
            : rows.last['occurred_at'];
        _saveLedger(ledger, code);
        await _persist(id);
        revision++;
        notifyListeners();
      });
    } catch (_) {
      /* Keep the last durable snapshot if prefetch cannot complete. */
    } finally {
      _warmingHistory.remove(key);
    }
  }

  void _cache(String resource, dynamic value) {
    if (resource == 'profile' || resource == 'settings') {
      _data[resource] = _clone(value);
      return;
    }
    final json = value is Map ? _map(value) : <String, dynamic>{};
    final first = value is List
        ? value.firstOrNull
        : (json['data'] is List ? (json['data'] as List).firstOrNull : null);
    final code =
        json['currency_code'] as String? ??
        _map(first)['currency_code'] as String? ??
        _currency;
    final ledger = _ledger(code);
    if (resource.startsWith('spent:')) {
      final records =
          json['page'] == 1 && json['total'] == (json['items'] as List).length
          ? <String, dynamic>{}
          : _map(ledger['spent']);
      for (final raw in json['items'] as List) {
        final row = _map(raw);
        records['${row['id']}'] = row;
      }
      ledger['spent'] = records;
      ledger['spent_summary'] = {
        'total': json['total'],
        'total_amount': json['total_amount'],
      };
    } else if (resource.startsWith('events:')) {
      final records =
          json['page'] == 1 && json['total'] == (json['data'] as List).length
          ? <String, dynamic>{}
          : _map(ledger['events']);
      for (final item in json['data'] as List) {
        final row = _map(item);
        records['${row['id']}'] = row;
      }
      ledger['events'] = records;
      if (json['page'] == 1) {
        ledger['events_complete'] =
            json['total'] == (json['data'] as List).length;
        ledger['first_page_oldest'] = (json['data'] as List).isEmpty
            ? null
            : _map((json['data'] as List).last)['occurred_at'];
      }
    } else {
      ledger[resource] = _clone(value);
      if (resource == 'dashboard') {
        ledger['snapshot_at'] = DateTime.now().toUtc().toIso8601String();
        _data['settings'] = {
          for (final key in [
            'currency_code',
            'display_currency',
            'financial_region',
            'annual_rate',
            'projection_years',
          ])
            key: json[key],
        };
        final events = _map(ledger['events']);
        for (final row in json['recent_events'] as List) {
          events['${row['id']}'] = row;
        }
        ledger['events'] = events;
      }
    }
    _saveLedger(ledger, code);
  }

  List<Json> _records(String type, [String? code]) {
    code ??= _currency;
    final ledger = _ledger(code);
    final dashboard = _map(ledger['dashboard']);
    final rows = <int, Json>{};
    final source = type == 'spent'
        ? _map(ledger['spent']).values.toList()
        : type == 'event'
        ? [
            ...(dashboard['recent_events'] as List? ?? []),
            ..._map(ledger['events']).values,
          ]
        : (type == 'impulse' ? ledger['impulses'] : dashboard['goals'])
                  as List? ??
              [];
    for (final raw in source) {
      final item = _map(_clone(raw));
      rows[item['id'] as int] = item;
    }
    for (final op in _operations.where((op) => op['ledger'] == code)) {
      final kind = op['kind'] as String;
      if (!kind.endsWith('_$type')) continue;
      final key = (op['local_id'] ?? op['entity_id']) as int;
      if (kind.startsWith('delete_')) {
        rows.remove(key);
        continue;
      }
      final payload = _map(op['payload']);
      final row = {...?rows[key], ...payload, 'id': key, 'currency_code': code};
      if (type == 'impulse') {
        row.putIfAbsent('is_active', () => true);
      }
      if (type == 'goal') {
        row.putIfAbsent('allocated_amount', () => 0);
      }
      rows[key] = row;
    }
    final result = rows.values.toList();
    if (type == 'event' || type == 'spent') {
      result.sort(
        (a, b) => '${b['occurred_at']}'.compareTo('${a['occurred_at']}'),
      );
    }
    return result;
  }

  dynamic _view(String resource) {
    if (resource == 'profile') return _clone(_data['profile']);
    if (resource == 'settings') return settings.isEmpty ? null : settings;
    final ledger = _ledger();
    if (ledger.isEmpty) return null;
    if (resource == 'impulses') return _records('impulse');
    if (resource == 'dashboard') return _dashboard();
    if (resource.startsWith('spent:')) {
      // The aggregate covers the whole ledger, not merely the cached pages.
      final summary = _map(ledger['spent_summary']);
      if (summary.isEmpty) return null;
      double amount = _number(summary['total_amount']);
      int count = summary['total'] as int;
      for (final op in _operations.where((op) => op['ledger'] == _currency)) {
        final kind = op['kind'];
        if (kind == 'create_spent') {
          amount += _number(_map(op['payload'])['amount']);
          count++;
        }
        if (kind == 'update_spent') {
          amount +=
              _number(_map(op['payload'])['amount']) -
              _number(_map(op['before'])['amount']);
        }
        if (kind == 'delete_spent') {
          amount -= _number(_map(op['before'])['amount']);
          count--;
        }
      }
      final page = int.parse(resource.split(':').last),
          rows = _records('spent');
      if (page > 1 && rows.length <= (page - 1) * 50 && count > rows.length) {
        return null;
      }
      return {
        'currency_code': _currency,
        'total': math.max(0, count),
        'total_amount': _money(math.max(0, amount)),
        'page': page,
        'per_page': 50,
        'items': rows.skip((page - 1) * 50).take(50).toList(),
      };
    }
    if (resource.startsWith('events:')) {
      final page = int.parse(resource.split(':').last),
          records = _records('event');
      return {
        'message': 'Cached savings',
        'page': page,
        'per_page': 50,
        'total': records.length,
        'data': records.skip((page - 1) * 50).take(50).toList(),
      };
    }
    if (resource == 'receipt') {
      final now = DateTime.now().toUtc(), end = DateTime.now().toUtc();
      final start = DateTime.utc(
        now.year,
        now.month,
        now.day,
      ).subtract(const Duration(days: 6));
      final oldest = DateTime.tryParse('${ledger['first_page_oldest']}');
      if (ledger['events_complete'] != true &&
          (oldest == null || !oldest.isBefore(start))) {
        return null;
      }
      final events = _records('event').where((e) {
        final d = DateTime.parse(e['occurred_at']);
        return !d.isBefore(start) && !d.isAfter(end);
      });
      return {
        'currency_code': _currency,
        'start_date': start.toIso8601String(),
        'end_date': end.toIso8601String(),
        'total_saved': _money(
          events.fold<double>(0, (n, e) => n + _number(e['amount'])),
        ),
        'invested_total': _money(
          events
              .where((e) => e['is_invested'] == true)
              .fold<double>(0, (n, e) => n + _number(e['amount'])),
        ),
        'decision_count': events.length,
      };
    }
    return null;
  }

  Json? _dashboard() {
    final ledger = _ledger();
    if (ledger['dashboard'] == null) return null;
    final result = _map(_clone(ledger['dashboard'])),
        now = DateTime.now().toUtc();
    final snapshot = DateTime.parse(ledger['snapshot_at'] as String);
    final today = DateTime.utc(now.year, now.month, now.day);
    final month = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    if (snapshot.isBefore(today)) result['today_total'] = 0;
    if (snapshot.year != now.year || snapshot.month != now.month) {
      result['month_total'] = 0;
    }
    final monthly = {
      for (final p in result['monthly_series'] as List)
        '${p['month']}': _number(p['amount']),
    };
    final totals = {
      for (final p in result['impulse_totals'] as List)
        '${p['name']}': _number(p['amount']),
    };
    var pace = _number(result['monthly_pace']);
    void delta(Json e, int sign) {
      if (e.isEmpty) return;
      final amount = _number(e['amount']) * sign,
          date = DateTime.parse(e['occurred_at'] as String).toUtc();
      result['total_saved'] = _money(_number(result['total_saved']) + amount);
      if (e['is_invested'] == true) {
        result['invested_total'] = _money(
          _number(result['invested_total']) + amount,
        );
      }
      if (!date.isBefore(today) &&
          date.isBefore(today.add(const Duration(days: 1)))) {
        result['today_total'] = _money(_number(result['today_total']) + amount);
      }
      final key = '${date.year}-${date.month.toString().padLeft(2, '0')}';
      if (key == month) {
        result['month_total'] = _money(_number(result['month_total']) + amount);
      }
      monthly[key] = _money((monthly[key] ?? 0) + amount);
      if (!date.isBefore(now.subtract(const Duration(days: 90)))) {
        pace += amount / 3;
      }
      final name = e['impulse_name'] as String;
      totals[name] = _money((totals[name] ?? 0) + amount);
    }

    final affected = _operations
        .where(
          (op) =>
              op['ledger'] == _currency &&
              (op['kind'] as String).endsWith('_event'),
        )
        .map((op) => (op['local_id'] ?? op['entity_id']) as int)
        .toSet();
    final originals = {
      for (final row in [
        ...(result['recent_events'] as List),
        ..._map(ledger['events']).values,
      ])
        _map(row)['id'] as int: _map(row),
    };
    final projected = {
      for (final row in _records('event')) row['id'] as int: row,
    };
    if (ledger['events_complete'] == true) {
      for (final field in [
        'today_total',
        'month_total',
        'total_saved',
        'invested_total',
      ]) {
        result[field] = 0;
      }
      monthly.clear();
      totals.clear();
      pace = 0;
      for (final event in projected.values) {
        delta(event, 1);
      }
    } else {
      for (final id in affected) {
        delta(originals[id] ?? {}, -1);
        delta(projected[id] ?? {}, 1);
      }
    }
    result.addAll(settings);
    result['recent_events'] = _records('event').take(5).toList();
    result['goals'] = _records('goal');
    result['monthly_series'] = [
      for (var offset = 5; offset >= 0; offset--)
        (() {
          final date = DateTime.utc(now.year, now.month - offset);
          final key = '${date.year}-${date.month.toString().padLeft(2, '0')}';
          return {'month': key, 'amount': monthly[key] ?? 0};
        })(),
    ];
    final sorted = totals.entries.where((e) => e.value > 0).toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    result['impulse_totals'] = [
      for (final item in sorted.take(5))
        {'name': item.key, 'amount': item.value},
    ];
    result['monthly_pace'] = _money(pace);
    final rate = _number(settings['annual_rate']) / 1200,
        total = _number(result['total_saved']);
    final years = settings['projection_years'] as int? ?? 5;
    final projections = <Json>[];
    for (var year = 1; year <= years; year++) {
      final months = year * 12, own = total + pace * year * 12;
      final factor = math.pow(1 + rate, months).toDouble();
      final future = rate == 0
          ? own
          : total * factor + pace * (factor - 1) / rate;
      projections.add({
        'year': year,
        'contributions': _money(own),
        'interest': _money(future - own),
        'total': _money(future),
      });
    }
    result['projection_series'] = projections;
    result['projected_total'] = projections.last['total'];
    result['projected_interest'] = projections.last['interest'];
    return result;
  }

  Future<String> write(String kind, Json payload, [int? entityId]) async {
    final expectedAccount = _session.accountId;
    await _ready;
    return _serial(() async {
      final id = _account;
      if (id != expectedAccount) {
        throw const CacheFailure(message: 'Local account changed');
      }
      if (!_storageReadable) {
        throw const CacheFailure(message: 'Offline storage unavailable');
      }
      if (id == null || settings.isEmpty || _ledger()['dashboard'] == null) {
        throw const CacheFailure(message: 'Offline journal unavailable');
      }
      if (kind == 'update_settings' &&
          payload['currency_code'] != null &&
          payload['currency_code'] != _currency) {
        // Switching ledgers requires a fresh server snapshot; never relabel money.
        if (hasLocalChanges || offline || needsLogin) {
          throw const CacheFailure(message: 'Sync before switching currency');
        }
        throw const CacheFailure(
          message: 'Currency switch requires online request',
        );
      }
      final previous = _map(_clone(_data));
      final type = kind.split('_').last;
      final before = kind == 'update_settings'
          ? settings
          : kind.startsWith('create_')
          ? <String, dynamic>{}
          : _records(type).where((item) => item['id'] == entityId).firstOrNull;
      if (before == null) {
        throw const CacheFailure(message: 'Offline journal unavailable');
      }
      final data = _map(_clone(payload));
      data.removeWhere(
        (key, value) =>
            value == null &&
            !['impulse_item_id', 'note', 'target_date'].contains(key),
      );
      if (kind == 'create_event' || kind == 'create_spent') {
        data.putIfAbsent(
          'occurred_at',
          () => DateTime.now().toUtc().toIso8601String(),
        );
      }
      if (kind != 'update_settings') {
        data.putIfAbsent('currency_code', () => _currency);
      }
      final op = <String, dynamic>{
        'operation_id': _uuid(),
        'kind': kind,
        'entity_id': entityId,
        'payload': data,
        'before': _map(_clone(before))..remove('id'),
        'ledger': _currency,
      };
      if (kind.startsWith('create_')) {
        final temp = (_data['next_id'] as int? ?? 0) - 1;
        _data['next_id'] = temp;
        op['local_id'] = temp;
      }
      _data['operations'] = [..._operations, op];
      final projected = _dashboard()!;
      final goals = (projected['goals'] as List).map(_map);
      if (goals.any(
        (g) => _number(g['allocated_amount']) > _number(g['target_amount']),
      )) {
        _data = previous;
        throw const ValidationFailure(
          message: 'Release goal funds before reducing its target',
        );
      }
      if (goals.fold<double>(0, (n, g) => n + _number(g['allocated_amount'])) >
          _number(projected['invested_total']) + 0.005) {
        _data = previous;
        throw const ValidationFailure(
          message: 'Release goal allocations before reducing saved funds',
        );
      }
      try {
        await _persist(id);
      } catch (_) {
        _data = previous;
        issue = 'storage';
        throw const CacheFailure(message: 'Offline storage unavailable');
      }
      revision++;
      notifyListeners();
      unawaited(sync());
      return 'Saved on this device';
    });
  }

  Future<void> sync({bool force = false}) async {
    if (!enabled ||
        syncing ||
        !_connectivity.isOnline ||
        _session.needsOnlineLogin ||
        !_canSync()) {
      return;
    }
    await _ready;
    if (!_canSync() || _session.needsOnlineLogin) return;
    if (!hasLocalChanges && force && _account != null) {
      issue = null;
      _fetchTimes.clear();
      revision++;
      notifyListeners();
      return;
    }
    if (syncing ||
        _account == null ||
        !hasLocalChanges ||
        (problemStatus != null && !force)) {
      return;
    }
    syncing = true;
    notifyListeners();
    final id = _account!, auth = _session.getAuthHeader()!;
    try {
      if (force) {
        await _serial(() async {
          _data.remove('problem_status');
          await _persist(id);
        });
      }
      while (_account == id && !_session.needsOnlineLogin && _canSync()) {
        final pending = _operations
            .where((op) => op['synced'] != true)
            .firstOrNull;
        if (pending == null) break;
        final wire = await _serial(() async {
          final op = _operations.firstWhere(
            (o) => o['operation_id'] == pending['operation_id'],
          );
          if (op['wire'] == null) {
            op['wire'] = {
              'operation_id': op['operation_id'],
              'kind': op['kind'],
              'entity_id': op['entity_id'],
              'payload': op['payload'],
              'before': op['before'],
              'force': op['force'] ?? false,
            };
            _replaceOperation(op);
            await _persist(id);
          }
          return _map(_clone(op['wire']));
        });
        if (_account != id || _session.getAuthHeader() != auth) return;
        final response = await _api.syncSavings(auth, wire);
        if (_account != id) return;
        await _serial(() async {
          final ops = _operations;
          final op = ops.firstWhere(
            (o) => o['operation_id'] == pending['operation_id'],
          );
          op['synced'] = true;
          final localId = op['local_id'], serverId = response.data!.entityId;
          if (localId != null && serverId != null) {
            for (final item in ops) {
              if (item['entity_id'] == localId) item['entity_id'] = serverId;
              // Keep local_id until replacing the entire acknowledged overlay.
              if (_map(item['payload'])['impulse_item_id'] == localId) {
                item['payload']['impulse_item_id'] = serverId;
              }
              if (_map(item['before'])['impulse_item_id'] == localId) {
                item['before']['impulse_item_id'] = serverId;
              }
            }
            op['local_id'] = serverId;
          }
          _data['operations'] = ops;
          await _persist(id);
          if (_account == id &&
              op['kind'] == 'create_impulse' &&
              localId != null &&
              serverId != null) {
            try {
              await onImpulseRemapped?.call(localId as int, serverId);
            } catch (_) {
              /* Widget preferences must not block financial synchronization. */
            }
          }
        });
      }
      if (_account != id || _operations.any((op) => op['synced'] != true)) {
        return;
      }
      // Swap the baseline and remove acknowledgements together. A network loss
      // here keeps the overlay, including operations already accepted remotely.
      final snapshotIds = _operations.map((op) => op['operation_id']).toSet();
      final dashboard = (await _api.getSavingsDashboard()).data!.toJson();
      final impulses = (await _api.getImpulseItems(
        true,
      )).data!.map((e) => e.toJson()).toList();
      final freshSettings = (await _api.getSavingsSettings()).data!.toJson();
      final events = await _api.getSavingEvents(1, 50);
      final spent = (await _api.getSpentHistory(1, 50)).data!.toJson();
      if (_account != id || _session.getAuthHeader() != auth) return;
      await _serial(() async {
        final allOps = _operations;
        _data['operations'] = allOps
            .where((op) => snapshotIds.contains(op['operation_id']))
            .toList();
        final knownEvents = _records(
          'event',
          freshSettings['currency_code'] as String,
        );
        final knownSpent = _records(
          'spent',
          freshSettings['currency_code'] as String,
        );
        _data['operations'] = allOps
            .where((op) => !snapshotIds.contains(op['operation_id']))
            .toList();
        _cache('settings', freshSettings);
        _saveLedger({
          'events': {for (final event in knownEvents) '${event['id']}': event},
          'spent': {for (final event in knownSpent) '${event['id']}': event},
        }, freshSettings['currency_code'] as String);
        _cache('dashboard', dashboard);
        _cache('impulses', impulses);
        _cache('spent:1', spent);
        _cache('events:1', {
          'page': 1,
          'total': events.total,
          'data': events.data.map((e) => e.toJson()).toList(),
        });
        _data.remove('problem_status');
        issue = null;
        await _persist(id);
        revision++;
        notifyListeners();
      });
    } on DioException catch (error) {
      if (_account == id) {
        final code = error.response?.statusCode;
        issue = code == 401
            ? 'login'
            : code == null || code >= 500
            ? 'network'
            : 'conflict';
        if (code != null && code != 401 && code < 500) {
          await _serial(() async {
            _data['problem_status'] = code;
            await _persist(id);
          });
        }
      }
    } catch (_) {
      if (_account == id) issue = 'storage';
    } finally {
      syncing = false;
      notifyListeners();
    }
  }

  void _replaceOperation(Json op) {
    _data['operations'] = [
      for (final item in _operations)
        item['operation_id'] == op['operation_id'] ? op : item,
    ];
  }

  Future<String> switchLedger(SavingsSettingsRequest request) async {
    final expectedAccount = _session.accountId;
    await _ready;
    if (_account != expectedAccount) {
      throw const CacheFailure(message: 'Local account changed');
    }
    if (hasLocalChanges || offline || needsLogin) {
      throw const CacheFailure(message: 'Sync before switching currency');
    }
    final id = _account;
    final response = await _api.updateSavingsSettings(request);
    final fresh = (await _api.getSavingsSettings()).data!.toJson();
    if (_account != id || id == null) {
      throw const CacheFailure(message: 'Local account changed');
    }
    await _serial(() async {
      _data['settings'] = fresh;
      await _persist(id);
    });
    return response.message;
  }

  Future<void> keepLocalVersion() async {
    if (syncing) return;
    if (problemStatus != 409) return;
    await _serial(() async {
      final op = _operations.where((op) => op['synced'] != true).first;
      op['operation_id'] = _uuid();
      op['force'] = true;
      op.remove('wire');
      final ops = _operations,
          index = ops.indexWhere((o) => o['synced'] != true);
      ops[index] = op;
      _data['operations'] = ops;
      _data.remove('problem_status');
      await _persist(_account!);
    });
    await sync();
  }

  Future<void> discardProblem() async {
    if (syncing) return;
    await _serial(() async {
      final ops = _operations,
          first = ops.where((op) => op['synced'] != true).firstOrNull;
      if (first == null) return;
      final local = first['local_id'];
      _data['operations'] = ops
          .where(
            (op) =>
                op['operation_id'] != first['operation_id'] &&
                (local == null ||
                    (op['entity_id'] != local &&
                        _map(op['payload'])['impulse_item_id'] != local)),
          )
          .toList();
      _data.remove('problem_status');
      issue = null;
      await _persist(_account!);
      revision++;
      notifyListeners();
    });
    await sync();
  }

  Future<void> purgeAccount([int? account]) async {
    await _ready;
    final id = account ?? _account;
    if (id == null) return;
    await _serial(() async {
      await _storage.delete(key: 'offline_savings_v1_$id');
      if (_account == id) {
        _data = {};
        revision++;
        notifyListeners();
      }
    });
  }

  static String _uuid() {
    final random = math.Random.secure(), bytes = List.generate(16, (_) => 0);
    for (var i = 0; i < 16; i++) {
      bytes[i] = random.nextInt(256);
    }
    bytes[6] = (bytes[6] & 15) | 64;
    bytes[8] = (bytes[8] & 63) | 128;
    final s = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${s.substring(0, 8)}-${s.substring(8, 12)}-${s.substring(12, 16)}-${s.substring(16, 20)}-${s.substring(20)}';
  }

  @override
  void dispose() {
    _retry?.cancel();
    _connection?.cancel();
    _session.removeListener(_sessionChanged);
    super.dispose();
  }
}
