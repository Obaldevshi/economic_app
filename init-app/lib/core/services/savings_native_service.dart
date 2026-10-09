import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_template/core/services/session_service.dart';
import 'package:mobile_template/data/models/response/savings_response.dart';

class SavingsNativeService {
  SavingsNativeService(this._prefs, this._session);
  final SharedPreferences _prefs;
  final SessionService _session;
  static const _channel = MethodChannel('not_spent/native');
  static const _key = 'saving_quick_favorites';
  final favorites = ValueNotifier<List<int>>([]);
  final pendingImpulse = ValueNotifier<int?>(null);
  List<ImpulseItemResponse> _items = [];
  String? _sessionToken;
  int sessionRevision = 0;
  bool get _mobile =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<void> init() async {
    _sessionToken = _session.getAccessToken();
    favorites.value = (_prefs.getStringList(_key) ?? [])
        .map(int.tryParse)
        .whereType<int>()
        .take(3)
        .toList();
    _session.addListener(_sessionChanged);
    if (!_session.isLoggedIn()) await _clear();
    if (!_mobile) return;
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'quickSaving')
        pendingImpulse.value = call.arguments as int?;
    });
    try {
      pendingImpulse.value = await _channel.invokeMethod<int>('consumeTap');
    } on PlatformException {
      /* Native integration is optional for existing installs. */
    } on MissingPluginException {
      /* Desktop/web don't expose the native bridge. */
    }
  }

  void _sessionChanged() {
    final token = _session.getAccessToken();
    if (token == _sessionToken) return;
    _sessionToken = token;
    sessionRevision++;
    if (token == null) pendingImpulse.value = null;
    _clear();
  }

  Future<void> _clear() async {
    _items = [];
    favorites.value = [];
    await _prefs.remove(_key);
    await _publish();
  }

  Future<bool> toggleFavorite(int id) async {
    final next = [...favorites.value];
    if (next.contains(id)) {
      next.remove(id);
    } else {
      if (next.length >= 3) return false;
      next.add(id);
    }
    favorites.value = next;
    await _prefs.setStringList(_key, next.map((id) => '$id').toList());
    await _publish();
    return true;
  }

  Future<void> syncItems(List<ImpulseItemResponse> items, int revision) async {
    if (revision != sessionRevision || !_session.isLoggedIn()) return;
    _items = items;
    final remaining = favorites.value
        .where((id) => items.any((item) => item.id == id))
        .toList();
    if (remaining.length != favorites.value.length) {
      favorites.value = remaining;
      await _prefs.setStringList(_key, remaining.map((id) => '$id').toList());
    }
    await _publish();
  }

  Future<void> _publish() async {
    if (!_mobile) return;
    final selected = favorites.value
        .map(
          (id) => _items
              .where((item) => item.id == id && item.isActive)
              .firstOrNull,
        )
        .whereType<ImpulseItemResponse>();
    try {
      await _channel.invokeMethod<void>(
        'syncWidget',
        jsonEncode([
          for (final item in selected)
            {'id': item.id, 'name': item.name, 'amount': item.defaultAmount},
        ]),
      );
    } on PlatformException {
      /* Keep the app usable if widget provisioning is unavailable. */
    } on MissingPluginException {
      /* Older app versions may not have this bridge. */
    }
  }
}
