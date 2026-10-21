// Widget tests for the Ahime application.
// Verifies that the main screens build without crashing and display
// the expected service cards.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ahime/pages/page_mainscreen.dart';

void main() {
  testWidgets('PageMainscreen displays the three service cards',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PageMainscreen()));

    // The three service cards must be present.
    expect(find.text('HÔTELS'), findsOneWidget);
    expect(find.text('TRANSPORT'), findsOneWidget);
    expect(find.text('ARTISANS'), findsOneWidget);

    // Subtitles must be present as well.
    expect(find.text('Réservez votre hôtel'), findsOneWidget);
    expect(find.text('Trouvez votre trajet'), findsOneWidget);
    expect(find.text('Trouvez un professionnel'), findsOneWidget);
  });

  testWidgets('MyApp builds without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PageMainscreen()));
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
