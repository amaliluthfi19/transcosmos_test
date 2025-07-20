import 'package:flutter_test/flutter_test.dart';
import 'package:transcosmos_test/data/models/surah_detail_model.dart';
import 'package:transcosmos_test/data/models/ayat_model.dart';
import 'package:transcosmos_test/data/models/surah_model.dart';

void main() {
  group('SurahDetailModel', () {
    late SurahDetailModel surahDetailModel;
    late List<AyatModel> ayats;
    late SurahModel nextSurah;
    late SurahModel prevSurah;

    setUp(() {
      ayats = [
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

      nextSurah = SurahModel(
        nomor: 2,
        nama: 'البقرة',
        namaLatin: 'Al-Baqarah',
        jumlahAyat: 286,
        tempatTurun: 'madinah',
        arti: 'Sapi',
        deskripsi: 'Deskripsi',
        audio: 'audio.mp3',
      );

      prevSurah = SurahModel(
        nomor: 0,
        nama: '',
        namaLatin: '',
        jumlahAyat: 0,
        tempatTurun: '',
        arti: '',
        deskripsi: '',
        audio: '',
      );

      surahDetailModel = SurahDetailModel(
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

    group('fromJson', () {
      test('should create SurahDetailModel from valid JSON', () {
        // Arrange
        final json = {
          'status': true,
          'nomor': 1,
          'nama': 'الفاتحة',
          'nama_latin': 'Al-Fatihah',
          'jumlah_ayat': 7,
          'tempat_turun': 'mekah',
          'arti': 'Pembukaan',
          'deskripsi': 'Surah Al-Fatihah adalah surah pertama dalam Al-Quran',
          'audio': 'https://example.com/audio.mp3',
          'ayat': [
            {
              'id': 1,
              'surah': 1,
              'nomor': 1,
              'ar': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
              'tr': 'Bismillāhir-raḥmānir-raḥīm',
              'idn': 'Dengan nama Allah Yang Maha Pengasih lagi Maha Penyayang',
            },
            {
              'id': 2,
              'surah': 1,
              'nomor': 2,
              'ar': 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
              'tr': 'Al-ḥamdu lillāhi rabbil-ʿālamīn',
              'idn': 'Segala puji bagi Allah, Tuhan semesta alam',
            },
          ],
          'surat_selanjutnya': {
            'nomor': 2,
            'nama': 'البقرة',
            'nama_latin': 'Al-Baqarah',
            'jumlah_ayat': 286,
            'tempat_turun': 'madinah',
            'arti': 'Sapi',
            'deskripsi': 'Deskripsi',
            'audio': 'audio.mp3',
          },
          'surat_sebelumnya': {
            'nomor': 0,
            'nama': '',
            'nama_latin': '',
            'jumlah_ayat': 0,
            'tempat_turun': '',
            'arti': '',
            'deskripsi': '',
            'audio': '',
          },
        };

        // Act
        final result = SurahDetailModel.fromJson(json);

        // Assert
        expect(result.status, true);
        expect(result.nomor, 1);
        expect(result.nama, 'الفاتحة');
        expect(result.namaLatin, 'Al-Fatihah');
        expect(result.jumlahAyat, 7);
        expect(result.tempatTurun, 'mekah');
        expect(result.arti, 'Pembukaan');
        expect(
          result.deskripsi,
          'Surah Al-Fatihah adalah surah pertama dalam Al-Quran',
        );
        expect(result.audio, 'https://example.com/audio.mp3');
        expect(result.ayats.length, 2);
        expect(result.suratSelanjutnya?.nomor, 2);
        expect(result.suratSebelumnya?.nomor, 0);
      });

      test(
        'should create SurahDetailModel with default values when JSON has null values',
        () {
          // Arrange
          final json = {
            'status': null,
            'nomor': null,
            'nama': null,
            'nama_latin': null,
            'jumlah_ayat': null,
            'tempat_turun': null,
            'arti': null,
            'deskripsi': null,
            'audio': null,
            'ayat': null,
            'surat_selanjutnya': null,
            'surat_sebelumnya': null,
          };

          // Act
          final result = SurahDetailModel.fromJson(json);

          // Assert
          expect(result.status, false);
          expect(result.nomor, 0);
          expect(result.nama, '');
          expect(result.namaLatin, '');
          expect(result.jumlahAyat, 0);
          expect(result.tempatTurun, '');
          expect(result.arti, '');
          expect(result.deskripsi, '');
          expect(result.audio, '');
          expect(result.ayats, isEmpty);
          expect(result.suratSelanjutnya, isNull);
          expect(result.suratSebelumnya, isNull);
        },
      );

      test('should handle empty ayats array', () {
        // Arrange
        final json = {
          'status': true,
          'nomor': 1,
          'nama': 'الفاتحة',
          'nama_latin': 'Al-Fatihah',
          'jumlah_ayat': 7,
          'tempat_turun': 'mekah',
          'arti': 'Pembukaan',
          'deskripsi': 'Deskripsi',
          'audio': 'audio.mp3',
          'ayat': [],
          'surat_selanjutnya': null,
          'surat_sebelumnya': null,
        };

        // Act
        final result = SurahDetailModel.fromJson(json);

        // Assert
        expect(result.ayats, isEmpty);
        expect(result.ayats.length, 0);
      });

      test('should handle surat_sebelumnya as false', () {
        // Arrange
        final json = {
          'status': true,
          'nomor': 1,
          'nama': 'الفاتحة',
          'nama_latin': 'Al-Fatihah',
          'jumlah_ayat': 7,
          'tempat_turun': 'mekah',
          'arti': 'Pembukaan',
          'deskripsi': 'Deskripsi',
          'audio': 'audio.mp3',
          'ayat': [],
          'surat_selanjutnya': null,
          'surat_sebelumnya': false,
        };

        // Act
        final result = SurahDetailModel.fromJson(json);

        // Assert
        expect(result.suratSebelumnya, isNull);
      });
    });

    group('toJson', () {
      test('should convert SurahDetailModel to JSON', () {
        // Act
        final result = surahDetailModel.toJson();

        // Assert
        expect(result['status'], true);
        expect(result['nomor'], 1);
        expect(result['nama'], 'الفاتحة');
        expect(result['nama_latin'], 'Al-Fatihah');
        expect(result['jumlah_ayat'], 7);
        expect(result['tempat_turun'], 'mekah');
        expect(result['arti'], 'Pembukaan');
        expect(
          result['deskripsi'],
          'Surah Al-Fatihah adalah surah pertama dalam Al-Quran',
        );
        expect(result['audio'], 'https://example.com/audio.mp3');
        expect(result['ayat'], isA<List>());
        expect(result['ayat'].length, 2);
        expect(result['surat_selanjutnya'], isA<Map>());
        expect(result['surat_sebelumnya'], isA<Map>());
      });

      test(
        'should handle null suratSelanjutnya and suratSebelumnya in toJson',
        () {
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
            ayats: ayats,
          );

          // Act
          final result = surahDetailModelWithoutNavigation.toJson();

          // Assert
          expect(result['surat_selanjutnya'], isNull);
          expect(result['surat_sebelumnya'], isNull);
        },
      );

      test('should handle empty ayats list in toJson', () {
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

        // Act
        final result = surahDetailModelWithEmptyAyats.toJson();

        // Assert
        expect(result['ayat'], isEmpty);
        expect(result['ayat'].length, 0);
      });
    });

    group('copyWith', () {
      test('should create new instance with updated values', () {
        // Act
        final result = surahDetailModel.copyWith(
          nomor: 2,
          nama: 'البقرة',
          namaLatin: 'Al-Baqarah',
          jumlahAyat: 286,
          tempatTurun: 'madinah',
          arti: 'Sapi',
        );

        // Assert
        expect(result.nomor, 2);
        expect(result.nama, 'البقرة');
        expect(result.namaLatin, 'Al-Baqarah');
        expect(result.jumlahAyat, 286);
        expect(result.tempatTurun, 'madinah');
        expect(result.arti, 'Sapi');

        // Original values should remain unchanged
        expect(result.status, surahDetailModel.status);
        expect(result.deskripsi, surahDetailModel.deskripsi);
        expect(result.audio, surahDetailModel.audio);
        expect(result.ayats, surahDetailModel.ayats);
        expect(result.suratSelanjutnya, surahDetailModel.suratSelanjutnya);
        expect(result.suratSebelumnya, surahDetailModel.suratSebelumnya);
      });

      test('should create new instance with updated ayats', () {
        // Arrange
        final newAyats = [
          AyatModel(
            id: 3,
            surah: 1,
            nomor: 3,
            ar: 'الرَّحْمَٰنِ الرَّحِيمِ',
            tr: 'Ar-raḥmānir-raḥīm',
            idn: 'Yang Maha Pengasih lagi Maha Penyayang',
          ),
        ];

        // Act
        final result = surahDetailModel.copyWith(ayats: newAyats);

        // Assert
        expect(result.ayats, newAyats);
        expect(result.ayats.length, 1);
        expect(result.ayats.first.nomor, 3);

        // Original values should remain unchanged
        expect(result.nomor, surahDetailModel.nomor);
        expect(result.nama, surahDetailModel.nama);
      });

      test('should create new instance with updated navigation surahs', () {
        // Arrange
        final newNextSurah = SurahModel(
          nomor: 3,
          nama: 'آل عمران',
          namaLatin: 'Ali Imran',
          jumlahAyat: 200,
          tempatTurun: 'madinah',
          arti: 'Keluarga Imran',
          deskripsi: 'Deskripsi',
          audio: 'audio.mp3',
        );

        final newPrevSurah = SurahModel(
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
        final result = surahDetailModel.copyWith(
          suratSelanjutnya: newNextSurah,
          suratSebelumnya: newPrevSurah,
        );

        // Assert
        expect(result.suratSelanjutnya, newNextSurah);
        expect(result.suratSelanjutnya?.nomor, 3);
        expect(result.suratSebelumnya, newPrevSurah);
        expect(result.suratSebelumnya?.nomor, 1);

        // Original values should remain unchanged
        expect(result.nomor, surahDetailModel.nomor);
        expect(result.ayats, surahDetailModel.ayats);
      });

      test('should preserve original values when null is passed to copyWith', () {
        // Act
        final result = surahDetailModel.copyWith(
          suratSelanjutnya: null,
          suratSebelumnya: null,
        );

        // Assert - should preserve original values since copyWith uses null-coalescing
        expect(result.suratSelanjutnya, surahDetailModel.suratSelanjutnya);
        expect(result.suratSebelumnya, surahDetailModel.suratSebelumnya);

        // Original values should remain unchanged
        expect(result.nomor, surahDetailModel.nomor);
        expect(result.ayats, surahDetailModel.ayats);
      });
    });

    test('should maintain equality after copyWith with same values', () {
      // Act
      final result = surahDetailModel.copyWith();

      // Assert
      expect(result, equals(surahDetailModel));
    });

    test('should not be equal after copyWith with different values', () {
      // Act
      final result = surahDetailModel.copyWith(nomor: 2);

      // Assert
      expect(result, isNot(equals(surahDetailModel)));
    });
  });
}
