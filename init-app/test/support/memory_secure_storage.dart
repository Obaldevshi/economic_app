import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Isolated storage for unit tests. Never reads browser/device credentials.
class MemorySecureStorage extends FlutterSecureStorage {
  final values = <String, String>{};
  bool failWrites = false;
  final failDeletes = <String>{};
  Future<void> Function(String key)? beforeWrite;
  Future<void> Function(String key)? beforeRead;

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    await beforeRead?.call(key);
    return values[key];
  }

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    await beforeWrite?.call(key);
    if (failWrites) throw StateError('Simulated storage failure');
    if (value == null) {
      values.remove(key);
    } else {
      values[key] = value;
    }
  }

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (failDeletes.contains(key)) {
      throw StateError('Simulated delete failure');
    }
    values.remove(key);
  }
}
