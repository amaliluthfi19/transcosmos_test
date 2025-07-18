import '../entities/surah.dart';

abstract class SurahRepository {
  Future<List<Surah>> getAllSurahs();
  Future<Surah> getSurahByNumber(int nomor);
}
