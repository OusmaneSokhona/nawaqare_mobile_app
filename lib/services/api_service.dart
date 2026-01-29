import 'package:dio/dio.dart';

import '../client/api_client.dart';

class ApiService {
  final Dio _dio = ApiClient().dio;


  Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    try {
      return await _dio.get(path, queryParameters: query);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } catch (e) {
      rethrow;
    }
  }
  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } catch (e) {
      rethrow;
    }
  }
  Future<Response> delete(String path, {dynamic data}) async {
    try {
      return await _dio.delete(path, data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> upload(String path, String filePath) async {
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath),
      });
      return await _dio.post(path, data: formData);
    } catch (e) {
      rethrow;
    }
  }
}