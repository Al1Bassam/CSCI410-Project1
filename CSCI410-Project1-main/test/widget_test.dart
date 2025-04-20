// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.


import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/main.dart';  // Update this line with your actual app name

void main() {
  testWidgets('Quiz app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the welcome screen is shown
    expect(find.text('Quiz App'), findsOneWidget);
    expect(find.text('Test your knowledge with our fun quiz!'), findsOneWidget);
    expect(find.text('Start Quiz'), findsOneWidget);

    // Tap the start quiz button
    await tester.tap(find.text('Start Quiz'));
    await tester.pumpAndSettle();

    // Verify that we're on the quiz screen
    expect(find.text('Question 1/10'), findsOneWidget);
    expect(find.text('Time remaining: 30 seconds'), findsOneWidget);
  });
}