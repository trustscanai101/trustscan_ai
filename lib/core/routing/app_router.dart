import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../features/history/presentation/history_screen.dart';
import '../../features/login/presentation/login_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import 'route_names.dart';

/// Application router configuration using go_router.
final class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.home,
        name: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteNames.settings,
        name: RouteNames.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: RouteNames.history,
        name: RouteNames.history,
        builder: (context, state) => const HistoryScreen(),
      ),
    ],
  );
}
