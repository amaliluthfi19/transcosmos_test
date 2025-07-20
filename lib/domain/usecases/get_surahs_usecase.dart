import 'package:transcosmos_test/domain/entities/surah.dart';
import 'package:transcosmos_test/domain/repositories/home_repository.dart';

class GetSurahsUseCase {
  final HomeRepository repository;

  GetSurahsUseCase(this.repository);

  Future<List<Surah>> execute() async {
    return await repository.getAllSurahs();
  }
}
