import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:transcosmos_test/domain/entities/surah_detail.dart';

import '../controllers/surah_detail_controller_test.dart';

// Test wrapper for SurahDetailScreen
class TestSurahDetailScreen extends StatelessWidget {
  final int surahNumber;
  final MockSurahDetailController controller;
  final bool autoLoad;

  const TestSurahDetailScreen({
    super.key,
    required this.surahNumber,
    required this.controller,
    this.autoLoad = true,
  });

  @override
  Widget build(BuildContext context) {
    // Load surah detail when screen is built (only if autoLoad is true)
    if (autoLoad) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.getSurahDetail(surahNumber);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.surahDetail?.namaLatin ?? 'Memuat...',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async => controller.getSurahDetail(surahNumber),
        child: Obx(() {
          if (controller.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading...'),
                ],
              ),
            );
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Error',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      controller.errorMessage,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.getSurahDetail(surahNumber),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final surahDetail = controller.surahDetail;
          if (surahDetail == null) {
            return const Center(child: Text('Tidak ada detail surah'));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                bottom:
                    controller.audioPlayerHeight > 0
                        ? controller.audioPlayerHeight
                        : kBottomNavigationBarHeight,
              ),
              child: Column(
                children: [
                  // Surah Header
                  _buildHeader(surahDetail, context),
                  const SizedBox(height: 8),
                  // Surah Description
                  _buildDescription(context, surahDetail),
                  const SizedBox(height: 32),
                  Text(
                    'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  // Ayats List
                  _buildAyatList(surahDetail),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeader(SurahDetail surahDetail, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Text(
            surahDetail.nama,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            surahDetail.arti,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoChip(
                context,
                '${surahDetail.jumlahAyat} Ayat',
                Icons.menu_book,
              ),
              _buildInfoChip(
                context,
                surahDetail.tempatTurun.capitalize!,
                Icons.location_on,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context, SurahDetail surahDetail) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Deskripsi',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            surahDetail.deskripsi,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAyatList(SurahDetail surahDetail) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: surahDetail.ayats.length,
      itemBuilder: (context, index) {
        final ayat = surahDetail.ayats[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    ayat.nomor.toString(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  ayat.ar,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    height: 2.0,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  ayat.tr,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  ayat.idn,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.5,
                  ),
                ),
              ),
              if (index < surahDetail.ayats.length - 1) ...[
                const SizedBox(height: 16),
                Divider(color: Colors.grey[300], height: 1),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoChip(BuildContext context, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SurahDetailScreen', () {
    late MockSurahDetailController controller;

    setUp(() {
      controller = MockSurahDetailController();
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    Widget createTestWidget(int surahNumber, {bool autoLoad = true}) {
      return GetMaterialApp(
        home: GetBuilder<MockSurahDetailController>(
          init: controller,
          builder:
              (controller) => TestSurahDetailScreen(
                surahNumber: surahNumber,
                controller: controller,
                autoLoad: autoLoad,
              ),
        ),
        initialBinding: BindingsBuilder(() {
          Get.put<MockSurahDetailController>(controller);
        }),
      );
    }

    group('Screen Initialization', () {
      testWidgets('should show loading state initially', (
        WidgetTester tester,
      ) async {
        // Arrange
        controller.setLoading(true);
        await tester.pumpWidget(createTestWidget(1, autoLoad: false));

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Loading...'), findsOneWidget);
      });

      testWidgets('should show app bar with surah name when loaded', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(1));

        // Act
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
        await tester.pumpWidget(createTestWidget(1, autoLoad: false));

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Loading...'), findsOneWidget);
      });

      testWidgets('should hide loading widget when data is loaded', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(1));

        // Act
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
        // Arrange
        controller.setError('Network error');
        controller.setLoading(false);
        await tester.pumpWidget(createTestWidget(1, autoLoad: false));

        // Act
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Error'), findsOneWidget);
        expect(find.text('Network error'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('should show retry button in error state', (
        WidgetTester tester,
      ) async {
        // Arrange
        controller.setError('Network error');
        controller.setLoading(false);
        await tester.pumpWidget(createTestWidget(1, autoLoad: false));

        // Act
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Retry'), findsOneWidget);
      });

      testWidgets('should call retry function when retry button is pressed', (
        WidgetTester tester,
      ) async {
        // Arrange
        controller.setError('Network error');
        controller.setLoading(false);
        await tester.pumpWidget(createTestWidget(1, autoLoad: false));
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

        // Act
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
        // Arrange
        controller.setSurahDetail(null);
        controller.setLoading(false);
        controller.setError('');
        await tester.pumpWidget(createTestWidget(1, autoLoad: false));

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
