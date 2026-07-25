import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/config/config_provider.dart';
import 'core/storage/storage_providers.dart';

/// Initializes application services and launches the widget tree.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Load AppConfig from environment
  final appConfig = AppConfig.load();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        appConfigProvider.overrideWithValue(appConfig),
      ],
      child: const TrustScanApp(),
    ),
  );
}
