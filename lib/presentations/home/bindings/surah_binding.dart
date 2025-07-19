import 'package:get/get.dart';
import 'package:transcosmos_test/data/rest_clients/api_helper.dart';
import 'package:transcosmos_test/data/rest_clients/home_rest_client.dart';
import 'package:transcosmos_test/data/repositories/home_repository_impl.dart';
import 'package:transcosmos_test/domain/repositories/home_repository.dart';
import 'package:transcosmos_test/domain/usecases/get_surahs_usecase.dart';
import 'package:transcosmos_test/presentations/home/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Core dependencies
    Get.lazyPut<ApiHelper>(() => ApiHelper(), fenix: true);

    // Data sources
    Get.lazyPut<HomeRestClient>(
      () => HomeRemoteDataSourceImpl(Get.find<ApiHelper>()),
      fenix: true,
    );

    // Repositories
    Get.lazyPut<HomeRepository>(
      () => HomeRepositoryImpl(Get.find<HomeRestClient>()),
      fenix: true,
    );

    // Use cases
    Get.lazyPut<GetSurahsUseCase>(
      () => GetSurahsUseCase(Get.find<HomeRepository>()),
      fenix: true,
    );

    // Controllers
    Get.lazyPut<HomeController>(
      () => HomeController(Get.find<GetSurahsUseCase>()),
      fenix: true,
    );
  }
}
