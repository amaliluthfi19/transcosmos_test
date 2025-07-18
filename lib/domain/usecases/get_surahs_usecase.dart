import '../entities/surah.dart';
import '../repositories/surah_repository.dart';

class GetSurahsUseCase {
  final SurahRepository repository;

  GetSurahsUseCase(this.repository);

  Future<List<Surah>> execute() async {
    return await repository.getAllSurahs();
  }
}
