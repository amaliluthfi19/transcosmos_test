import 'package:flutter_test/flutter_test.dart';
import 'package:transcosmos_test/domain/entities/surah_detail.dart';
import 'package:transcosmos_test/domain/entities/surah.dart';
import 'package:transcosmos_test/domain/entities/ayat.dart';

void main() {
  group('SurahDetail', () {
    late SurahDetail surahDetail;
    late List<Ayat> ayats;
    late Surah nextSurah;
    late Surah prevSurah;

    setUp(() {
      ayats = [
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

      nextSurah = Surah(
        nomor: 2,
        nama: 'البقرة',
        namaLatin: 'Al-Baqarah',
        jumlahAyat: 286,
        tempatTurun: 'madinah',
        arti: 'Sapi',
        deskripsi: 'Deskripsi',
        audio: 'audio.mp3',
      );

      prevSurah = Surah(
        nomor: 0,
        nama: '',
        namaLatin: '',
        jumlahAyat: 0,
        tempatTurun: '',
        arti: '',
        deskripsi: '',
        audio: '',
      );

      surahDetail = SurahDetail(
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

    test('should create SurahDetail with all required properties', () {
      // Assert
      expect(surahDetail.status, true);
      expect(surahDetail.nomor, 1);
      expect(surahDetail.nama, 'الفاتحة');
      expect(surahDetail.namaLatin, 'Al-Fatihah');
      expect(surahDetail.jumlahAyat, 7);
      expect(surahDetail.tempatTurun, 'mekah');
      expect(surahDetail.arti, 'Pembukaan');
      expect(
        surahDetail.deskripsi,
        'Surah Al-Fatihah adalah surah pertama dalam Al-Quran',
      );
      expect(surahDetail.audio, 'https://example.com/audio.mp3');
      expect(surahDetail.ayats, ayats);
      expect(surahDetail.suratSelanjutnya, nextSurah);
      expect(surahDetail.suratSebelumnya, prevSurah);
    });

    test('should create SurahDetail without optional properties', () {
      // Arrange
      final surahDetailWithoutOptional = SurahDetail(
        status: true,
        nomor: 1,
        nama: 'الفاتحة',
        namaLatin: 'Al-Fatihah',
        jumlahAyat: 7,
        tempatTurun: 'mekah',
        arti: 'Pembukaan',
        deskripsi: 'Deskripsi',
        audio: 'audio.mp3',
        ayats: ayats,
      );

      // Assert
      expect(surahDetailWithoutOptional.suratSelanjutnya, isNull);
      expect(surahDetailWithoutOptional.suratSebelumnya, isNull);
    });

    test('should return true when comparing identical SurahDetail objects', () {
      // Arrange
      final surahDetail2 = SurahDetail(
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

      // Assert
      expect(surahDetail, equals(surahDetail2));
      expect(surahDetail == surahDetail2, isTrue);
    });

    test(
      'should return false when comparing different SurahDetail objects',
      () {
        // Arrange
        final differentSurahDetail = SurahDetail(
          status: true,
          nomor: 2,
          nama: 'البقرة',
          namaLatin: 'Al-Baqarah',
          jumlahAyat: 286,
          tempatTurun: 'madinah',
          arti: 'Sapi',
          deskripsi: 'Deskripsi',
          audio: 'audio.mp3',
          ayats: ayats,
          suratSelanjutnya: nextSurah,
          suratSebelumnya: prevSurah,
        );

        // Assert
        expect(surahDetail, isNot(equals(differentSurahDetail)));
        expect(surahDetail == differentSurahDetail, isFalse);
      },
    );

    test('should generate consistent hashCode for identical objects', () {
      // Arrange
      final surahDetail2 = SurahDetail(
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

      // Assert
      expect(surahDetail.hashCode, equals(surahDetail2.hashCode));
    });

    test('should generate different hashCode for different objects', () {
      // Arrange
      final differentSurahDetail = SurahDetail(
        status: true,
        nomor: 2,
        nama: 'البقرة',
        namaLatin: 'Al-Baqarah',
        jumlahAyat: 286,
        tempatTurun: 'madinah',
        arti: 'Sapi',
        deskripsi: 'Deskripsi',
        audio: 'audio.mp3',
        ayats: ayats,
        suratSelanjutnya: nextSurah,
        suratSebelumnya: prevSurah,
      );

      // Assert
      expect(
        surahDetail.hashCode,
        isNot(equals(differentSurahDetail.hashCode)),
      );
    });

    test('should return correct string representation', () {
      // Act
      final result = surahDetail.toString();

      // Assert
      expect(
        result,
        contains(
          'SurahDetail{nomor: 1, nama: الفاتحة, namaLatin: Al-Fatihah, jumlahAyat: 7, ayats: 2}',
        ),
      );
    });

    test('should handle empty ayats list correctly', () {
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

      // Assert
      expect(surahDetailWithEmptyAyats.ayats, isEmpty);
      expect(surahDetailWithEmptyAyats.toString(), contains('ayats: 0'));
    });

    test(
      'should handle null suratSelanjutnya and suratSebelumnya in equality',
      () {
        // Arrange
        final surahDetailWithNulls = SurahDetail(
          status: true,
          nomor: 1,
          nama: 'الفاتحة',
          namaLatin: 'Al-Fatihah',
          jumlahAyat: 7,
          tempatTurun: 'mekah',
          arti: 'Pembukaan',
          deskripsi: 'Deskripsi',
          audio: 'audio.mp3',
          ayats: ayats,
        );

        final surahDetailWithNulls2 = SurahDetail(
          status: true,
          nomor: 1,
          nama: 'الفاتحة',
          namaLatin: 'Al-Fatihah',
          jumlahAyat: 7,
          tempatTurun: 'mekah',
          arti: 'Pembukaan',
          deskripsi: 'Deskripsi',
          audio: 'audio.mp3',
          ayats: ayats,
        );

        // Assert
        expect(surahDetailWithNulls, equals(surahDetailWithNulls2));
      },
    );
  });
}
