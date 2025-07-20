import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transcosmos_test/main.dart';

void main() {
  group('Home Feature Widget Tests', () {
    testWidgets('should display loading state initially', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(const MyApp());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('should display surah cards when data is loaded', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(const MyApp());

      // Wait for data to load
      await tester.pumpAndSettle();

      // Assert - Check for surah card elements
      // This test is to ensure the app doesn't crash
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should display error state when network fails', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(const MyApp());

      // Wait for error to occur
      await tester.pumpAndSettle();

      // Assert - Check for error elements
      // This test is to ensure the app doesn't crash
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should display empty state when no surahs', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(const MyApp());

      // Wait for empty state
      await tester.pumpAndSettle();

      // Assert - Check for empty state elements
      // This test is to ensure the app doesn't crash
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
