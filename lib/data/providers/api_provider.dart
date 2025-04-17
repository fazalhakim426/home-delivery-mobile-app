import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:simpl/app/constants.dart';

class ApiProvider extends GetxService {
  late dio.Dio _dio;

  Future<ApiProvider> init() async {
    _dio = dio.Dio(
      dio.BaseOptions(
        baseUrl: Constants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add token if available
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ),
    );

    return this;
  }

  // GET request
  Future<dio.Response> get(String url, {Map<String, dynamic>? query}) async {
    try {
      return await _dio.get(url, queryParameters: query);
    } catch (e) {
      rethrow;
    }
  }

  // POST request
  Future<dio.Response> post(String url, {dynamic data}) async {
    try {
      return await _dio.post(url, data: data);
    } catch (e) {
      rethrow;
    }
  }

  // PUT request
  Future<dio.Response> put(String url, {dynamic data}) async {
    try {
      return await _dio.put(url, data: data);
    } catch (e) {
      rethrow;
    }
  }

  // DELETE request
  Future<dio.Response> delete(String url) async {
    try {
      return await _dio.delete(url);
    } catch (e) {
      rethrow;
    }
  }

  // Set auth token
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }
}
