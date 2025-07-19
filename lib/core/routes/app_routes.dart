import 'package:get/get.dart';
import 'package:transcosmos_test/core/constants/route_constans.dart';
import 'package:transcosmos_test/presentations/home/ui/home_screen.dart';
import 'package:transcosmos_test/presentations/home/bindings/surah_binding.dart';
import 'package:transcosmos_test/presentations/surah_detail/ui/surah_detail_screen.dart';
import 'package:transcosmos_test/presentations/surah_detail/bindings/surah_detail_binding.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: RouteConstants.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: RouteConstants.surahDetail,
      page: () => const SurahDetailScreen(),
      binding: SurahDetailBinding(),
    ),
  ];
}
