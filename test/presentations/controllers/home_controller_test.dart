import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:transcosmos_test/domain/entities/surah.dart';
import 'package:transcosmos_test/presentations/home/controllers/home_controller.dart';

import '../../domain/usecases/get_surahs_usecase_test.dart';

void main() {
  group('HomeController', () {
    late HomeController controller;
    late MockGetSurahsUseCase mockUseCase;
    late List<Surah> testSurahs;

    setUp(() {
      testSurahs = [
        Surah(
          nomor: 1,
          nama: 'الفاتحة',
          namaLatin: 'Al-Fatihah',
          jumlahAyat: 7,
          tempatTurun: 'mekah',
          arti: 'Pembukaan',
          deskripsi: 'Surah Al-Fatihah adalah surah pertama dalam Al-Quran',
          audio: 'https://example.com/audio1.mp3',
        ),
        Surah(
          nomor: 2,
          nama: 'البقرة',
          namaLatin: 'Al-Baqarah',
          jumlahAyat: 286,
          tempatTurun: 'madinah',
          arti: 'Sapi',
          deskripsi: 'Surah Al-Baqarah adalah surah kedua dalam Al-Quran',
          audio: 'https://example.com/audio2.mp3',
        ),
        Surah(
          nomor: 3,
          nama: 'آل عمران',
          namaLatin: 'Ali Imran',
          jumlahAyat: 200,
          tempatTurun: 'madinah',
          arti: 'Keluarga Imran',
          deskripsi: 'Surah Ali Imran adalah surah ketiga dalam Al-Quran',
          audio: 'https://example.com/audio3.mp3',
        ),
      ];

      mockUseCase = MockGetSurahsUseCase();
      controller = HomeController(mockUseCase);
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    group('Initialization', () {
      test('should initialize with default values', () {
        // Assert
        expect(controller.surahs, isEmpty);
        expect(controller.isLoading, isFalse);
        expect(controller.errorMessage, isEmpty);
        expect(controller.searchKeyword, isEmpty);
        expect(controller.showSearchBar, isFalse);
      });

      test('should load surahs when getSurahs is called', () async {
        // Arrange
        mockUseCase = MockGetSurahsUseCase(surahs: testSurahs);
        controller = HomeController(mockUseCase);

        // Act
        await controller.getSurahs();

        // Assert
        expect(controller.surahs, equals(testSurahs));
      });
    });

    group('Data Loading', () {
      test('should load surahs successfully', () async {
        // Arrange
        mockUseCase = MockGetSurahsUseCase(surahs: testSurahs);
        controller = HomeController(mockUseCase);

        // Act
        await controller.getSurahs();

        // Assert
        expect(controller.surahs, equals(testSurahs));
        expect(controller.isLoading, isFalse);
        expect(controller.errorMessage, isEmpty);
      });

      test('should set loading state while fetching data', () async {
        // Arrange
        mockUseCase = MockGetSurahsUseCase(surahs: testSurahs);
        controller = HomeController(mockUseCase);

        // Act
        final future = controller.getSurahs();

        // Assert - should be loading
        expect(controller.isLoading, isTrue);

        // Wait for completion
        await future;

        // Assert - should not be loading anymore
        expect(controller.isLoading, isFalse);
      });

      test('should handle error when loading fails', () async {
        // Arrange
        mockUseCase = MockGetSurahsUseCase(
          exception: Exception('Network error'),
        );
        controller = HomeController(mockUseCase);

        // Act
        await controller.getSurahs();

        // Assert
        expect(controller.surahs, isEmpty);
        expect(controller.isLoading, isFalse);
        expect(controller.errorMessage, equals('Exception: Network error'));
      });

      test('should clear error message on successful load', () async {
        // Arrange
        mockUseCase = MockGetSurahsUseCase(
          exception: Exception('Network error'),
        );
        controller = HomeController(mockUseCase);
        await controller.getSurahs(); // First call fails

        // Act
        mockUseCase = MockGetSurahsUseCase(surahs: testSurahs);
        controller = HomeController(mockUseCase);
        await controller.getSurahs(); // Second call succeeds

        // Assert
        expect(controller.errorMessage, isEmpty);
        expect(controller.surahs, equals(testSurahs));
      });

      test('should refresh surahs successfully', () async {
        // Arrange
        mockUseCase = MockGetSurahsUseCase(surahs: testSurahs);
        controller = HomeController(mockUseCase);

        // Act
        await controller.refreshSurahs();

        // Assert
        expect(controller.surahs, equals(testSurahs));
        expect(controller.isLoading, isFalse);
      });
    });

    group('Search Functionality', () {
      setUp(() async {
        mockUseCase = MockGetSurahsUseCase(surahs: testSurahs);
        controller = HomeController(mockUseCase);
        await controller.getSurahs();
      });

      test('should return all surahs when search keyword is empty', () {
        // Arrange
        controller.setSearchKeyword('');

        // Act
        final filteredSurahs = controller.filteredSurahs;

        // Assert
        expect(filteredSurahs, equals(testSurahs));
      });

      test('should filter surahs by namaLatin', () {
        // Arrange
        controller.setSearchKeyword('Al-Fatihah');

        // Act
        final filteredSurahs = controller.filteredSurahs;

        // Assert
        expect(filteredSurahs, hasLength(1));
        expect(filteredSurahs.first.namaLatin, equals('Al-Fatihah'));
      });

      test('should perform case-insensitive search', () {
        // Arrange
        controller.setSearchKeyword('al-fatihah');

        // Act
        final filteredSurahs = controller.filteredSurahs;

        // Assert
        expect(filteredSurahs, hasLength(1));
        expect(filteredSurahs.first.namaLatin, equals('Al-Fatihah'));
      });

      test('should return multiple matches for partial search', () {
        // Arrange
        controller.setSearchKeyword('Al');

        // Act
        final filteredSurahs = controller.filteredSurahs;

        // Assert - "Al" should match "Al-Fatihah", "Al-Baqarah", and "Ali Imran"
        expect(filteredSurahs, hasLength(3));
        expect(filteredSurahs.any((s) => s.namaLatin == 'Al-Fatihah'), isTrue);
        expect(filteredSurahs.any((s) => s.namaLatin == 'Al-Baqarah'), isTrue);
        expect(filteredSurahs.any((s) => s.namaLatin == 'Ali Imran'), isTrue);
      });
    });

    group('Search Bar Toggle', () {
      test('should toggle search bar visibility', () {
        // Arrange
        expect(controller.showSearchBar, isFalse);

        // Act
        controller.toggleSearchBar();

        // Assert
        expect(controller.showSearchBar, isTrue);

        // Act
        controller.toggleSearchBar();

        // Assert
        expect(controller.showSearchBar, isFalse);
      });

      test('should clear search keyword when hiding search bar', () {
        // Arrange
        controller.setSearchKeyword('test');
        controller.toggleSearchBar(); // Show search bar
        expect(
          controller.searchKeyword,
          isEmpty,
        ); // Cleared when showing search bar

        // Act
        controller.toggleSearchBar(); // Hide search bar

        // Assert
        expect(controller.searchKeyword, isEmpty);
      });

      test('should clear search keyword when showing search bar', () {
        // Arrange
        controller.setSearchKeyword('test');
        expect(controller.searchKeyword, equals('test'));

        // Act
        controller.toggleSearchBar(); // Show search bar

        // Assert
        expect(controller.searchKeyword, isEmpty);
      });
    });

    group('State Management', () {
      test('should update search keyword correctly', () {
        // Arrange
        const testKeyword = 'test search';

        // Act
        controller.setSearchKeyword(testKeyword);

        // Assert
        expect(controller.searchKeyword, equals(testKeyword));
      });

      test('should maintain state across multiple operations', () async {
        // Arrange
        mockUseCase = MockGetSurahsUseCase(surahs: testSurahs);
        controller = HomeController(mockUseCase);
        await controller.getSurahs();

        // Act
        controller.setSearchKeyword('Al');
        controller.toggleSearchBar();

        // Assert
        expect(controller.surahs, equals(testSurahs));
        expect(
          controller.searchKeyword,
          isEmpty,
        ); // Cleared when showing search bar
        expect(controller.showSearchBar, isTrue);
        expect(controller.isLoading, isFalse);
        expect(controller.errorMessage, isEmpty);
      });

      test('should handle multiple search operations', () {
        // Arrange
        controller.setSearchKeyword('Al');
        expect(controller.searchKeyword, equals('Al'));

        // Act
        controller.setSearchKeyword('Fatihah');

        // Assert
        expect(controller.searchKeyword, equals('Fatihah'));
      });
    });

    group('Error Handling', () {
      test('should handle network errors', () async {
        // Arrange
        mockUseCase = MockGetSurahsUseCase(
          exception: Exception('Network error'),
        );
        controller = HomeController(mockUseCase);

        // Act
        await controller.getSurahs();

        // Assert
        expect(controller.errorMessage, equals('Exception: Network error'));
        expect(controller.surahs, isEmpty);
        expect(controller.isLoading, isFalse);
      });

      test('should handle repository errors', () async {
        // Arrange
        mockUseCase = MockGetSurahsUseCase(
          exception: Exception('Repository error'),
        );
        controller = HomeController(mockUseCase);

        // Act
        await controller.getSurahs();

        // Assert
        expect(controller.errorMessage, equals('Exception: Repository error'));
        expect(controller.surahs, isEmpty);
        expect(controller.isLoading, isFalse);
      });

      test('should handle null data from repository', () async {
        // Arrange
        mockUseCase = MockGetSurahsUseCase(
          exception: Exception('Surahs not found'),
        );
        controller = HomeController(mockUseCase);

        // Act
        await controller.getSurahs();

        // Assert
        expect(controller.errorMessage, equals('Exception: Surahs not found'));
        expect(controller.surahs, isEmpty);
        expect(controller.isLoading, isFalse);
      });
    });
  });
}
