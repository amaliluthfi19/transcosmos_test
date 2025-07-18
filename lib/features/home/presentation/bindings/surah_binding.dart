import 'package:get/get.dart';
import '../../../../core/utils/api_helper.dart';
import '../../../../data/rest_clients/surah_rest_client.dart';
import '../../../../data/repositories/surah_repository_impl.dart';
import '../../../../domain/repositories/surah_repository.dart';
import '../../../../domain/usecases/get_surahs_usecase.dart';
import '../../../../domain/usecases/get_surah_by_number_usecase.dart';
import '../controllers/surah_controller.dart';

class SurahBinding extends Bindings {
  @override
  void dependencies() {
    // Core dependencies
    Get.lazyPut<ApiHelper>(() => ApiHelper(), fenix: true);

    // Data sources
    Get.lazyPut<SurahRestClient>(
      () => SurahRemoteDataSourceImpl(Get.find<ApiHelper>()),
      fenix: true,
    );

    // Repositories
    Get.lazyPut<SurahRepository>(
      () => SurahRepositoryImpl(Get.find<SurahRestClient>()),
      fenix: true,
    );

    // Use cases
    Get.lazyPut<GetSurahsUseCase>(
      () => GetSurahsUseCase(Get.find<SurahRepository>()),
      fenix: true,
    );

    Get.lazyPut<GetSurahByNumberUseCase>(
      () => GetSurahByNumberUseCase(Get.find<SurahRepository>()),
      fenix: true,
    );

    // Controllers
    Get.lazyPut<SurahController>(
      () => SurahController(
        Get.find<GetSurahsUseCase>(),
        Get.find<GetSurahByNumberUseCase>(),
      ),
      fenix: true,
    );
  }
}
