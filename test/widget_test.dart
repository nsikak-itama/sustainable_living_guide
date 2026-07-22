import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sustainable_living_guide/main.dart';

void main() {
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SustainableLivingApp(),
      ),
    );

    // Just verifying the app builds and renders a MaterialApp.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}