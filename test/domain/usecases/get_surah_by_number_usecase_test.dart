import 'package:flutter_test/flutter_test.dart';
import 'package:transcosmos_test/domain/entities/surah.dart';
import 'package:transcosmos_test/domain/repositories/surah_repository.dart';
import 'package:transcosmos_test/domain/usecases/get_surah_by_number_usecase.dart';

// Mock repository for testing
class MockSurahRepository implements SurahRepository {
  final List<Surah> _surahs;
  final Exception? _exception;

  MockSurahRepository({List<Surah>? surahs, Exception? exception})
    : _surahs = surahs ?? [],
      _exception = exception;

  @override
  Future<List<Surah>> getAllSurahs() async {
    if (_exception != null) throw _exception;
    return _surahs;
  }

  @override
  Future<Surah> getSurahByNumber(int nomor) async {
    if (_exception != null) throw _exception;
    try {
      return _surahs.firstWhere((s) => s.nomor == nomor);
    } catch (e) {
      throw Exception('Surah not found');
    }
  }
}

void main() {
  group('GetSurahByNumberUseCase', () {
    late GetSurahByNumberUseCase useCase;

    test('should return surah when repository call is successful', () async {
      // Arrange
      final expectedSurah = Surah(
        nomor: 1,
        nama: 'الفاتحة',
        namaLatin: 'Al-Fatihah',
        jumlahAyat: 7,
        tempatTurun: 'mekah',
        arti: 'Pembukaan',
        deskripsi: 'Deskripsi',
        audio: 'audio.mp3',
      );

      final mockRepository = MockSurahRepository(surahs: [expectedSurah]);
      useCase = GetSurahByNumberUseCase(mockRepository);

      // Act
      final result = await useCase.execute(1);

      // Assert
      expect(result, expectedSurah);
      expect(result.nomor, 1);
      expect(result.namaLatin, 'Al-Fatihah');
      expect(result.arti, 'Pembukaan');
    });

    test('should return correct surah for different numbers', () async {
      // Arrange
      final surahs = [
        Surah(
          nomor: 1,
          nama: 'الفاتحة',
          namaLatin: 'Al-Fatihah',
          jumlahAyat: 7,
          tempatTurun: 'mekah',
          arti: 'Pembukaan',
          deskripsi: 'Deskripsi',
          audio: 'audio.mp3',
        ),
        Surah(
          nomor: 2,
          nama: 'البقرة',
          namaLatin: 'Al-Baqarah',
          jumlahAyat: 286,
          tempatTurun: 'madinah',
          arti: 'Sapi',
          deskripsi: 'Deskripsi',
          audio: 'audio.mp3',
        ),
      ];

      final mockRepository = MockSurahRepository(surahs: surahs);
      useCase = GetSurahByNumberUseCase(mockRepository);

      // Act
      final result1 = await useCase.execute(1);
      final result2 = await useCase.execute(2);

      // Assert
      expect(result1.nomor, 1);
      expect(result1.namaLatin, 'Al-Fatihah');
      expect(result2.nomor, 2);
      expect(result2.namaLatin, 'Al-Baqarah');
    });

    test('should throw exception when surah not found', () async {
      // Arrange
      final mockRepository = MockSurahRepository(surahs: []);
      useCase = GetSurahByNumberUseCase(mockRepository);

      // Act & Assert
      expect(() => useCase.execute(999), throwsException);
    });

    test('should throw exception when repository call fails', () async {
      // Arrange
      final mockRepository = MockSurahRepository(
        exception: Exception('Network error'),
      );
      useCase = GetSurahByNumberUseCase(mockRepository);

      // Act & Assert
      expect(() => useCase.execute(1), throwsException);
    });

    test('should handle edge case surah number 1', () async {
      // Arrange
      final expectedSurah = Surah(
        nomor: 1,
        nama: 'الفاتحة',
        namaLatin: 'Al-Fatihah',
        jumlahAyat: 7,
        tempatTurun: 'mekah',
        arti: 'Pembukaan',
        deskripsi: 'Deskripsi',
        audio: 'audio.mp3',
      );

      final mockRepository = MockSurahRepository(surahs: [expectedSurah]);
      useCase = GetSurahByNumberUseCase(mockRepository);

      // Act
      final result = await useCase.execute(1);

      // Assert
      expect(result.nomor, 1);
      expect(result.nama, 'الفاتحة');
    });

    test('should handle edge case surah number 114', () async {
      // Arrange
      final expectedSurah = Surah(
        nomor: 114,
        nama: 'الناس',
        namaLatin: 'An-Nas',
        jumlahAyat: 6,
        tempatTurun: 'mekah',
        arti: 'Manusia',
        deskripsi: 'Deskripsi',
        audio: 'audio.mp3',
      );

      final mockRepository = MockSurahRepository(surahs: [expectedSurah]);
      useCase = GetSurahByNumberUseCase(mockRepository);

      // Act
      final result = await useCase.execute(114);

      // Assert
      expect(result.nomor, 114);
      expect(result.namaLatin, 'An-Nas');
    });
  });
}
