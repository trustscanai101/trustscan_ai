import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Storage service abstraction for local data persistence.
final class StorageService {
  StorageService._({
    required this.sharedPreferences,
    required this.hive,
  });

  /// Creates a StorageService with the given dependencies.
  factory StorageService.create({
    required SharedPreferences sharedPreferences,
    required HiveInterface hive,
  }) {
    return StorageService._(
      sharedPreferences: sharedPreferences,
      hive: hive,
    );
  }

  final SharedPreferences sharedPreferences;
  final HiveInterface hive;

  /// SharedPreferences key-value operations
  Future<bool> setString(String key, String value) async {
    return await sharedPreferences.setString(key, value);
  }

  Future<bool> setBool(String key, bool value) async {
    return await sharedPreferences.setBool(key, value);
  }

  Future<bool> setInt(String key, int value) async {
    return await sharedPreferences.setInt(key, value);
  }

  Future<bool> setDouble(String key, double value) async {
    return await sharedPreferences.setDouble(key, value);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    return await sharedPreferences.setStringList(key, value);
  }

  String? getString(String key) {
    return sharedPreferences.getString(key);
  }

  bool? getBool(String key) {
    return sharedPreferences.getBool(key);
  }

  int? getInt(String key) {
    return sharedPreferences.getInt(key);
  }

  double? getDouble(String key) {
    return sharedPreferences.getDouble(key);
  }

  List<String>? getStringList(String key) {
    return sharedPreferences.getStringList(key);
  }

  Future<bool> remove(String key) async {
    return await sharedPreferences.remove(key);
  }

  Future<bool> clear() async {
    return await sharedPreferences.clear();
  }

  bool containsKey(String key) {
    return sharedPreferences.containsKey(key);
  }

  /// Hive box operations
  Future<Box<T>> openBox<T>(String name) async {
    return await hive.openBox<T>(name);
  }

  Box<T>? box<T>(String name) {
    return hive.box(name);
  }

  Future<void> closeBox(String name) async {
    await hive.box(name).close();
  }

  Future<void> deleteBoxFromDisk(String name) async {
    await hive.deleteBoxFromDisk(name);
  }

  Future<void> closeAll() async {
    await hive.close();
  }
}
