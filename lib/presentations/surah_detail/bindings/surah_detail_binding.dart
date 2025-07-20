import 'package:get/get.dart';
import 'package:transcosmos_test/presentations/surah_detail/controllers/surah_detail_controller.dart';
import 'package:transcosmos_test/domain/usecases/get_surah_detail_usecase.dart';
import 'package:transcosmos_test/data/repositories/surah_detail_repository_impl.dart';
import 'package:transcosmos_test/data/rest_clients/surah_detail_rest_client.dart';
import 'package:transcosmos_test/data/rest_clients/api_helper.dart';

class SurahDetailBinding extends Bindings {
  @override
  void dependencies() {
    // API Helper
    Get.lazyPut<ApiHelper>(() => ApiHelper());

    // Rest Client
    Get.lazyPut<SurahDetailRestClient>(
      () => SurahDetailRemoteDataSourceImpl(Get.find<ApiHelper>()),
    );

    // Repository
    Get.lazyPut<SurahDetailRepositoryImpl>(
      () => SurahDetailRepositoryImpl(Get.find<SurahDetailRestClient>()),
    );

    // Use Case
    Get.lazyPut<GetSurahDetailUseCase>(
      () => GetSurahDetailUseCase(Get.find<SurahDetailRepositoryImpl>()),
    );

    // Controller
    Get.lazyPut<SurahDetailController>(
      () => SurahDetailController(Get.find<GetSurahDetailUseCase>()),
    );
  }
}
