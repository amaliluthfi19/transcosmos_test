import 'package:get/get.dart';
import '../../features/home/presentation/ui/home_screen.dart';
import '../../features/home/presentation/bindings/surah_binding.dart';
import '../constants/app_constants.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: AppConstants.homeRoute,
      page: () => const HomeScreen(),
      binding: SurahBinding(),
    ),
  ];
}
