import 'dart:convert';

import 'package:transcosmos_test/core/constants/endpoint_constants.dart';

import 'api_helper.dart';
import 'package:transcosmos_test/data/models/surah_model.dart';

abstract class HomeRestClient {
  Future<List<SurahModel>> getAllSurahs();
  Future<SurahModel> getSurahByNumber(int nomor);
}

class HomeRemoteDataSourceImpl implements HomeRestClient {
  final ApiHelper apiHelper;

  HomeRemoteDataSourceImpl(this.apiHelper);

  @override
  Future<List<SurahModel>> getAllSurahs() async {
    final response = await apiHelper.get(EndpointConstants.surah);
    List surahsJson = jsonDecode(response);

    return surahsJson.map((json) => SurahModel.fromJson(json)).toList();
  }

  @override
  Future<SurahModel> getSurahByNumber(int nomor) async {
    final response = await apiHelper.get(
      EndpointConstants.surahDetail.replaceAll('{nomor}', nomor.toString()),
    );
    Map<String, dynamic> surahJson = jsonDecode(response);
    return SurahModel.fromJson(surahJson);
  }
}
