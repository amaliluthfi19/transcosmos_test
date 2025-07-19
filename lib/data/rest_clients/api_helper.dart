import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';

class ApiHelper {
  static final ApiHelper _instance = ApiHelper._internal();
  factory ApiHelper() => _instance;
  ApiHelper._internal();

  final String _baseUrl = AppConstants.baseUrl;
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future get(String endpoint) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl$endpoint'), headers: _headers)
          .timeout(Duration(milliseconds: AppConstants.connectionTimeout));

      return response.body;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is ApiException) {
      return error;
    } else if (error.toString().contains('TimeoutException')) {
      return ApiException(message: 'Request timeout', statusCode: 408);
    } else {
      return ApiException(
        message: 'Network error: ${error.toString()}',
        statusCode: 0,
      );
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException({required this.message, required this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}
