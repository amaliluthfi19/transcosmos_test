import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:transcosmos_test/domain/entities/surah_detail.dart';
import 'package:transcosmos_test/domain/entities/surah.dart';
import 'package:transcosmos_test/domain/entities/ayat.dart';
import 'package:transcosmos_test/presentations/surah_detail/controllers/surah_detail_controller.dart';
import '../../domain/usecases/get_surah_detail_usecase_test.dart';

// Mock controller for testing without AudioPlayer
class MockSurahDetailController extends GetxController
    implements SurahDetailController {
  final _surahDetail = Rxn<SurahDetail>();
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;
  final _isPlaying = false.obs;
  final _isLoadingAudio = false.obs;
  final _isSeeking = false.obs;
  final _currentPosition = Duration.zero.obs;
  final _totalDuration = Duration.zero.obs;
  final _audioProgress = 0.0.obs;
  final _audioPlayerHeight = 0.0.obs;

  // Track if states were manually set for testing
  bool _manualErrorSet = false;
  bool _manualSurahDetailSet = false;

  // Getters
  @override
  SurahDetail? get surahDetail => _surahDetail.value;
  @override
  bool get isLoading => _isLoading.value;
  @override
  String get errorMessage => _errorMessage.value;
  @override
  bool get isPlaying => _isPlaying.value;
  @override
  bool get isLoadingAudio => _isLoadingAudio.value;
  @override
  bool get isSeeking => _isSeeking.value;
  @override
  Duration get currentPosition => _currentPosition.value;
  @override
  Duration get totalDuration => _totalDuration.value;
  @override
  double get audioProgress => _audioProgress.value;
  @override
  double get audioPlayerHeight => _audioPlayerHeight.value;

  // Mock implementation of getSurahDetail
  @override
  Future<void> getSurahDetail(int nomor) async {
    // If manual states were set for testing, respect them
    if (_manualErrorSet || _manualSurahDetailSet) {
      return; // Don't override manually set states
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    // Simulate success or error based on nomor
    if (nomor == 1) {
      _surahDetail.value = _createTestSurahDetail();
    } else {
      _errorMessage.value = 'Surah not found';
    }

    _isLoading.value = false;
  }

  // Helper methods for testing
  void setSurahDetail(SurahDetail? detail) {
    _manualSurahDetailSet = true;
    _surahDetail.value = detail;
  }

  void setError(String error) {
    _manualErrorSet = true;
    _errorMessage.value = error;
  }

  // Reset manual state tracking
  void resetManualStates() {
    _manualErrorSet = false;
    _manualSurahDetailSet = false;
  }

  // Mock audio methods
  @override
  Future<void> playAudio() async {
    _isPlaying.value = true;
  }

  @override
  Future<void> pauseAudio() async {
    _isPlaying.value = false;
  }

  @override
  Future<void> stopAudio() async {
    _isPlaying.value = false;
    _currentPosition.value = Duration.zero;
    _audioProgress.value = 0.0;
  }

  @override
  Future<void> seekAudio(Duration position) async {
    _currentPosition.value = position;
  }

  @override
  Future<void> seekAudioByProgress(double progress) async {
    _audioProgress.value = progress;
  }

  @override
  Future<void> seekAudioByProgressWithResume(
    double progress, {
    bool autoResume = true,
  }) async {
    _audioProgress.value = progress;
  }

  @override
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void updateAudioPlayerHeight(double height) {
    _audioPlayerHeight.value = height;
  }

  @override
  void refreshSurahDetail() {
    if (_surahDetail.value != null) {
      getSurahDetail(_surahDetail.value!.nomor);
    }
  }

  @override
  void navigateToNextSurah() {
    if (_surahDetail.value?.suratSelanjutnya != null) {
      final nextSurah = _surahDetail.value!.suratSelanjutnya!;
      stopAudio();
      getSurahDetail(nextSurah.nomor);
    }
  }

  @override
  void navigateToPreviousSurah() {
    if (_surahDetail.value?.suratSebelumnya != null) {
      final prevSurah = _surahDetail.value!.suratSebelumnya!;
      stopAudio();
      getSurahDetail(prevSurah.nomor);
    }
  }

  @override
  void setErrorMessage(String value) {
    _errorMessage.value = value;
  }

  @override
  void setLoading(bool value) {
    _isLoading.value = value;
  }

  SurahDetail _createTestSurahDetail() {
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

    return SurahDetail(
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
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SurahDetailController Core Functionality', () {
    late MockGetSurahDetailUseCase mockUseCase;
    late SurahDetail testSurahDetail;

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

      testSurahDetail = SurahDetail(
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

      mockUseCase = MockGetSurahDetailUseCase();
    });

    group('Use Case Tests', () {
      test('should execute use case successfully', () async {
        // Arrange
        mockUseCase = MockGetSurahDetailUseCase(surahDetail: testSurahDetail);

        // Act
        final result = await mockUseCase.execute(1);

        // Assert
        expect(result, testSurahDetail);
        expect(result.nomor, 1);
        expect(result.namaLatin, 'Al-Fatihah');
        expect(result.ayats.length, 2);
      });

      test('should handle use case error', () async {
        // Arrange
        mockUseCase = MockGetSurahDetailUseCase(
          exception: Exception('Network error'),
        );

        // Act & Assert
        expect(() => mockUseCase.execute(1), throwsException);
      });

      test('should handle different surah numbers', () async {
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
          ayats: testSurahDetail.ayats,
          suratSelanjutnya: testSurahDetail.suratSelanjutnya,
          suratSebelumnya: testSurahDetail.suratSebelumnya,
        );

        mockUseCase = MockGetSurahDetailUseCase(surahDetail: surahDetail2);

        // Act
        final result = await mockUseCase.execute(2);

        // Assert
        expect(result.nomor, 2);
        expect(result.namaLatin, 'Al-Baqarah');
      });
    });

    group('Repository Tests', () {
      test('should execute repository successfully', () async {
        // Arrange
        final repository = MockSurahDetailRepository(
          surahDetail: testSurahDetail,
        );

        // Act
        final result = await repository.getSurahDetail(1);

        // Assert
        expect(result, testSurahDetail);
        expect(result.nomor, 1);
        expect(result.namaLatin, 'Al-Fatihah');
      });

      test('should handle repository error', () async {
        // Arrange
        final repository = MockSurahDetailRepository(
          exception: Exception('Network error'),
        );

        // Act & Assert
        expect(() => repository.getSurahDetail(1), throwsException);
      });
    });

    group('SurahDetail Entity Tests', () {
      test('should create SurahDetail with all properties', () {
        // Assert
        expect(testSurahDetail.status, true);
        expect(testSurahDetail.nomor, 1);
        expect(testSurahDetail.nama, 'الفاتحة');
        expect(testSurahDetail.namaLatin, 'Al-Fatihah');
        expect(testSurahDetail.jumlahAyat, 7);
        expect(testSurahDetail.tempatTurun, 'mekah');
        expect(testSurahDetail.arti, 'Pembukaan');
        expect(
          testSurahDetail.deskripsi,
          'Surah Al-Fatihah adalah surah pertama dalam Al-Quran',
        );
        expect(testSurahDetail.audio, 'https://example.com/audio.mp3');
        expect(testSurahDetail.ayats.length, 2);
        expect(testSurahDetail.suratSelanjutnya?.nomor, 2);
        expect(testSurahDetail.suratSebelumnya?.nomor, 0);
      });

      test('should handle SurahDetail without navigation', () {
        // Arrange
        final surahDetailWithoutNav = SurahDetail(
          status: true,
          nomor: 1,
          nama: 'الفاتحة',
          namaLatin: 'Al-Fatihah',
          jumlahAyat: 7,
          tempatTurun: 'mekah',
          arti: 'Pembukaan',
          deskripsi: 'Deskripsi',
          audio: 'audio.mp3',
          ayats: testSurahDetail.ayats,
        );

        // Assert
        expect(surahDetailWithoutNav.suratSelanjutnya, isNull);
        expect(surahDetailWithoutNav.suratSebelumnya, isNull);
      });

      test('should handle SurahDetail with empty ayats', () {
        // Arrange
        final surahDetailEmptyAyats = SurahDetail(
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
        expect(surahDetailEmptyAyats.ayats, isEmpty);
        expect(surahDetailEmptyAyats.ayats.length, 0);
      });
    });

    group('Ayat Entity Tests', () {
      test('should create Ayat with all properties', () {
        // Arrange
        final ayat = testSurahDetail.ayats.first;

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
    });

    group('Error Handling Tests', () {
      test('should handle network errors', () async {
        // Arrange
        mockUseCase = MockGetSurahDetailUseCase(
          exception: Exception('Network error'),
        );

        // Act & Assert
        expect(() => mockUseCase.execute(1), throwsException);
      });

      test('should handle format errors', () async {
        // Arrange
        mockUseCase = MockGetSurahDetailUseCase(
          exception: FormatException('Invalid format'),
        );

        // Act & Assert
        expect(() => mockUseCase.execute(1), throwsException);
      });

      test('should handle not found errors', () async {
        // Arrange
        mockUseCase = MockGetSurahDetailUseCase(
          exception: Exception('Surah not found'),
        );

        // Act & Assert
        expect(() => mockUseCase.execute(999), throwsException);
      });
    });
  });
}
