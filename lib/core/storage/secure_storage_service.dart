import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../error/exceptions.dart';

/// Thin wrapper around `flutter_secure_storage`.
///
/// Used for tokens and other credentials; regular cached data belongs in
/// [KeyValueStore] (Hive) instead.
///
/// Note: on Web the browser only exposes this API in a secure context, so the
/// app must be served over HTTPS (or `localhost` during development).
class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  Future<String?> read(String key) => _guard(() => _storage.read(key: key));

  Future<void> write(String key, String value) =>
      _guard(() => _storage.write(key: key, value: value));

  Future<void> delete(String key) => _guard(() => _storage.delete(key: key));

  /// Removes every entry owned by the application.
  Future<void> deleteAll() => _guard(_storage.deleteAll);

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } catch (error) {
      throw CacheException(
        'Secure storage operation failed: $error',
        cause: error,
      );
    }
  }
}
