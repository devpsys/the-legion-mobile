import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../constants/storage_boxes.dart';
import '../storage/hive_key_value_store.dart';
import '../storage/key_value_store.dart';
import '../storage/secure_storage_service.dart';

/// Registers local persistence.
///
/// Credentials live in [SecureStorageService]; cached, non-sensitive data
/// lives in the Hive backed [KeyValueStore].
Future<void> registerStorageModule(GetIt sl) async {
  // `initFlutter` resolves the right backend per platform (files on mobile,
  // IndexedDB on web).
  await Hive.initFlutter();

  sl.registerSingleton<KeyValueStore>(
    await HiveKeyValueStore.open(StorageBoxes.cache),
  );
  sl.registerLazySingleton<SecureStorageService>(SecureStorageService.new);
}
