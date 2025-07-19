import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transcosmos_test/core/constants/route_constans.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: appTheme,
      themeMode: ThemeMode.system,
      initialRoute: RouteConstants.home,
      getPages: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
