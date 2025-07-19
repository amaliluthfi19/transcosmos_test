import 'package:flutter_test/flutter_test.dart';
import 'package:transcosmos_test/domain/entities/surah.dart';

void main() {
  group('Surah Entity', () {
    late Surah surah;

    setUp(() {
      surah = Surah(
        nomor: 1,
        nama: 'الفاتحة',
        namaLatin: 'Al-Fatihah',
        jumlahAyat: 7,
        tempatTurun: 'mekah',
        arti: 'Pembukaan',
        deskripsi: 'Surat Al Faatihah (Pembukaan) yang diturunk…',
        audio: 'https://santrikoding.com/storage/audio/001.mp3',
      );
    });

    test('should create Surah with correct properties', () {
      expect(surah.nomor, 1);
      expect(surah.nama, 'الفاتحة');
      expect(surah.namaLatin, 'Al-Fatihah');
      expect(surah.jumlahAyat, 7);
      expect(surah.tempatTurun, 'mekah');
      expect(surah.arti, 'Pembukaan');
      expect(surah.deskripsi, 'Surat Al Faatihah (Pembukaan) yang diturunk…');
      expect(surah.audio, 'https://santrikoding.com/storage/audio/001.mp3');
    });

    test('should return correct equality', () {
      final surah1 = Surah(
        nomor: 1,
        nama: 'الفاتحة',
        namaLatin: 'Al-Fatihah',
        jumlahAyat: 7,
        tempatTurun: 'mekah',
        arti: 'Pembukaan',
        deskripsi: 'Deskripsi',
        audio: 'audio.mp3',
      );

      final surah2 = Surah(
        nomor: 1,
        nama: 'الفاتحة',
        namaLatin: 'Al-Fatihah',
        jumlahAyat: 7,
        tempatTurun: 'mekah',
        arti: 'Pembukaan',
        deskripsi: 'Deskripsi',
        audio: 'audio.mp3',
      );

      expect(surah1, equals(surah2));
    });

    test('should return different hash codes for different surahs', () {
      final surah1 = Surah(
        nomor: 1,
        nama: 'الفاتحة',
        namaLatin: 'Al-Fatihah',
        jumlahAyat: 7,
        tempatTurun: 'mekah',
        arti: 'Pembukaan',
        deskripsi: 'Deskripsi',
        audio: 'audio.mp3',
      );

      final surah2 = Surah(
        nomor: 2,
        nama: 'البقرة',
        namaLatin: 'Al-Baqarah',
        jumlahAyat: 286,
        tempatTurun: 'madinah',
        arti: 'Sapi',
        deskripsi: 'Deskripsi',
        audio: 'audio.mp3',
      );

      expect(surah1.hashCode, isNot(equals(surah2.hashCode)));
    });

    test('should return correct toString', () {
      final expectedString =
          'Surah{nomor: 1, nama: الفاتحة, namaLatin: Al-Fatihah, jumlahAyat: 7, tempatTurun: mekah, arti: Pembukaan, audio: https://santrikoding.com/storage/audio/001.mp3}';
      expect(surah.toString(), expectedString);
    });
  });
}
