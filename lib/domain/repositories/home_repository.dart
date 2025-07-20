import 'package:transcosmos_test/domain/entities/surah.dart';

abstract class HomeRepository {
  Future<List<Surah>> getAllSurahs();
}
