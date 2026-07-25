import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:trustscan_ai/app.dart';

void main() {
  testWidgets('TrustScanApp renders branded launch screen', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: TrustScanApp(),
      ),
    );

    expect(find.text('TrustScan AI'), findsOneWidget);
    expect(find.text('Scan Before You Trust'), findsOneWidget);
    expect(find.byIcon(Icons.verified_user_outlined), findsOneWidget);
  });
}
