import 'package:flutter_test/flutter_test.dart';
import 'package:transcosmos_test/domain/entities/surah.dart';
import 'package:transcosmos_test/domain/repositories/home_repository.dart';
import 'package:transcosmos_test/domain/usecases/get_surahs_usecase.dart';

// Mock repository for testing
class MockSurahRepository implements HomeRepository {
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
}

void main() {
  group('GetSurahsUseCase', () {
    late GetSurahsUseCase useCase;

    test(
      'should return list of surahs when repository call is successful',
      () async {
        // Arrange
        final expectedSurahs = [
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

        final mockRepository = MockSurahRepository(surahs: expectedSurahs);
        useCase = GetSurahsUseCase(mockRepository);

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result, expectedSurahs);
        expect(result.length, 2);
        expect(result.first.namaLatin, 'Al-Fatihah');
        expect(result.last.namaLatin, 'Al-Baqarah');
      },
    );

    test(
      'should return empty list when repository returns empty list',
      () async {
        // Arrange
        final mockRepository = MockSurahRepository(surahs: []);
        useCase = GetSurahsUseCase(mockRepository);

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result, isEmpty);
        expect(result.length, 0);
      },
    );

    test('should throw exception when repository call fails', () async {
      // Arrange
      final mockRepository = MockSurahRepository(
        exception: Exception('Network error'),
      );
      useCase = GetSurahsUseCase(mockRepository);

      // Act & Assert
      expect(() => useCase.execute(), throwsException);
    });

    test(
      'should throw specific exception when repository throws specific exception',
      () async {
        // Arrange
        final mockRepository = MockSurahRepository(
          exception: FormatException('Invalid data format'),
        );
        useCase = GetSurahsUseCase(mockRepository);

        // Act & Assert
        expect(() => useCase.execute(), throwsA(isA<FormatException>()));
      },
    );

    test('should handle single surah correctly', () async {
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
      useCase = GetSurahsUseCase(mockRepository);

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result.length, 1);
      expect(result.first, expectedSurah);
      expect(result.first.nomor, 1);
      expect(result.first.namaLatin, 'Al-Fatihah');
    });
  });
}
