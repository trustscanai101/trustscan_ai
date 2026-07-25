import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:trustscan_ai/app.dart';
import 'package:trustscan_ai/features/splash/presentation/splash_screen.dart';

void main() {
  testWidgets('TrustScanApp renders splash screen on initial route', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: TrustScanApp(),
      ),
    );

    expect(find.byType(SplashScreen), findsOneWidget);
  });
}
