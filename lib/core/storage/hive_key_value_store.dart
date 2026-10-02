import 'package:hive_ce/hive.dart';

import '../error/exceptions.dart';
import 'key_value_store.dart';

/// Hive backed [KeyValueStore].
///
/// Values are stored as-is; features decide whether to persist a model or its
/// JSON encoded form. Prefer JSON strings so the same cache works on mobile
/// and on Web (IndexedDB).
class HiveKeyValueStore implements KeyValueStore {
  HiveKeyValueStore(this._box);

  /// Opens (or creates) the box with [boxName].
  static Future<HiveKeyValueStore> open(String boxName) async {
    try {
      final box = await Hive.openBox<dynamic>(boxName);
      return HiveKeyValueStore(box);
    } on HiveError catch (error) {
      throw CacheException(
        'Could not open the Hive box "$boxName": ${error.message}',
        cause: error,
      );
    }
  }

  final Box<dynamic> _box;

  @override
  T? read<T>(String key) {
    final value = _box.get(key);
    return value is T ? value : null;
  }

  @override
  Future<void> write(String key, Object value) =>
      _guard(() => _box.put(key, value));

  @override
  Future<void> delete(String key) => _guard(() => _box.delete(key));

  @override
  Future<void> clear() => _guard(_box.clear);

  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } on HiveError catch (error) {
      throw CacheException(
        'Hive operation failed: ${error.message}',
        cause: error,
      );
    }
  }
}
