import 'package:flutter/material.dart';
import 'package:transcosmos_test/domain/entities/surah_detail.dart';
import 'package:transcosmos_test/domain/repositories/surah_detail_repository.dart';
import 'package:transcosmos_test/data/rest_clients/surah_detail_rest_client.dart';

class SurahDetailRepositoryImpl implements SurahDetailRepository {
  final SurahDetailRestClient remoteDataSource;

  SurahDetailRepositoryImpl(this.remoteDataSource);

  @override
  Future<SurahDetail> getSurahDetail(int nomor) async {
    try {
      final surahDetail = await remoteDataSource.getSurahDetail(nomor);
      return surahDetail;
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
      throw Exception(e);
    }
  }
}
