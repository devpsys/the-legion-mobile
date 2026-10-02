/// Persistence contract for cached, non-sensitive data.
///
/// Implemented by `HiveKeyValueStore`. Features depend on this interface (not
/// on Hive) so datasources stay unit testable with an in-memory fake.
abstract interface class KeyValueStore {
  /// Returns the stored value, or `null` when absent or of another type.
  T? read<T>(String key);

  Future<void> write(String key, Object value);

  Future<void> delete(String key);

  Future<void> clear();
}
