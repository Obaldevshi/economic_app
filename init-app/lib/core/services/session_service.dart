import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService extends ChangeNotifier {
  static const String _accessTokenKey = 'access_token';
  static const String _tokenTypeKey = 'token_type';
  static const String _expiresInKey = 'expires_in';
  static const String _loginTimeKey = 'login_time';

  SessionService._(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  String? _accessToken;
  String? _tokenType;
  int? _expiresIn;
  int? _loginTime;
  bool _needsOnlineLogin = false;
  Map<String, dynamic> get _tokenClaims {
    try {
      final payload = jsonDecode(
        utf8.decode(
          base64Url.decode(base64Url.normalize(_accessToken!.split('.')[1])),
        ),
      );
      return Map<String, dynamic>.from(payload as Map);
    } catch (_) {
      return {};
    }
  }

  int? get accountId => int.tryParse('${_tokenClaims['user_id']}');
  String? get accountEmail => switch (_tokenClaims['email']) {
    String email => email,
    _ => null,
  };

  bool get needsOnlineLogin =>
      _needsOnlineLogin || getAuthHeader() == null || isTokenExpired();
  void requireOnlineLogin() {
    _needsOnlineLogin = true;
    notifyListeners();
  }

  static Future<SessionService> create(
    FlutterSecureStorage secureStorage,
    SharedPreferences prefs,
  ) async {
    final service = SessionService._(secureStorage);
    await service._loadFromStorage();
    await service._migrateFromSharedPreferences(prefs);
    return service;
  }

  Future<void> _loadFromStorage() async {
    try {
      _accessToken = await _secureStorage.read(key: _accessTokenKey);
      _tokenType = await _secureStorage.read(key: _tokenTypeKey);
      _expiresIn = int.tryParse(
        await _secureStorage.read(key: _expiresInKey) ?? '',
      );
      _loginTime = int.tryParse(
        await _secureStorage.read(key: _loginTimeKey) ?? '',
      );
    } catch (error, stackTrace) {
      // WebCrypto throws OperationError when legacy values were encrypted by
      // different keys. Treat an unreadable token as an expired session.
      debugPrint('Failed to restore secure session: $error');
      debugPrintStack(stackTrace: stackTrace);
      _resetInMemorySession();

      try {
        await _deleteStoredSession();
      } catch (deleteError) {
        debugPrint('Failed to remove unreadable secure session: $deleteError');
      }
    }
  }

  Future<void> _migrateFromSharedPreferences(SharedPreferences prefs) async {
    final legacyToken = prefs.getString(_accessTokenKey);
    if (legacyToken == null || legacyToken.isEmpty) return;

    final tokenType = prefs.getString(_tokenTypeKey);
    final expiresIn = prefs.getInt(_expiresInKey);
    final loginTime = prefs.getInt(_loginTimeKey);

    // Secure storage is authoritative. A leftover legacy session must never
    // replace a more recent account (including its offline journal identity).
    if (accountId == null &&
        tokenType != null &&
        tokenType.isNotEmpty &&
        expiresIn != null &&
        loginTime != null) {
      await saveToken(
        accessToken: legacyToken,
        tokenType: tokenType,
        expiresIn: expiresIn,
        loginTime: loginTime,
      );
    }

    await Future.wait([
      prefs.remove(_accessTokenKey),
      prefs.remove(_tokenTypeKey),
      prefs.remove(_expiresInKey),
      prefs.remove(_loginTimeKey),
    ]);
  }

  Future<void> saveToken({
    required String accessToken,
    required String tokenType,
    required int expiresIn,
    int? loginTime,
  }) async {
    final resolvedLoginTime =
        loginTime ?? DateTime.now().millisecondsSinceEpoch;

    // Keep writes sequential. On web the first write creates the WebCrypto
    // key; parallel writes can race and encrypt values with different keys.
    await _secureStorage.write(key: _accessTokenKey, value: accessToken);
    await _secureStorage.write(key: _tokenTypeKey, value: tokenType);
    await _secureStorage.write(key: _expiresInKey, value: expiresIn.toString());
    await _secureStorage.write(
      key: _loginTimeKey,
      value: resolvedLoginTime.toString(),
    );

    _accessToken = accessToken;
    _tokenType = tokenType;
    _expiresIn = expiresIn;
    _loginTime = resolvedLoginTime;
    _needsOnlineLogin = false;
    notifyListeners();
  }

  String? getAccessToken() => _accessToken;

  String? getTokenType() => _tokenType;

  bool isLoggedIn() {
    final token = getAccessToken();
    if (token == null || token.isEmpty) return false;

    // Expiry revokes server access, not access to this account's local journal.
    // Offline work remains on this device until a successful password login.
    final mobile =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);
    return accountId != null && (mobile || !needsOnlineLogin);
  }

  bool isTokenExpired() {
    final expiresIn = _expiresIn;
    final loginTime = _loginTime;

    if (expiresIn == null || loginTime == null) return true;

    final expirationTime = loginTime + (expiresIn * 1000);
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    return currentTime >= expirationTime;
  }

  String? getAuthHeader() {
    final tokenType = getTokenType();
    final accessToken = getAccessToken();

    if (tokenType == null ||
        tokenType.trim().isEmpty ||
        accessToken == null ||
        accessToken.isEmpty) {
      return null;
    }

    return '$tokenType $accessToken';
  }

  Future<void> clearSession() async {
    _resetInMemorySession();
    // Clear visible account state even when the OS refuses a storage delete.
    // Keep the storage error observable to the caller; do not claim persistence.
    notifyListeners();
    await _deleteStoredSession();
  }

  void _resetInMemorySession() {
    _accessToken = null;
    _tokenType = null;
    _expiresIn = null;
    _loginTime = null;
    _needsOnlineLogin = false;
  }

  Future<void> _deleteStoredSession() async {
    // Attempt every key even if one delete fails, without touching journal data.
    await Future.wait([
      _secureStorage.delete(key: _accessTokenKey),
      _secureStorage.delete(key: _tokenTypeKey),
      _secureStorage.delete(key: _expiresInKey),
      _secureStorage.delete(key: _loginTimeKey),
    ]);
  }

  DateTime? getLoginTime() {
    final loginTime = _loginTime;
    if (loginTime == null) return null;

    return DateTime.fromMillisecondsSinceEpoch(loginTime);
  }

  Duration? getTokenRemainingTime() {
    final expiresIn = _expiresIn;
    final loginTime = _loginTime;

    if (expiresIn == null || loginTime == null) return null;

    final expirationTime = loginTime + (expiresIn * 1000);
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (currentTime >= expirationTime) return Duration.zero;

    return Duration(milliseconds: expirationTime - currentTime);
  }
}
