
import 'package:dio/dio.dart';
import 'package:patient_app/utils/api_urls.dart';
import 'package:patient_app/utils/locat_storage.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late Dio dio;

  ApiClient._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: ApiUrls.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    dio = Dio(options);

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token =getToken();
        if (token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        final errorMessage = _handleError(e);
        print("API Error: ${errorMessage.toString()}");
        return handler.next(e);
      },
    ));
  }
  static String getToken() {
    String? token = LocalStorageUtils.getString("token");
    return token ?? "";
  }
  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timed out";
      case DioExceptionType.badResponse:
        return "Server error: ${error.response?.statusCode}";
      case DioExceptionType.cancel:
        return "Request was cancelled";
      default:
        return "Something went wrong";
    }
  }
}