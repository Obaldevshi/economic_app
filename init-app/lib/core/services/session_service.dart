import 'package:flutter/foundation.dart';
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

    if (tokenType != null && expiresIn != null && loginTime != null) {
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
    notifyListeners();
  }

  String? getAccessToken() => _accessToken;

  String? getTokenType() => _tokenType;

  bool isLoggedIn() {
    final token = getAccessToken();
    if (token == null || token.isEmpty) return false;

    return !isTokenExpired();
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

    if (tokenType == null || accessToken == null) return null;

    return '$tokenType $accessToken';
  }

  Future<void> clearSession() async {
    _resetInMemorySession();
    await _deleteStoredSession();
    notifyListeners();
  }

  void _resetInMemorySession() {
    _accessToken = null;
    _tokenType = null;
    _expiresIn = null;
    _loginTime = null;
  }

  Future<void> _deleteStoredSession() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _tokenTypeKey);
    await _secureStorage.delete(key: _expiresInKey);
    await _secureStorage.delete(key: _loginTimeKey);
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
