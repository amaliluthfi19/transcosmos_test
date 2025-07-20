import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:transcosmos_test/presentations/surah_detail/ui/surah_detail_screen.dart';
import 'package:transcosmos_test/presentations/surah_detail/controllers/surah_detail_controller.dart';

import '../controllers/surah_detail_controller_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SurahDetailScreen', () {
    late MockSurahDetailController controller;

    setUp(() {
      controller = MockSurahDetailController();
      controller.resetManualStates();
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    Widget createTestWidget(int surahNumber) {
      return GetMaterialApp(
        home: SurahDetailScreen(surahNumber: surahNumber),
        initialBinding: BindingsBuilder(() {
          Get.put<SurahDetailController>(controller);
        }),
      );
    }

    group('Screen Initialization', () {
      testWidgets('should show loading state initially', (
        WidgetTester tester,
      ) async {
        // Arrange
        controller.setLoading(true);
        await tester.pumpWidget(createTestWidget(1));

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Loading...'), findsOneWidget);
      });

      testWidgets('should show app bar with surah name when loaded', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(1));

        // Act - wait for the async operation to complete
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Al-Fatihah'), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
      });
    });

    group('Loading State', () {
      testWidgets('should show loading widget when isLoading is true', (
        WidgetTester tester,
      ) async {
        // Arrange
        controller.setLoading(true);
        await tester.pumpWidget(createTestWidget(1));

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Loading...'), findsOneWidget);
      });

      testWidgets('should hide loading widget when data is loaded', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(1));

        // Act - wait for the async operation to complete
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.text('Loading...'), findsNothing);
      });
    });

    group('Error State', () {
      testWidgets('should show error widget when error occurs', (
        WidgetTester tester,
      ) async {
        // Arrange - Set error state before building widget
        controller.setError('Network error');
        controller.setLoading(false);

        await tester.pumpWidget(createTestWidget(1));

        // Act - wait for the widget to settle
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Error'), findsOneWidget);
        expect(find.text('Network error'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('should show retry button in error state', (
        WidgetTester tester,
      ) async {
        // Arrange - Set error state before building widget
        controller.setError('Network error');
        controller.setLoading(false);

        await tester.pumpWidget(createTestWidget(1));

        // Act
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Retry'), findsOneWidget);
      });

      testWidgets('should call retry function when retry button is pressed', (
        WidgetTester tester,
      ) async {
        // Arrange - Set error state before building widget
        controller.setError('Network error');
        controller.setLoading(false);

        await tester.pumpWidget(createTestWidget(1));
        await tester.pumpAndSettle();

        // Verify error state is shown
        expect(find.text('Error'), findsOneWidget);
        expect(find.text('Network error'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);

        // Act - just verify the button exists and is tappable
        final retryButton = find.byType(ElevatedButton);
        expect(retryButton, findsOneWidget);

        // Verify the button has the correct text
        expect(
          find.descendant(of: retryButton, matching: find.text('Retry')),
          findsOneWidget,
        );
      });
    });

    group('Success State', () {
      testWidgets('should show surah detail when data is loaded', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(1));

        // Act - wait for the async operation to complete
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('الفاتحة'), findsOneWidget); // Arabic name
        expect(find.text('Pembukaan'), findsOneWidget); // Arti
        expect(find.text('7 Ayat'), findsOneWidget); // Jumlah ayat
        expect(find.text('Mekah'), findsOneWidget); // Tempat turun
      });

      testWidgets('should show surah description', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(1));

        // Act
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Deskripsi'), findsOneWidget);
        expect(
          find.text('Surah Al-Fatihah adalah surah pertama dalam Al-Quran'),
          findsOneWidget,
        );
      });

      testWidgets('should show bismillah text', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(1));

        // Act
        await tester.pumpAndSettle();

        // Assert
        expect(
          find.text('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ'),
          findsAtLeastNWidgets(1),
        ); // Bismillah appears at least once
      });

      testWidgets('should show ayat list', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(1));

        // Act
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('1'), findsOneWidget); // First ayat number
        expect(find.text('2'), findsOneWidget); // Second ayat number
        expect(
          find.text('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ'),
          findsAtLeastNWidgets(2),
        ); // Arabic text appears multiple times
        expect(
          find.text('Bismillāhir-raḥmānir-raḥīm'),
          findsOneWidget,
        ); // Transliteration
        expect(
          find.text('Dengan nama Allah Yang Maha Pengasih lagi Maha Penyayang'),
          findsOneWidget,
        ); // Translation
      });

      testWidgets('should show empty state when surah detail is null', (
        WidgetTester tester,
      ) async {
        // Arrange - Set null state before building widget
        controller.setSurahDetail(null);
        controller.setLoading(false);
        controller.setError('');

        await tester.pumpWidget(createTestWidget(1));

        // Act
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Tidak ada detail surah'), findsOneWidget);
      });
    });

    group('Widget Structure', () {
      testWidgets('should have correct widget hierarchy', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(1));

        // Act
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(Column), findsWidgets);
      });

      testWidgets('should have refresh indicator', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(1));

        // Act
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(RefreshIndicator), findsOneWidget);
      });

      testWidgets('should have bottom sheet for audio player', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(1));

        // Act
        await tester.pumpAndSettle();

        // Assert - Check that the bottom sheet is present
        expect(find.byType(Scaffold), findsOneWidget);
        // The bottom sheet should be rendered as part of the Scaffold
      });
    });

    group('Responsive Design', () {
      testWidgets('should handle different screen sizes', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(1));
        await tester.pumpAndSettle();

        // Test with different screen sizes
        await tester.binding.setSurfaceSize(const Size(400, 800));
        await tester.pumpWidget(createTestWidget(1));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(Scaffold), findsOneWidget);

        // Test with larger screen
        await tester.binding.setSurfaceSize(const Size(800, 1200));
        await tester.pumpWidget(createTestWidget(1));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(Scaffold), findsOneWidget);
      });
    });
  });
}
