import 'package:flutter_test/flutter_test.dart';
import 'package:transcosmos_test/domain/entities/ayat.dart';

void main() {
  group('Ayat', () {
    late Ayat ayat;

    setUp(() {
      ayat = Ayat(
        id: 1,
        surah: 1,
        nomor: 1,
        ar: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        tr: 'Bismillāhir-raḥmānir-raḥīm',
        idn: 'Dengan nama Allah Yang Maha Pengasih lagi Maha Penyayang',
      );
    });

    test('should create Ayat with all required properties', () {
      // Assert
      expect(ayat.id, 1);
      expect(ayat.surah, 1);
      expect(ayat.nomor, 1);
      expect(ayat.ar, 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ');
      expect(ayat.tr, 'Bismillāhir-raḥmānir-raḥīm');
      expect(
        ayat.idn,
        'Dengan nama Allah Yang Maha Pengasih lagi Maha Penyayang',
      );
    });

    test('should return true when comparing identical Ayat objects', () {
      // Arrange
      final ayat2 = Ayat(
        id: 1,
        surah: 1,
        nomor: 1,
        ar: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        tr: 'Bismillāhir-raḥmānir-raḥīm',
        idn: 'Dengan nama Allah Yang Maha Pengasih lagi Maha Penyayang',
      );

      // Assert
      expect(ayat, equals(ayat2));
      expect(ayat == ayat2, isTrue);
    });

    test('should return false when comparing different Ayat objects', () {
      // Arrange
      final differentAyat = Ayat(
        id: 2,
        surah: 1,
        nomor: 2,
        ar: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
        tr: 'Al-ḥamdu lillāhi rabbil-ʿālamīn',
        idn: 'Segala puji bagi Allah, Tuhan semesta alam',
      );

      // Assert
      expect(ayat, isNot(equals(differentAyat)));
      expect(ayat == differentAyat, isFalse);
    });

    test('should generate consistent hashCode for identical objects', () {
      // Arrange
      final ayat2 = Ayat(
        id: 1,
        surah: 1,
        nomor: 1,
        ar: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        tr: 'Bismillāhir-raḥmānir-raḥīm',
        idn: 'Dengan nama Allah Yang Maha Pengasih lagi Maha Penyayang',
      );

      // Assert
      expect(ayat.hashCode, equals(ayat2.hashCode));
    });

    test('should generate different hashCode for different objects', () {
      // Arrange
      final differentAyat = Ayat(
        id: 2,
        surah: 1,
        nomor: 2,
        ar: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
        tr: 'Al-ḥamdu lillāhi rabbil-ʿālamīn',
        idn: 'Segala puji bagi Allah, Tuhan semesta alam',
      );

      // Assert
      expect(ayat.hashCode, isNot(equals(differentAyat.hashCode)));
    });

    test('should return correct string representation', () {
      // Act
      final result = ayat.toString();

      // Assert
      expect(
        result,
        contains(
          'Ayat{id: 1, surah: 1, nomor: 1, ar: بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ}',
        ),
      );
    });

    test('should handle empty strings in properties', () {
      // Arrange
      final emptyAyat = Ayat(
        id: 0,
        surah: 0,
        nomor: 0,
        ar: '',
        tr: '',
        idn: '',
      );

      // Assert
      expect(emptyAyat.id, 0);
      expect(emptyAyat.surah, 0);
      expect(emptyAyat.nomor, 0);
      expect(emptyAyat.ar, '');
      expect(emptyAyat.tr, '');
      expect(emptyAyat.idn, '');
    });

    test('should handle large numbers', () {
      // Arrange
      final largeAyat = Ayat(
        id: 999999,
        surah: 114,
        nomor: 286,
        ar: 'Test Arabic text',
        tr: 'Test transliteration',
        idn: 'Test Indonesian translation',
      );

      // Assert
      expect(largeAyat.id, 999999);
      expect(largeAyat.surah, 114);
      expect(largeAyat.nomor, 286);
    });

    test('should handle special characters in text', () {
      // Arrange
      final specialAyat = Ayat(
        id: 1,
        surah: 1,
        nomor: 1,
        ar: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ ١٢٣',
        tr: 'Bismillāhir-raḥmānir-raḥīm 123',
        idn: 'Dengan nama Allah Yang Maha Pengasih lagi Maha Penyayang 123',
      );

      // Assert
      expect(specialAyat.ar, 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ ١٢٣');
      expect(specialAyat.tr, 'Bismillāhir-raḥmānir-raḥīm 123');
      expect(
        specialAyat.idn,
        'Dengan nama Allah Yang Maha Pengasih lagi Maha Penyayang 123',
      );
    });

    test('should handle very long text', () {
      // Arrange
      final longText = 'A' * 1000;
      final longAyat = Ayat(
        id: 1,
        surah: 1,
        nomor: 1,
        ar: longText,
        tr: longText,
        idn: longText,
      );

      // Assert
      expect(longAyat.ar.length, 1000);
      expect(longAyat.tr.length, 1000);
      expect(longAyat.idn.length, 1000);
    });

    test('should handle negative numbers', () {
      // Arrange
      final negativeAyat = Ayat(
        id: -1,
        surah: -1,
        nomor: -1,
        ar: 'Test',
        tr: 'Test',
        idn: 'Test',
      );

      // Assert
      expect(negativeAyat.id, -1);
      expect(negativeAyat.surah, -1);
      expect(negativeAyat.nomor, -1);
    });
  });
}
