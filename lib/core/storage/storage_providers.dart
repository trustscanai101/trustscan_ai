import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'storage_service.dart';

/// Provider for SharedPreferences instance.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'SharedPreferences must be initialized in bootstrap.dart',
  );
});

/// Provider for Hive instance.
final hiveProvider = Provider<HiveInterface>((ref) {
  return Hive;
});

/// Provider for StorageService.
final storageServiceProvider = Provider<StorageService>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  final hive = ref.watch(hiveProvider);
  return StorageService.create(
    sharedPreferences: sharedPreferences,
    hive: hive,
  );
});
