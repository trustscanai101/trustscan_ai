import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_colors.dart';

class TrustScanApp extends StatelessWidget {
  const TrustScanApp({super.key});

  static const String appName = 'TrustScan AI';
  static const String tagline = 'Scan Before You Trust';

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryBlue,
      brightness: brightness,
      surface: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      textTheme: GoogleFonts.interTextTheme(
        ThemeData(brightness: brightness).textTheme,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
    );
  }
}
