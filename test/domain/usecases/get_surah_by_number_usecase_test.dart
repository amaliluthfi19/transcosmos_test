import 'package:flutter_test/flutter_test.dart';
import 'package:transcosmos_test/domain/entities/surah.dart';
import 'package:transcosmos_test/domain/repositories/home_repository.dart';

// Mock repository for testing
class MockSurahRepository implements HomeRepository {
  final List<Surah> _surahs;
  final Exception? _exception;

  MockSurahRepository({List<Surah>? surahs, Exception? exception})
    : _surahs = surahs ?? [],
      _exception = exception;

  @override
  Future<List<Surah>> getAllSurahs() async {
    if (_exception != null) throw _exception;
    return _surahs;
  }
}
