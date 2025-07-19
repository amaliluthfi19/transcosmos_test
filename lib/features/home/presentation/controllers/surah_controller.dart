import 'package:get/get.dart';
import '../../../../domain/entities/surah.dart';
import '../../../../domain/usecases/get_surahs_usecase.dart';
import '../../../../domain/usecases/get_surah_by_number_usecase.dart';

class SurahController extends GetxController {
  final GetSurahsUseCase getSurahsUseCase;
  final GetSurahByNumberUseCase getSurahByNumberUseCase;

  SurahController(this.getSurahsUseCase, this.getSurahByNumberUseCase);

  // Observable variables
  final RxList<Surah> _surahs = <Surah>[].obs;
  final Rx<Surah?> _selectedSurah = Rx<Surah?>(null);
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxString _searchKeyword = ''.obs;

  // Getters
  List<Surah> get surahs => _surahs;
  Surah? get selectedSurah => _selectedSurah.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  String get searchQuery => _searchKeyword.value;

  @override
  void onInit() {
    super.onInit();
    // Load surahs when controller initializes
    getAllSurahs();
  }

  Future<void> getAllSurahs() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final surahs = await getSurahsUseCase.execute();
      _surahs.assignAll(surahs);
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> getSurahByNumber(int nomor) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final surah = await getSurahByNumberUseCase.execute(nomor);
      _selectedSurah.value = surah;
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  void setSearchKeyword(String keyword) {
    _searchKeyword.value = keyword;
  }

  List<Surah> get filteredSurahs {
    if (_searchKeyword.value.isEmpty) {
      return _surahs;
    }

    final keyword = _searchKeyword.value.toLowerCase();
    return _surahs.where((surah) {
      return surah.namaLatin.toLowerCase().contains(keyword) ||
          surah.arti.toLowerCase().contains(keyword) ||
          surah.nama.contains(keyword);
    }).toList();
  }

  void clearError() {
    _errorMessage.value = '';
  }

  void clearSelectedSurah() {
    _selectedSurah.value = null;
  }

  void refreshSurahs() {
    getAllSurahs();
  }
}
