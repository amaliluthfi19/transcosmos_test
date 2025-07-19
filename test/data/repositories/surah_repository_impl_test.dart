import 'package:flutter_test/flutter_test.dart';
import 'package:transcosmos_test/data/models/surah_model.dart';
import 'package:transcosmos_test/data/repositories/surah_repository_impl.dart';
import 'package:transcosmos_test/data/rest_clients/surah_rest_client.dart';
import 'package:transcosmos_test/domain/entities/surah.dart';

// Mock rest client for testing
class MockSurahRestClient implements SurahRestClient {
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
    late SurahRepositoryImpl repository;
    late MockSurahRestClient mockRestClient;

    setUp(() {
      mockRestClient = MockSurahRestClient();
      repository = SurahRepositoryImpl(mockRestClient);
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
          repository = SurahRepositoryImpl(mockRestClient);

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
          repository = SurahRepositoryImpl(mockRestClient);

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
        repository = SurahRepositoryImpl(mockRestClient);

        // Act & Assert
        expect(() => repository.getAllSurahs(), throwsException);
      });
    });

    group('getSurahByNumber', () {
      test('should return surah when rest client call is successful', () async {
        // Arrange
        final surahModel = SurahModel(
          nomor: 1,
          nama: 'الفاتحة',
          namaLatin: 'Al-Fatihah',
          jumlahAyat: 7,
          tempatTurun: 'mekah',
          arti: 'Pembukaan',
          deskripsi: 'Deskripsi',
          audio: 'audio.mp3',
        );

        mockRestClient = MockSurahRestClient(surahs: [surahModel]);
        repository = SurahRepositoryImpl(mockRestClient);

        // Act
        final result = await repository.getSurahByNumber(1);

        // Assert
        expect(result, isA<Surah>());
        expect(result.nomor, 1);
        expect(result.namaLatin, 'Al-Fatihah');
        expect(result.arti, 'Pembukaan');
      });

      test('should throw exception when surah not found', () async {
        // Arrange
        mockRestClient = MockSurahRestClient(surahs: []);
        repository = SurahRepositoryImpl(mockRestClient);

        // Act & Assert
        expect(() => repository.getSurahByNumber(999), throwsException);
      });

      test('should throw exception when rest client call fails', () async {
        // Arrange
        mockRestClient = MockSurahRestClient(
          exception: Exception('Network error'),
        );
        repository = SurahRepositoryImpl(mockRestClient);

        // Act & Assert
        expect(() => repository.getSurahByNumber(1), throwsException);
      });

      test('should handle multiple surahs and return correct one', () async {
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
        repository = SurahRepositoryImpl(mockRestClient);

        // Act
        final result1 = await repository.getSurahByNumber(1);
        final result2 = await repository.getSurahByNumber(2);

        // Assert
        expect(result1.nomor, 1);
        expect(result1.namaLatin, 'Al-Fatihah');
        expect(result2.nomor, 2);
        expect(result2.namaLatin, 'Al-Baqarah');
      });
    });

    test('should convert SurahModel to Surah entity correctly', () async {
      // Arrange
      final surahModel = SurahModel(
        nomor: 3,
        nama: 'اٰل عمران',
        namaLatin: 'Ali \'Imran',
        jumlahAyat: 200,
        tempatTurun: 'madinah',
        arti: 'Keluarga Imran',
        deskripsi: 'Deskripsi',
        audio: 'audio.mp3',
      );

      mockRestClient = MockSurahRestClient(surahs: [surahModel]);
      repository = SurahRepositoryImpl(mockRestClient);

      // Act
      final result = await repository.getSurahByNumber(3);

      // Assert
      expect(result.nomor, surahModel.nomor);
      expect(result.nama, surahModel.nama);
      expect(result.namaLatin, surahModel.namaLatin);
      expect(result.jumlahAyat, surahModel.jumlahAyat);
      expect(result.tempatTurun, surahModel.tempatTurun);
      expect(result.arti, surahModel.arti);
      expect(result.deskripsi, surahModel.deskripsi);
      expect(result.audio, surahModel.audio);
    });
  });
}
