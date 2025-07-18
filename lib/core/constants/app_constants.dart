class AppConstants {
  // App Info
  static const String appName = 'Al-Quran App';
  static const String appVersion = '1.0.0';

  // API Constants
  static const String baseUrl = 'https://open-api.my.id/api/quran';
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Route Names
  static const String homeRoute = '/home';
  static const String surahDetailRoute = '/surah-detail';
  static const String splashRoute = '/splash';

  // API Endpoints
  static const String surahEndpoint = '/surah';
  static const String surahDetailEndpoint = '/surah/{nomor}';
}
