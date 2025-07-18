import 'dart:convert';

import 'package:transcosmos_test/core/constants/app_constants.dart';

import '../../core/utils/api_helper.dart';
import '../models/surah_model.dart';

abstract class SurahRestClient {
  Future<List<SurahModel>> getAllSurahs();
  Future<SurahModel> getSurahByNumber(int nomor);
}

class SurahRemoteDataSourceImpl implements SurahRestClient {
  final ApiHelper apiHelper;

  SurahRemoteDataSourceImpl(this.apiHelper);

  @override
  Future<List<SurahModel>> getAllSurahs() async {
    final response = await apiHelper.get(AppConstants.surahEndpoint);
    List surahsJson = jsonDecode(response);

    return surahsJson.map((json) => SurahModel.fromJson(json)).toList();
  }

  @override
  Future<SurahModel> getSurahByNumber(int nomor) async {
    final response = await apiHelper.get(
      AppConstants.surahDetailEndpoint.replaceAll('{nomor}', nomor.toString()),
    );
    Map<String, dynamic> surahJson = jsonDecode(response);
    return SurahModel.fromJson(surahJson);
  }
}
