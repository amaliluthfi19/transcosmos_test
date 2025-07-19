import 'package:transcosmos_test/domain/entities/surah_detail.dart';

abstract class SurahDetailRepository {
  Future<SurahDetail> getSurahDetail(int nomor);
}
