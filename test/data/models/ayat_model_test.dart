import 'package:flutter_test/flutter_test.dart';
import 'package:transcosmos_test/data/models/ayat_model.dart';

void main() {
  group('AyatModel', () {
    late AyatModel ayatModel;

    setUp(() {
      ayatModel = AyatModel(
        id: 1,
        surah: 1,
        nomor: 1,
        ar: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        tr: 'Bismillāhir-raḥmānir-raḥīm',
        idn: 'Dengan nama Allah Yang Maha Pengasih lagi Maha Penyayang',
      );
    });

    group('fromJson', () {
      test('should create AyatModel from valid JSON', () {
        // Arrange
        final json = {
          'id': 1,
          'surah': 1,
          'nomor': 1,
          'ar': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
          'tr': 'Bismillāhir-raḥmānir-raḥīm',
          'idn': 'Dengan nama Allah Yang Maha Pengasih lagi Maha Penyayang',
        };

        // Act
        final result = AyatModel.fromJson(json);

        // Assert
        expect(result.id, 1);
        expect(result.surah, 1);
        expect(result.nomor, 1);
        expect(result.ar, 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ');
        expect(result.tr, 'Bismillāhir-raḥmānir-raḥīm');
        expect(
          result.idn,
          'Dengan nama Allah Yang Maha Pengasih lagi Maha Penyayang',
        );
      });

      test(
        'should create AyatModel with default values when JSON has null values',
        () {
          // Arrange
          final json = {
            'id': null,
            'surah': null,
            'nomor': null,
            'ar': null,
            'tr': null,
            'idn': null,
          };

          // Act
          final result = AyatModel.fromJson(json);

          // Assert
          expect(result.id, 0);
          expect(result.surah, 0);
          expect(result.nomor, 0);
          expect(result.ar, '');
          expect(result.tr, '');
          expect(result.idn, '');
        },
      );

      test(
        'should create AyatModel with default values when JSON has missing keys',
        () {
          // Arrange
          final json = <String, dynamic>{};

          // Act
          final result = AyatModel.fromJson(json);

          // Assert
          expect(result.id, 0);
          expect(result.surah, 0);
          expect(result.nomor, 0);
          expect(result.ar, '');
          expect(result.tr, '');
          expect(result.idn, '');
        },
      );

      test('should handle different data types in JSON', () {
        // Arrange
        final json = {
          'id': '1', // String instead of int
          'surah': 1.0, // Double instead of int
          'nomor': 1,
          'ar': 123, // Int instead of string
          'tr': true, // Bool instead of string
          'idn': ['test'], // List instead of string
        };

        // Act & Assert - should throw type error for invalid types
        expect(() => AyatModel.fromJson(json), throwsA(isA<TypeError>()));
      });
    });

    group('toJson', () {
      test('should convert AyatModel to JSON', () {
        // Act
        final result = ayatModel.toJson();

        // Assert
        expect(result['id'], 1);
        expect(result['surah'], 1);
        expect(result['nomor'], 1);
        expect(result['ar'], 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ');
        expect(result['tr'], 'Bismillāhir-raḥmānir-raḥīm');
        expect(
          result['idn'],
          'Dengan nama Allah Yang Maha Pengasih lagi Maha Penyayang',
        );
      });

      test('should handle empty strings in toJson', () {
        // Arrange
        final emptyAyatModel = AyatModel(
          id: 0,
          surah: 0,
          nomor: 0,
          ar: '',
          tr: '',
          idn: '',
        );

        // Act
        final result = emptyAyatModel.toJson();

        // Assert
        expect(result['id'], 0);
        expect(result['surah'], 0);
        expect(result['nomor'], 0);
        expect(result['ar'], '');
        expect(result['tr'], '');
        expect(result['idn'], '');
      });

      test('should handle large numbers in toJson', () {
        // Arrange
        final largeAyatModel = AyatModel(
          id: 999999,
          surah: 114,
          nomor: 286,
          ar: 'Test Arabic text',
          tr: 'Test transliteration',
          idn: 'Test Indonesian translation',
        );

        // Act
        final result = largeAyatModel.toJson();

        // Assert
        expect(result['id'], 999999);
        expect(result['surah'], 114);
        expect(result['nomor'], 286);
        expect(result['ar'], 'Test Arabic text');
        expect(result['tr'], 'Test transliteration');
        expect(result['idn'], 'Test Indonesian translation');
      });
    });

    group('copyWith', () {
      test('should create new instance with updated values', () {
        // Act
        final result = ayatModel.copyWith(
          id: 2,
          surah: 2,
          nomor: 2,
          ar: 'Updated Arabic text',
          tr: 'Updated transliteration',
          idn: 'Updated Indonesian translation',
        );

        // Assert
        expect(result.id, 2);
        expect(result.surah, 2);
        expect(result.nomor, 2);
        expect(result.ar, 'Updated Arabic text');
        expect(result.tr, 'Updated transliteration');
        expect(result.idn, 'Updated Indonesian translation');

        // Original values should remain unchanged
        expect(ayatModel.id, 1);
        expect(ayatModel.ar, 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ');
      });

      test('should create new instance with partial updates', () {
        // Act
        final result = ayatModel.copyWith(id: 2, ar: 'Updated Arabic text');

        // Assert
        expect(result.id, 2);
        expect(result.ar, 'Updated Arabic text');

        // Other values should remain unchanged
        expect(result.surah, ayatModel.surah);
        expect(result.nomor, ayatModel.nomor);
        expect(result.tr, ayatModel.tr);
        expect(result.idn, ayatModel.idn);
      });

      test(
        'should create new instance with no changes when no parameters provided',
        () {
          // Act
          final result = ayatModel.copyWith();

          // Assert
          expect(result.id, ayatModel.id);
          expect(result.surah, ayatModel.surah);
          expect(result.nomor, ayatModel.nomor);
          expect(result.ar, ayatModel.ar);
          expect(result.tr, ayatModel.tr);
          expect(result.idn, ayatModel.idn);
        },
      );

      test('should handle null values in copyWith', () {
        // Act
        final result = ayatModel.copyWith(id: null, ar: null);

        // Assert
        expect(result.id, ayatModel.id); // Should keep original value
        expect(result.ar, ayatModel.ar); // Should keep original value
      });
    });

    test('should maintain equality after copyWith with same values', () {
      // Act
      final result = ayatModel.copyWith();

      // Assert
      expect(result, equals(ayatModel));
    });

    test('should not be equal after copyWith with different values', () {
      // Act
      final result = ayatModel.copyWith(id: 2);

      // Assert
      expect(result, isNot(equals(ayatModel)));
    });

    test('should handle round-trip JSON conversion', () {
      // Act
      final json = ayatModel.toJson();
      final result = AyatModel.fromJson(json);

      // Assert
      expect(result, equals(ayatModel));
    });

    test('should handle special characters in JSON conversion', () {
      // Arrange
      final specialAyatModel = AyatModel(
        id: 1,
        surah: 1,
        nomor: 1,
        ar: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ ١٢٣',
        tr: 'Bismillāhir-raḥmānir-raḥīm 123',
        idn: 'Dengan nama Allah Yang Maha Pengasih lagi Maha Penyayang 123',
      );

      // Act
      final json = specialAyatModel.toJson();
      final result = AyatModel.fromJson(json);

      // Assert
      expect(result, equals(specialAyatModel));
      expect(result.ar, 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ ١٢٣');
    });

    test('should handle very long text in JSON conversion', () {
      // Arrange
      final longText = 'A' * 1000;
      final longAyatModel = AyatModel(
        id: 1,
        surah: 1,
        nomor: 1,
        ar: longText,
        tr: longText,
        idn: longText,
      );

      // Act
      final json = longAyatModel.toJson();
      final result = AyatModel.fromJson(json);

      // Assert
      expect(result, equals(longAyatModel));
      expect(result.ar.length, 1000);
    });
  });
}
