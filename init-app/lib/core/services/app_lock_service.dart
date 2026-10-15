import 'dart:convert';
import 'dart:math';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_template/core/services/session_service.dart';

Future<String> _pinHash(List<String> values) async {
  final algorithm = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 600000,
    bits: 256,
  );
  final key = await algorithm.deriveKey(
    secretKey: SecretKey(utf8.encode(values[0])),
    nonce: base64Decode(values[1]),
  );
  return base64Encode(await key.extractBytes());
}

class AppLockService extends ChangeNotifier {
  AppLockService(this._storage, this._session);
  final FlutterSecureStorage _storage;
  final SessionService _session;
  int? _account;
  String? _token;
  Map<String, dynamic> _record = {};
  bool loading = true, locked = true, prompt = false, passwordRecovery = false;
  bool _changeRequested = false, _removeRequested = false;
  bool storageError = false;
  bool get hasPin => _record['hash'] != null;
  bool get accessible => !loading && !locked && !prompt && !passwordRecovery;
  Duration get retryAfter {
    final until = _record['until'] as int? ?? 0;
    return Duration(
      milliseconds: max(0, until - DateTime.now().millisecondsSinceEpoch),
    );
  }

  Future<void> init() async {
    _session.addListener(_sessionChanged);
    await _activate();
  }

  Future<void> _activate() async {
    final id = _session.accountId;
    _account = id;
    _token = _session.getAccessToken();
    _changeRequested = false;
    _removeRequested = false;
    storageError = false;
    loading = true;
    locked = true;
    prompt = false;
    passwordRecovery = false;
    _record = {};
    notifyListeners();
    if (id == null) {
      loading = false;
      locked = false;
      notifyListeners();
      return;
    }
    try {
      final raw = await _storage.read(key: 'app_pin_v1_$id');
      if (_account != id) return;
      _record = raw == null ? {} : Map<String, dynamic>.from(jsonDecode(raw));
      prompt = !hasPin && _record['skipped'] != true;
      locked = hasPin;
      loading = false;
      notifyListeners();
    } catch (_) {
      // Fail closed if a previously configured PIN cannot be read.
      if (_account == id) {
        loading = false;
        locked = true;
        storageError = true;
        notifyListeners();
      }
    }
  }

  void _sessionChanged() {
    if (_account != _session.accountId) {
      _activate();
      return;
    }
    final token = _session.getAccessToken();
    if (passwordRecovery && token != null && token != _token) {
      _token = token;
      _recoverAfterPassword();
    } else {
      _token = token;
    }
  }

  Future<void> _recoverAfterPassword() async {
    final id = _account;
    if (id == null) return;
    loading = true;
    notifyListeners();
    try {
      await _storage.delete(key: 'app_pin_v1_$id');
      if (_account == id) {
        _record = {};
        locked = false;
        prompt = true;
        passwordRecovery = false;
      }
    } catch (_) {
      if (_account == id) {
        locked = true;
        prompt = false;
        passwordRecovery = false;
        storageError = true;
      }
    } finally {
      if (_account == id) {
        loading = false;
        notifyListeners();
      }
    }
  }

  Future<void> _persist(int id) =>
      _storage.write(key: 'app_pin_v1_$id', value: jsonEncode(_record));
  Future<void> setPin(String pin) async {
    if (hasPin && locked) throw StateError('PIN verification required');
    if (!RegExp(r'^\d{4}$').hasMatch(pin) || _account == null) {
      throw StateError('Invalid PIN');
    }
    final id = _account!,
        salt = base64Encode(
          List.generate(24, (_) => Random.secure().nextInt(256)),
        );
    final hash = await compute(_pinHash, [pin, salt]);
    if (_account != id) return;
    final next = {'salt': salt, 'hash': hash, 'attempts': 0, 'until': 0};
    await _storage.write(key: 'app_pin_v1_$id', value: jsonEncode(next));
    if (_account == id) {
      _record = next;
      storageError = false;
      prompt = false;
      locked = false;
      notifyListeners();
    }
  }

  Future<bool> unlock(String pin) async {
    if (_account == null ||
        !hasPin ||
        retryAfter > Duration.zero ||
        !RegExp(r'^\d{4}$').hasMatch(pin)) {
      return false;
    }
    final id = _account!,
        computed = base64Decode(
          await compute(_pinHash, [pin, _record['salt'] as String]),
        );
    if (_account != id) return false;
    final stored = base64Decode(_record['hash'] as String);
    var mismatch = stored.length ^ computed.length;
    for (var i = 0; i < stored.length && i < computed.length; i++) {
      mismatch |= stored[i] ^ computed[i];
    }
    if (mismatch == 0) {
      _record['attempts'] = 0;
      _record['until'] = 0;
      await _persist(id);
      if (_account == id) {
        if (_removeRequested) {
          _record = {'skipped': true};
          await _persist(id);
        }
        locked = false;
        storageError = false;
        prompt = _changeRequested;
        _changeRequested = false;
        _removeRequested = false;
        notifyListeners();
        return true;
      }
      return false;
    }
    final attempts = (_record['attempts'] as int? ?? 0) + 1;
    _record['attempts'] = attempts;
    if (attempts >= 5) {
      _record['until'] = DateTime.now()
          .add(
            Duration(
              seconds: min(900, 30 * pow(2, min(attempts - 5, 5)).toInt()),
            ),
          )
          .millisecondsSinceEpoch;
    }
    await _persist(id);
    notifyListeners();
    return false;
  }

  Future<void> skip() async {
    if (_account == null || hasPin) return;
    _record = {'skipped': true};
    await _persist(_account!);
    prompt = false;
    locked = false;
    notifyListeners();
  }

  void configure() {
    if (hasPin) {
      _changeRequested = true;
      locked = true;
    } else {
      prompt = true;
    }
    notifyListeners();
  }

  void requestRemove() {
    if (hasPin) {
      _removeRequested = true;
      locked = true;
      notifyListeners();
    }
  }

  Future<void> cancelSetup() async {
    if (hasPin && prompt) {
      prompt = false;
      notifyListeners();
    } else {
      await skip();
    }
  }

  void lock() {
    if (hasPin && _session.isLoggedIn()) {
      locked = true;
      notifyListeners();
    }
  }

  void usePassword() {
    passwordRecovery = true;
    notifyListeners();
  }

  Future<void> purge([int? account]) async {
    final id = account ?? _account;
    if (id != null) await _storage.delete(key: 'app_pin_v1_$id');
    if (_account == id) _record = {};
  }

  @override
  void dispose() {
    _session.removeListener(_sessionChanged);
    super.dispose();
  }
}
