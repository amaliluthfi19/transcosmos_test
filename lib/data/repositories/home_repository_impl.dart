import 'package:flutter/material.dart';

import 'package:transcosmos_test/domain/entities/surah.dart';
import 'package:transcosmos_test/domain/repositories/home_repository.dart';
import 'package:transcosmos_test/data/rest_clients/home_rest_client.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRestClient remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Surah>> getAllSurahs() async {
    try {
      final surahs = await remoteDataSource.getAllSurahs();
      return surahs;
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
      throw Exception(e);
    }
  }
}
