import '../entities/surah.dart';
import '../repositories/surah_repository.dart';

class GetSurahByNumberUseCase {
  final SurahRepository repository;

  GetSurahByNumberUseCase(this.repository);

  Future<Surah> execute(int nomor) async {
    return await repository.getSurahByNumber(nomor);
  }
}
