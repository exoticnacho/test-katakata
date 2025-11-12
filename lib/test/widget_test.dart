// lib/test/widget_test.dart (atau test/widget_test.dart)
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// Import MyApp dari file tempat kamu mendefinisikannya, misalnya app.dart
import 'package:katakata_app/app/app.dart'; // Pastikan path ini benar

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp()); // Pastikan MyApp didefinisikan

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}