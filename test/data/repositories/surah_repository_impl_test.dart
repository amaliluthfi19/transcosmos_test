import 'package:flutter_test/flutter_test.dart';
import 'package:transcosmos_test/data/models/surah_model.dart';
import 'package:transcosmos_test/data/repositories/home_repository_impl.dart';
import 'package:transcosmos_test/data/rest_clients/home_rest_client.dart';
import 'package:transcosmos_test/domain/entities/surah.dart';

// Mock rest client for testing
class MockSurahRestClient implements HomeRestClient {
  final List<SurahModel> _surahs;
  final Exception? _exception;

  MockSurahRestClient({List<SurahModel>? surahs, Exception? exception})
    : _surahs = surahs ?? [],
      _exception = exception;

  @override
  Future<List<SurahModel>> getAllSurahs() async {
    if (_exception != null) throw _exception;
    return _surahs;
  }

  @override
  Future<SurahModel> getSurahByNumber(int nomor) async {
    if (_exception != null) throw _exception;
    try {
      return _surahs.firstWhere((s) => s.nomor == nomor);
    } catch (e) {
      throw Exception('Surah not found');
    }
  }
}

void main() {
  group('SurahRepositoryImpl', () {
    late HomeRepositoryImpl repository;
    late MockSurahRestClient mockRestClient;

    setUp(() {
      mockRestClient = MockSurahRestClient();
      repository = HomeRepositoryImpl(mockRestClient);
    });

    group('getAllSurahs', () {
      test(
        'should return list of surahs when rest client call is successful',
        () async {
          // Arrange
          final surahModels = [
            SurahModel(
              nomor: 1,
              nama: 'الفاتحة',
              namaLatin: 'Al-Fatihah',
              jumlahAyat: 7,
              tempatTurun: 'mekah',
              arti: 'Pembukaan',
              deskripsi: 'Deskripsi',
              audio: 'audio.mp3',
            ),
            SurahModel(
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

          mockRestClient = MockSurahRestClient(surahs: surahModels);
          repository = HomeRepositoryImpl(mockRestClient);

          // Act
          final result = await repository.getAllSurahs();

          // Assert
          expect(result, isA<List<Surah>>());
          expect(result.length, 2);
          expect(result.first.nomor, 1);
          expect(result.first.namaLatin, 'Al-Fatihah');
          expect(result.last.nomor, 2);
          expect(result.last.namaLatin, 'Al-Baqarah');
        },
      );

      test(
        'should return empty list when rest client returns empty list',
        () async {
          // Arrange
          mockRestClient = MockSurahRestClient(surahs: []);
          repository = HomeRepositoryImpl(mockRestClient);

          // Act
          final result = await repository.getAllSurahs();

          // Assert
          expect(result, isEmpty);
          expect(result.length, 0);
        },
      );

      test('should throw exception when rest client call fails', () async {
        // Arrange
        mockRestClient = MockSurahRestClient(
          exception: Exception('Network error'),
        );
        repository = HomeRepositoryImpl(mockRestClient);

        // Act & Assert
        expect(() => repository.getAllSurahs(), throwsException);
      });
    });
  });
}
