import 'dart:convert';
import 'package:transcosmos_test/core/constants/endpoint_constants.dart';
import 'package:transcosmos_test/data/rest_clients/api_helper.dart';
import 'package:transcosmos_test/data/models/surah_detail_model.dart';

abstract class SurahDetailRestClient {
  Future<SurahDetailModel> getSurahDetail(int nomor);
}

class SurahDetailRemoteDataSourceImpl implements SurahDetailRestClient {
  final ApiHelper apiHelper;

  SurahDetailRemoteDataSourceImpl(this.apiHelper);

  @override
  Future<SurahDetailModel> getSurahDetail(int nomor) async {
    final response = await apiHelper.get(
      EndpointConstants.surahDetail.replaceAll('{nomor}', nomor.toString()),
    );
    Map<String, dynamic> surahDetailJson = jsonDecode(response);
    return SurahDetailModel.fromJson(surahDetailJson);
  }
}
