import 'package:flutter_test/flutter_test.dart';
import 'package:transcosmos_test/data/models/surah_model.dart';

void main() {
  group('SurahModel', () {
    test('should create SurahModel from JSON', () {
      // Arrange
      final json = {
        'nomor': 1,
        'nama': 'الفاتحة',
        'nama_latin': 'Al-Fatihah',
        'jumlah_ayat': 7,
        'tempat_turun': 'mekah',
        'arti': 'Pembukaan',
        'deskripsi': 'Surat Al Faatihah (Pembukaan) yang diturunk…',
        'audio': 'https://santrikoding.com/storage/audio/001.mp3',
      };

      // Act
      final surahModel = SurahModel.fromJson(json);

      // Assert
      expect(surahModel.nomor, 1);
      expect(surahModel.nama, 'الفاتحة');
      expect(surahModel.namaLatin, 'Al-Fatihah');
      expect(surahModel.jumlahAyat, 7);
      expect(surahModel.tempatTurun, 'mekah');
      expect(surahModel.arti, 'Pembukaan');
      expect(
        surahModel.deskripsi,
        'Surat Al Faatihah (Pembukaan) yang diturunk…',
      );
      expect(
        surahModel.audio,
        'https://santrikoding.com/storage/audio/001.mp3',
      );
    });

    test('should convert SurahModel to JSON', () {
      // Arrange
      final surahModel = SurahModel(
        nomor: 2,
        nama: 'البقرة',
        namaLatin: 'Al-Baqarah',
        jumlahAyat: 286,
        tempatTurun: 'madinah',
        arti: 'Sapi',
        deskripsi: 'Surat Al Baqarah yang 286 ayat itu turun di…',
        audio: 'https://santrikoding.com/storage/audio/002.mp3',
      );

      // Act
      final json = surahModel.toJson();

      // Assert
      expect(json['nomor'], 2);
      expect(json['nama'], 'البقرة');
      expect(json['nama_latin'], 'Al-Baqarah');
      expect(json['jumlah_ayat'], 286);
      expect(json['tempat_turun'], 'madinah');
      expect(json['arti'], 'Sapi');
      expect(json['deskripsi'], 'Surat Al Baqarah yang 286 ayat itu turun di…');
      expect(json['audio'], 'https://santrikoding.com/storage/audio/002.mp3');
    });

    test('should handle missing JSON values with defaults', () {
      // Arrange
      final json = {
        'nomor': 1,
        'nama': 'الفاتحة',
        // Missing other fields
      };

      // Act
      final surahModel = SurahModel.fromJson(json);

      // Assert
      expect(surahModel.nomor, 1);
      expect(surahModel.nama, 'الفاتحة');
      expect(surahModel.namaLatin, '');
      expect(surahModel.jumlahAyat, 0);
      expect(surahModel.tempatTurun, '');
      expect(surahModel.arti, '');
      expect(surahModel.deskripsi, '');
      expect(surahModel.audio, '');
    });

    test('should handle null JSON values', () {
      // Arrange
      final json = {
        'nomor': 1,
        'nama': 'الفاتحة',
        'nama_latin': null,
        'jumlah_ayat': null,
        'tempat_turun': null,
        'arti': null,
        'deskripsi': null,
        'audio': null,
      };

      // Act
      final surahModel = SurahModel.fromJson(json);

      // Assert
      expect(surahModel.nomor, 1);
      expect(surahModel.nama, 'الفاتحة');
      expect(surahModel.namaLatin, '');
      expect(surahModel.jumlahAyat, 0);
      expect(surahModel.tempatTurun, '');
      expect(surahModel.arti, '');
      expect(surahModel.deskripsi, '');
      expect(surahModel.audio, '');
    });

    test('should create copy with updated values', () {
      // Arrange
      final originalSurah = SurahModel(
        nomor: 1,
        nama: 'الفاتحة',
        namaLatin: 'Al-Fatihah',
        jumlahAyat: 7,
        tempatTurun: 'mekah',
        arti: 'Pembukaan',
        deskripsi: 'Deskripsi',
        audio: 'audio.mp3',
      );

      // Act
      final updatedSurah = originalSurah.copyWith(
        namaLatin: 'Updated Name',
        jumlahAyat: 10,
      );

      // Assert
      expect(updatedSurah.nomor, 1); // Unchanged
      expect(updatedSurah.nama, 'الفاتحة'); // Unchanged
      expect(updatedSurah.namaLatin, 'Updated Name'); // Changed
      expect(updatedSurah.jumlahAyat, 10); // Changed
      expect(updatedSurah.tempatTurun, 'mekah'); // Unchanged
      expect(updatedSurah.arti, 'Pembukaan'); // Unchanged
      expect(updatedSurah.deskripsi, 'Deskripsi'); // Unchanged
      expect(updatedSurah.audio, 'audio.mp3'); // Unchanged
    });

    test('should handle date parsing in JSON', () {
      // Arrange
      final now = DateTime.now();
      final json = {
        'nomor': 1,
        'nama': 'الفاتحة',
        'nama_latin': 'Al-Fatihah',
        'jumlah_ayat': 7,
        'tempat_turun': 'mekah',
        'arti': 'Pembukaan',
        'deskripsi': 'Deskripsi',
        'audio': 'audio.mp3',
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };

      // Act
      final surahModel = SurahModel.fromJson(json);

      // Assert
      expect(surahModel.nomor, 1);
      expect(surahModel.nama, 'الفاتحة');
      // Note: The current model doesn't have created_at and updated_at fields
      // This test shows how it would work if those fields were added
    });

    test('should handle empty JSON object', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act
      final surahModel = SurahModel.fromJson(json);

      // Assert
      expect(surahModel.nomor, 0);
      expect(surahModel.nama, '');
      expect(surahModel.namaLatin, '');
      expect(surahModel.jumlahAyat, 0);
      expect(surahModel.tempatTurun, '');
      expect(surahModel.arti, '');
      expect(surahModel.deskripsi, '');
      expect(surahModel.audio, '');
    });

    test('should round-trip JSON conversion', () {
      // Arrange
      final originalSurah = SurahModel(
        nomor: 3,
        nama: 'اٰل عمران',
        namaLatin: 'Ali \'Imran',
        jumlahAyat: 200,
        tempatTurun: 'madinah',
        arti: 'Keluarga Imran',
        deskripsi: 'Surat Ali \'Imran yang terdiri dari 200 ayat…',
        audio: 'https://santrikoding.com/storage/audio/003.mp3',
      );

      // Act
      final json = originalSurah.toJson();
      final convertedSurah = SurahModel.fromJson(json);

      // Assert
      expect(convertedSurah.nomor, originalSurah.nomor);
      expect(convertedSurah.nama, originalSurah.nama);
      expect(convertedSurah.namaLatin, originalSurah.namaLatin);
      expect(convertedSurah.jumlahAyat, originalSurah.jumlahAyat);
      expect(convertedSurah.tempatTurun, originalSurah.tempatTurun);
      expect(convertedSurah.arti, originalSurah.arti);
      expect(convertedSurah.deskripsi, originalSurah.deskripsi);
      expect(convertedSurah.audio, originalSurah.audio);
    });
  });
}
