import 'package:flutter_test/flutter_test.dart';
import 'package:transcosmos_test/data/models/surah_detail_model.dart';
import 'package:transcosmos_test/data/models/ayat_model.dart';
import 'package:transcosmos_test/data/models/surah_model.dart';
import 'package:transcosmos_test/data/repositories/surah_detail_repository_impl.dart';
import 'package:transcosmos_test/data/rest_clients/surah_detail_rest_client.dart';
import 'package:transcosmos_test/domain/entities/surah_detail.dart';

// Mock rest client for testing
class MockSurahDetailRestClient implements SurahDetailRestClient {
  final SurahDetailModel? _surahDetail;
  final Exception? _exception;

  MockSurahDetailRestClient({
    SurahDetailModel? surahDetail,
    Exception? exception,
  }) : _surahDetail = surahDetail,
       _exception = exception;

  @override
  Future<SurahDetailModel> getSurahDetail(int nomor) async {
    if (_exception != null) throw _exception;
    if (_surahDetail == null) throw Exception('Surah detail not found');
    return _surahDetail;
  }
}

void main() {
  group('SurahDetailRepositoryImpl', () {
    late SurahDetailRepositoryImpl repository;
    late MockSurahDetailRestClient mockRestClient;
    late SurahDetailModel expectedSurahDetailModel;

    setUp(() {
      final ayats = [
        AyatModel(
          id: 1,
          surah: 1,
          nomor: 1,
          ar: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
          tr: 'Bismillāhir-raḥmānir-raḥīm',
          idn: 'Dengan nama Allah Yang Maha Pengasih lagi Maha Penyayang',
        ),
        AyatModel(
          id: 2,
          surah: 1,
          nomor: 2,
          ar: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
          tr: 'Al-ḥamdu lillāhi rabbil-ʿālamīn',
          idn: 'Segala puji bagi Allah, Tuhan semesta alam',
        ),
      ];

      final nextSurah = SurahModel(
        nomor: 2,
        nama: 'البقرة',
        namaLatin: 'Al-Baqarah',
        jumlahAyat: 286,
        tempatTurun: 'madinah',
        arti: 'Sapi',
        deskripsi: 'Deskripsi',
        audio: 'audio.mp3',
      );

      final prevSurah = SurahModel(
        nomor: 0,
        nama: '',
        namaLatin: '',
        jumlahAyat: 0,
        tempatTurun: '',
        arti: '',
        deskripsi: '',
        audio: '',
      );

      expectedSurahDetailModel = SurahDetailModel(
        status: true,
        nomor: 1,
        nama: 'الفاتحة',
        namaLatin: 'Al-Fatihah',
        jumlahAyat: 7,
        tempatTurun: 'mekah',
        arti: 'Pembukaan',
        deskripsi: 'Surah Al-Fatihah adalah surah pertama dalam Al-Quran',
        audio: 'https://example.com/audio.mp3',
        ayats: ayats,
        suratSelanjutnya: nextSurah,
        suratSebelumnya: prevSurah,
      );

      mockRestClient = MockSurahDetailRestClient();
      repository = SurahDetailRepositoryImpl(mockRestClient);
    });

    group('getSurahDetail', () {
      test(
        'should return surah detail when rest client call is successful',
        () async {
          // Arrange
          mockRestClient = MockSurahDetailRestClient(
            surahDetail: expectedSurahDetailModel,
          );
          repository = SurahDetailRepositoryImpl(mockRestClient);

          // Act
          final result = await repository.getSurahDetail(1);

          // Assert
          expect(result, isA<SurahDetail>());
          expect(result.nomor, 1);
          expect(result.namaLatin, 'Al-Fatihah');
          expect(result.ayats.length, 2);
          expect(result.suratSelanjutnya?.nomor, 2);
          expect(result.suratSebelumnya?.nomor, 0);
        },
      );

      test(
        'should return surah detail without next/previous surah when they are null',
        () async {
          // Arrange
          final surahDetailModelWithoutNavigation = SurahDetailModel(
            status: true,
            nomor: 1,
            nama: 'الفاتحة',
            namaLatin: 'Al-Fatihah',
            jumlahAyat: 7,
            tempatTurun: 'mekah',
            arti: 'Pembukaan',
            deskripsi: 'Deskripsi',
            audio: 'audio.mp3',
            ayats: expectedSurahDetailModel.ayats,
          );

          mockRestClient = MockSurahDetailRestClient(
            surahDetail: surahDetailModelWithoutNavigation,
          );
          repository = SurahDetailRepositoryImpl(mockRestClient);

          // Act
          final result = await repository.getSurahDetail(1);

          // Assert
          expect(result.suratSelanjutnya, isNull);
          expect(result.suratSebelumnya, isNull);
          expect(result.nomor, 1);
          expect(result.namaLatin, 'Al-Fatihah');
        },
      );

      test('should return surah detail with empty ayats list', () async {
        // Arrange
        final surahDetailModelWithEmptyAyats = SurahDetailModel(
          status: true,
          nomor: 1,
          nama: 'الفاتحة',
          namaLatin: 'Al-Fatihah',
          jumlahAyat: 7,
          tempatTurun: 'mekah',
          arti: 'Pembukaan',
          deskripsi: 'Deskripsi',
          audio: 'audio.mp3',
          ayats: [],
        );

        mockRestClient = MockSurahDetailRestClient(
          surahDetail: surahDetailModelWithEmptyAyats,
        );
        repository = SurahDetailRepositoryImpl(mockRestClient);

        // Act
        final result = await repository.getSurahDetail(1);

        // Assert
        expect(result.ayats, isEmpty);
        expect(result.ayats.length, 0);
      });

      test('should throw exception when rest client call fails', () async {
        // Arrange
        mockRestClient = MockSurahDetailRestClient(
          exception: Exception('Network error'),
        );
        repository = SurahDetailRepositoryImpl(mockRestClient);

        // Act & Assert
        expect(() => repository.getSurahDetail(1), throwsException);
      });

      test(
        'should throw specific exception when rest client throws specific exception',
        () async {
          // Arrange
          mockRestClient = MockSurahDetailRestClient(
            exception: FormatException('Invalid data format'),
          );
          repository = SurahDetailRepositoryImpl(mockRestClient);

          // Act & Assert
          expect(() => repository.getSurahDetail(1), throwsException);
        },
      );

      test('should throw exception when rest client returns null', () async {
        // Arrange
        mockRestClient = MockSurahDetailRestClient(surahDetail: null);
        repository = SurahDetailRepositoryImpl(mockRestClient);

        // Act & Assert
        expect(() => repository.getSurahDetail(1), throwsException);
      });

      test('should handle different surah numbers correctly', () async {
        // Arrange
        final surahDetailModel2 = SurahDetailModel(
          status: true,
          nomor: 2,
          nama: 'البقرة',
          namaLatin: 'Al-Baqarah',
          jumlahAyat: 286,
          tempatTurun: 'madinah',
          arti: 'Sapi',
          deskripsi: 'Deskripsi',
          audio: 'audio.mp3',
          ayats: expectedSurahDetailModel.ayats,
        );

        mockRestClient = MockSurahDetailRestClient(
          surahDetail: surahDetailModel2,
        );
        repository = SurahDetailRepositoryImpl(mockRestClient);

        // Act
        final result = await repository.getSurahDetail(2);

        // Assert
        expect(result.nomor, 2);
        expect(result.namaLatin, 'Al-Baqarah');
        expect(result.jumlahAyat, 286);
        expect(result.tempatTurun, 'madinah');
      });

      test('should handle zero surah number', () async {
        // Arrange
        final surahDetailModel0 = SurahDetailModel(
          status: true,
          nomor: 0,
          nama: '',
          namaLatin: '',
          jumlahAyat: 0,
          tempatTurun: '',
          arti: '',
          deskripsi: '',
          audio: '',
          ayats: [],
        );

        mockRestClient = MockSurahDetailRestClient(
          surahDetail: surahDetailModel0,
        );
        repository = SurahDetailRepositoryImpl(mockRestClient);

        // Act
        final result = await repository.getSurahDetail(0);

        // Assert
        expect(result.nomor, 0);
        expect(result.namaLatin, '');
        expect(result.jumlahAyat, 0);
      });

      test('should handle large surah number', () async {
        // Arrange
        final surahDetailModel114 = SurahDetailModel(
          status: true,
          nomor: 114,
          nama: 'الناس',
          namaLatin: 'An-Nas',
          jumlahAyat: 6,
          tempatTurun: 'mekah',
          arti: 'Manusia',
          deskripsi: 'Deskripsi',
          audio: 'audio.mp3',
          ayats: expectedSurahDetailModel.ayats,
        );

        mockRestClient = MockSurahDetailRestClient(
          surahDetail: surahDetailModel114,
        );
        repository = SurahDetailRepositoryImpl(mockRestClient);

        // Act
        final result = await repository.getSurahDetail(114);

        // Assert
        expect(result.nomor, 114);
        expect(result.namaLatin, 'An-Nas');
        expect(result.jumlahAyat, 6);
      });

      test('should handle connection timeout exception', () async {
        // Arrange
        mockRestClient = MockSurahDetailRestClient(
          exception: Exception('Connection timeout'),
        );
        repository = SurahDetailRepositoryImpl(mockRestClient);

        // Act & Assert
        expect(() => repository.getSurahDetail(1), throwsException);
      });

      test('should handle server error exception', () async {
        // Arrange
        mockRestClient = MockSurahDetailRestClient(
          exception: Exception('Server error: 500'),
        );
        repository = SurahDetailRepositoryImpl(mockRestClient);

        // Act & Assert
        expect(() => repository.getSurahDetail(1), throwsException);
      });

      test('should handle not found exception', () async {
        // Arrange
        mockRestClient = MockSurahDetailRestClient(
          exception: Exception('Surah not found'),
        );
        repository = SurahDetailRepositoryImpl(mockRestClient);

        // Act & Assert
        expect(() => repository.getSurahDetail(1), throwsException);
      });
    });
  });
}
