import 'package:flutter_test/flutter_test.dart';
import 'package:transcosmos_test/domain/entities/surah_detail.dart';
import 'package:transcosmos_test/domain/entities/surah.dart';
import 'package:transcosmos_test/domain/entities/ayat.dart';
import 'package:transcosmos_test/domain/repositories/surah_detail_repository.dart';
import 'package:transcosmos_test/domain/usecases/get_surah_detail_usecase.dart';

// Mock repository for testing
class MockSurahDetailRepository implements SurahDetailRepository {
  final SurahDetail? _surahDetail;
  final Exception? _exception;

  MockSurahDetailRepository({SurahDetail? surahDetail, Exception? exception})
    : _surahDetail = surahDetail,
      _exception = exception;

  @override
  Future<SurahDetail> getSurahDetail(int nomor) async {
    if (_exception != null) throw _exception;
    if (_surahDetail == null) throw Exception('Surah detail not found');
    return _surahDetail;
  }
}

// Mock use case for testing
class MockGetSurahDetailUseCase implements GetSurahDetailUseCase {
  final SurahDetail? _surahDetail;
  final Exception? _exception;

  MockGetSurahDetailUseCase({SurahDetail? surahDetail, Exception? exception})
    : _surahDetail = surahDetail,
      _exception = exception;

  @override
  SurahDetailRepository get repository => throw UnimplementedError();

  @override
  Future<SurahDetail> execute(int nomor) async {
    if (_exception != null) throw _exception;
    if (_surahDetail == null) throw Exception('Surah detail not found');
    return _surahDetail;
  }
}

void main() {
  group('GetSurahDetailUseCase', () {
    late GetSurahDetailUseCase useCase;
    late SurahDetail expectedSurahDetail;

    setUp(() {
      final ayats = [
        Ayat(
          id: 1,
          surah: 1,
          nomor: 1,
          ar: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
          tr: 'Bismillāhir-raḥmānir-raḥīm',
          idn: 'Dengan nama Allah Yang Maha Pengasih lagi Maha Penyayang',
        ),
        Ayat(
          id: 2,
          surah: 1,
          nomor: 2,
          ar: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
          tr: 'Al-ḥamdu lillāhi rabbil-ʿālamīn',
          idn: 'Segala puji bagi Allah, Tuhan semesta alam',
        ),
      ];

      final nextSurah = Surah(
        nomor: 2,
        nama: 'البقرة',
        namaLatin: 'Al-Baqarah',
        jumlahAyat: 286,
        tempatTurun: 'madinah',
        arti: 'Sapi',
        deskripsi: 'Deskripsi',
        audio: 'audio.mp3',
      );

      final prevSurah = Surah(
        nomor: 0,
        nama: '',
        namaLatin: '',
        jumlahAyat: 0,
        tempatTurun: '',
        arti: '',
        deskripsi: '',
        audio: '',
      );

      expectedSurahDetail = SurahDetail(
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
    });

    test(
      'should return surah detail when repository call is successful',
      () async {
        // Arrange
        final mockRepository = MockSurahDetailRepository(
          surahDetail: expectedSurahDetail,
        );
        useCase = GetSurahDetailUseCase(mockRepository);

        // Act
        final result = await useCase.execute(1);

        // Assert
        expect(result, expectedSurahDetail);
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
        final surahDetailWithoutNavigation = SurahDetail(
          status: true,
          nomor: 1,
          nama: 'الفاتحة',
          namaLatin: 'Al-Fatihah',
          jumlahAyat: 7,
          tempatTurun: 'mekah',
          arti: 'Pembukaan',
          deskripsi: 'Deskripsi',
          audio: 'audio.mp3',
          ayats: expectedSurahDetail.ayats,
        );

        final mockRepository = MockSurahDetailRepository(
          surahDetail: surahDetailWithoutNavigation,
        );
        useCase = GetSurahDetailUseCase(mockRepository);

        // Act
        final result = await useCase.execute(1);

        // Assert
        expect(result.suratSelanjutnya, isNull);
        expect(result.suratSebelumnya, isNull);
        expect(result.nomor, 1);
        expect(result.namaLatin, 'Al-Fatihah');
      },
    );

    test('should return surah detail with empty ayats list', () async {
      // Arrange
      final surahDetailWithEmptyAyats = SurahDetail(
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

      final mockRepository = MockSurahDetailRepository(
        surahDetail: surahDetailWithEmptyAyats,
      );
      useCase = GetSurahDetailUseCase(mockRepository);

      // Act
      final result = await useCase.execute(1);

      // Assert
      expect(result.ayats, isEmpty);
      expect(result.ayats.length, 0);
    });

    test('should throw exception when repository call fails', () async {
      // Arrange
      final mockRepository = MockSurahDetailRepository(
        exception: Exception('Network error'),
      );
      useCase = GetSurahDetailUseCase(mockRepository);

      // Act & Assert
      expect(() => useCase.execute(1), throwsException);
    });

    test(
      'should throw specific exception when repository throws specific exception',
      () async {
        // Arrange
        final mockRepository = MockSurahDetailRepository(
          exception: FormatException('Invalid data format'),
        );
        useCase = GetSurahDetailUseCase(mockRepository);

        // Act & Assert
        expect(() => useCase.execute(1), throwsA(isA<FormatException>()));
      },
    );

    test('should throw exception when repository returns null', () async {
      // Arrange
      final mockRepository = MockSurahDetailRepository(surahDetail: null);
      useCase = GetSurahDetailUseCase(mockRepository);

      // Act & Assert
      expect(() => useCase.execute(1), throwsException);
    });

    test('should handle different surah numbers correctly', () async {
      // Arrange
      final surahDetail2 = SurahDetail(
        status: true,
        nomor: 2,
        nama: 'البقرة',
        namaLatin: 'Al-Baqarah',
        jumlahAyat: 286,
        tempatTurun: 'madinah',
        arti: 'Sapi',
        deskripsi: 'Deskripsi',
        audio: 'audio.mp3',
        ayats: expectedSurahDetail.ayats,
      );

      final mockRepository = MockSurahDetailRepository(
        surahDetail: surahDetail2,
      );
      useCase = GetSurahDetailUseCase(mockRepository);

      // Act
      final result = await useCase.execute(2);

      // Assert
      expect(result.nomor, 2);
      expect(result.namaLatin, 'Al-Baqarah');
      expect(result.jumlahAyat, 286);
      expect(result.tempatTurun, 'madinah');
    });

    test('should handle zero surah number', () async {
      // Arrange
      final surahDetail0 = SurahDetail(
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

      final mockRepository = MockSurahDetailRepository(
        surahDetail: surahDetail0,
      );
      useCase = GetSurahDetailUseCase(mockRepository);

      // Act
      final result = await useCase.execute(0);

      // Assert
      expect(result.nomor, 0);
      expect(result.namaLatin, '');
      expect(result.jumlahAyat, 0);
    });

    test('should handle large surah number', () async {
      // Arrange
      final surahDetail114 = SurahDetail(
        status: true,
        nomor: 114,
        nama: 'الناس',
        namaLatin: 'An-Nas',
        jumlahAyat: 6,
        tempatTurun: 'mekah',
        arti: 'Manusia',
        deskripsi: 'Deskripsi',
        audio: 'audio.mp3',
        ayats: expectedSurahDetail.ayats,
      );

      final mockRepository = MockSurahDetailRepository(
        surahDetail: surahDetail114,
      );
      useCase = GetSurahDetailUseCase(mockRepository);

      // Act
      final result = await useCase.execute(114);

      // Assert
      expect(result.nomor, 114);
      expect(result.namaLatin, 'An-Nas');
      expect(result.jumlahAyat, 6);
    });
  });
}
