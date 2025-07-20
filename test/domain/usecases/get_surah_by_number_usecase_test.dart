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
    late MockSurahRepository mockRepository;

    setUp(() {
      mockRepository = MockSurahRepository();
      useCase = GetSurahsUseCase(mockRepository);
    });

    group('execute', () {
      test(
        'should return list of surahs when repository call is successful',
        () async {
          // Arrange
          final testSurahs = [
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
          mockRepository = MockSurahRepository(surahs: testSurahs);
          useCase = GetSurahsUseCase(mockRepository);

          // Act
          final result = await useCase.execute();

          // Assert
          expect(result, equals(testSurahs));
          expect(result.length, equals(2));
          expect(result.first.namaLatin, equals('Al-Fatihah'));
          expect(result.last.namaLatin, equals('Al-Baqarah'));
        },
      );

      test(
        'should return empty list when repository returns empty list',
        () async {
          // Arrange
          mockRepository = MockSurahRepository(surahs: []);
          useCase = GetSurahsUseCase(mockRepository);

          // Act
          final result = await useCase.execute();

          // Assert
          expect(result, isEmpty);
        },
      );

      test('should throw exception when repository throws exception', () async {
        // Arrange
        final exception = Exception('Network error');
        mockRepository = MockSurahRepository(exception: exception);
        useCase = GetSurahsUseCase(mockRepository);

        // Act & Assert
        expect(() => useCase.execute(), throwsA(equals(exception)));
      });

      test(
        'should throw specific exception when repository throws specific exception',
        () async {
          // Arrange
          final exception = FormatException('Invalid data format');
          mockRepository = MockSurahRepository(exception: exception);
          useCase = GetSurahsUseCase(mockRepository);

          // Act & Assert
          expect(() => useCase.execute(), throwsA(equals(exception)));
        },
      );
    });
  });
}
