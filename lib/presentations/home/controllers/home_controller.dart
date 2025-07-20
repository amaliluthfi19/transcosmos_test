import 'package:get/get.dart';
import 'package:transcosmos_test/domain/entities/surah.dart';
import 'package:transcosmos_test/domain/usecases/get_surahs_usecase.dart';

class HomeController extends GetxController {
  final GetSurahsUseCase _getSurahsUseCase;

  HomeController(this._getSurahsUseCase);

  // Observable variables
  final _surahs = <Surah>[].obs;
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;
  final _searchKeyword = ''.obs;
  final _showSearchBar = false.obs;

  // Getters
  List<Surah> get surahs => _surahs;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  String get searchKeyword => _searchKeyword.value;
  bool get showSearchBar => _showSearchBar.value;

  List<Surah> get filteredSurahs {
    if (_searchKeyword.value.isEmpty) {
      return _surahs;
    }
    return _surahs.where((surah) {
      final query = _searchKeyword.value.toLowerCase();
      return surah.namaLatin.toLowerCase().contains(query) ||
          surah.nama.toLowerCase().contains(query) ||
          surah.arti.toLowerCase().contains(query) ||
          surah.nomor.toString().contains(query);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    getSurahs();
  }

  Future<void> getSurahs() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final surahs = await _getSurahsUseCase.execute();
      _surahs.assignAll(surahs);
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  void setSearchKeyword(String keyword) {
    _searchKeyword.value = keyword;
  }

  void toggleSearchBar() {
    _showSearchBar.value = !_showSearchBar.value;
    _searchKeyword.value = '';
    if (!_showSearchBar.value) {
      // Clear search when hiding search bar
      _searchKeyword.value = '';
    }
  }

  Future<void> refreshSurahs() async {
    await getSurahs();
  }
}
