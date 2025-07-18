import 'package:flutter/material.dart';

import '../../domain/entities/surah.dart';
import '../../domain/repositories/surah_repository.dart';
import '../surah_rest_client/surah_rest_client.dart';

class SurahRepositoryImpl implements SurahRepository {
  final SurahRestClient remoteDataSource;

  SurahRepositoryImpl(this.remoteDataSource);

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

  @override
  Future<Surah> getSurahByNumber(int nomor) async {
    try {
      final surah = await remoteDataSource.getSurahByNumber(nomor);
      return surah;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }
}
