import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../domain/entities/surah_detail.dart';
import '../../../domain/usecases/get_surah_detail_usecase.dart';

class SurahDetailController extends GetxController {
  final GetSurahDetailUseCase _getSurahDetailUseCase;

  SurahDetailController(this._getSurahDetailUseCase);

  // Observable variables
  final _surahDetail = Rxn<SurahDetail>();
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;

  // Audio player variables
  final AudioPlayer _audioPlayer = AudioPlayer();
  final _isPlaying = false.obs;
  final _isLoadingAudio = false.obs;
  final _isSeeking = false.obs;
  final _currentPosition = Duration.zero.obs;
  final _totalDuration = Duration.zero.obs;
  final _audioProgress = 0.0.obs;
  final _wasPlayingBeforeSeek = false.obs;
  final _audioPlayerHeight = 0.0.obs;

  // Getters
  SurahDetail? get surahDetail => _surahDetail.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  bool get isPlaying => _isPlaying.value;
  bool get isLoadingAudio => _isLoadingAudio.value;
  bool get isSeeking => _isSeeking.value;
  Duration get currentPosition => _currentPosition.value;
  Duration get totalDuration => _totalDuration.value;
  double get audioProgress => _audioProgress.value;
  double get audioPlayerHeight => _audioPlayerHeight.value;

  @override
  void onInit() {
    super.onInit();

    // Setup audio player when controller is initialized
    _setupAudioPlayer();
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }

  void _setupAudioPlayer() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying.value = state == PlayerState.playing;
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      _totalDuration.value = duration;
    });

    _audioPlayer.onPositionChanged.listen((position) {
      // Only update position if not currently seeking
      if (!_isSeeking.value) {
        _currentPosition.value = position;
        if (_totalDuration.value.inMilliseconds > 0) {
          _audioProgress.value =
              position.inMilliseconds / _totalDuration.value.inMilliseconds;
        }
      }
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      _isPlaying.value = false;
      _currentPosition.value = Duration.zero;
      _audioProgress.value = 0.0;
    });

    _audioPlayer.onSeekComplete.listen((_) {
      _isSeeking.value = false;
      // Resume playback if it was playing before seeking
      if (_wasPlayingBeforeSeek.value) {
        _wasPlayingBeforeSeek.value = false;
        playAudio();
      }
    });
  }

  Future<void> getSurahDetail(int nomor) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final surahDetail = await _getSurahDetailUseCase.execute(nomor);
      _surahDetail.value = surahDetail;

      // Autoload audio when surah detail is loaded
      if (surahDetail.audio.isNotEmpty) {
        await _loadAudio(surahDetail.audio);
      }
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _loadAudio(String audioUrl) async {
    try {
      _isLoadingAudio.value = true;
      await _audioPlayer.setSourceUrl(audioUrl);
    } catch (e) {
      _errorMessage.value = 'Failed to load audio: $e';
    } finally {
      _isLoadingAudio.value = false;
    }
  }

  Future<void> playAudio() async {
    try {
      if (_surahDetail.value?.audio.isNotEmpty == true) {
        await _audioPlayer.resume();
      }
    } catch (e) {
      _errorMessage.value = 'Failed to play audio: $e';
    }
  }

  Future<void> pauseAudio() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      _errorMessage.value = 'Failed to pause audio: $e';
    }
  }

  Future<void> stopAudio() async {
    try {
      await _audioPlayer.stop();
      _currentPosition.value = Duration.zero;
      _audioProgress.value = 0.0;
      _isSeeking.value = false;
      _wasPlayingBeforeSeek.value = false;
    } catch (e) {
      _errorMessage.value = 'Failed to stop audio: $e';
    }
  }

  Future<void> seekAudio(Duration position) async {
    try {
      _isSeeking.value = true;
      await _audioPlayer.seek(position);
    } catch (e) {
      _errorMessage.value = 'Failed to seek audio: $e';
      _isSeeking.value = false;
    }
  }

  Future<void> seekAudioByProgress(double progress) async {
    if (_totalDuration.value.inMilliseconds > 0) {
      final position = Duration(
        milliseconds: (progress * _totalDuration.value.inMilliseconds).round(),
      );

      // Save current playing state before seeking
      _wasPlayingBeforeSeek.value = _isPlaying.value;

      // Update progress immediately
      _audioProgress.value = progress.clamp(0.0, 1.0);
      _currentPosition.value = position;

      await seekAudio(position);
    }
  }

  // seeking with auto-resume
  Future<void> seekAudioByProgressWithResume(
    double progress, {
    bool autoResume = true,
  }) async {
    if (_totalDuration.value.inMilliseconds > 0) {
      final position = Duration(
        milliseconds: (progress * _totalDuration.value.inMilliseconds).round(),
      );

      // Save current playing state before seeking
      _wasPlayingBeforeSeek.value = autoResume && _isPlaying.value;

      // Update progress immediately
      _audioProgress.value = progress.clamp(0.0, 1.0);
      _currentPosition.value = position;

      await seekAudio(position);
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void updateAudioPlayerHeight(double height) {
    _audioPlayerHeight.value = height;
  }

  void refreshSurahDetail() {
    if (_surahDetail.value != null) {
      getSurahDetail(_surahDetail.value!.nomor);
    }
  }

  void navigateToNextSurah() {
    if (_surahDetail.value?.suratSelanjutnya != null) {
      final nextSurah = _surahDetail.value!.suratSelanjutnya!;
      stopAudio();
      getSurahDetail(nextSurah.nomor);
    }
  }

  void navigateToPreviousSurah() {
    if (_surahDetail.value?.suratSebelumnya != null) {
      final prevSurah = _surahDetail.value!.suratSebelumnya!;
      stopAudio();
      getSurahDetail(prevSurah.nomor);
    }
  }
}
