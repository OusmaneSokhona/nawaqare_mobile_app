import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:patient_app/screens/auth_screens/sign_in_screen.dart';
import 'package:patient_app/utils/api_urls.dart';
import '../utils/app_bindings.dart';
import '../utils/locat_storage.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() => _instance;

  late Dio dio;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = getToken();
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            await _handleTokenExpiration();

            return handler.reject(
              DioException(
                requestOptions: e.requestOptions,
                error: "Session expired. Please login again.",
                response: Response(
                  requestOptions: e.requestOptions,
                  statusCode: 401,
                  statusMessage: "Session expired. Please login again.",
                ),
                type: DioExceptionType.badResponse,
              ),
            );
          }

          final errorMessage = _handleError(e);
          print("API Error: ${errorMessage.toString()}");
          return handler.next(e);
        },
      ),
    );
  }

  static String getToken() {
    String? token = LocalStorageUtils.getString("token");
    return token ?? "";
  }

  Future<void> _handleTokenExpiration() async {
    await LocalStorageUtils.deleteUser();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.snackbar(
        "Expired",
        "Session expired. Please login again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Get.offAll(SignInScreen(), binding: AppBinding());
    });
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
