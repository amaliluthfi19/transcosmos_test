import 'package:transcosmos_test/domain/entities/surah_detail.dart';
import 'package:transcosmos_test/domain/repositories/surah_detail_repository.dart';

class GetSurahDetailUseCase {
  final SurahDetailRepository repository;

  GetSurahDetailUseCase(this.repository);

  Future<SurahDetail> execute(int nomor) async {
    return await repository.getSurahDetail(nomor);
  }
}
