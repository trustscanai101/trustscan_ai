import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

/// Initializes application services and launches the widget tree.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SharedPreferences, Hive, and environment config are wired in later steps.

  runApp(
    const ProviderScope(
      child: TrustScanApp(),
    ),
  );
}
