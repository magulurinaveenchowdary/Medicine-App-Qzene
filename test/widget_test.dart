import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:med_reminder/core/providers/AppBootstrapInitializationProvider.dart';
import 'package:med_reminder/main.dart';

void main() {
  testWidgets('App boots with ProviderScope', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appBootstrapInitializationProvider.overrideWith((ref) async {}),
        ],
        child: const MedicineReminderRootAppWidget(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
