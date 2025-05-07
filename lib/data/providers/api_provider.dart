import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:simpl/app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiProvider extends GetxService {
  late dio.Dio _dio;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) {
          String message = _handleDioError(error);
          if (error.response?.statusCode == 401) {
            // Handle unauthorized error (token expired or invalid)
            // You might want to:
            // 1. Try to refresh the token
            // 2. If refresh fails, redirect to login
            Get.offAllNamed('/login'); // Example logout action
          }
          return handler.reject(
            dio.DioException(
              requestOptions: error.requestOptions,
              error: message,
              type: error.type,
              response: error.response,
            ),
          );
        },
      ),
    );

    return this;
  }

  // Helper to format errors
  String _handleDioError(dio.DioException error) {
    if (error.type == dio.DioExceptionType.connectionTimeout ||
        error.type == dio.DioExceptionType.receiveTimeout) {
      return "Connection timed out. Please check your internet.";
    } else if (error.type == dio.DioExceptionType.badCertificate ||
        error.error.toString().contains("HandshakeException")) {
      return "Secure connection failed. Please check your internet or use a trusted network.";
    } else if (error.type == dio.DioExceptionType.connectionError) {
      return "Failed to connect to server. Please check your internet.";
    } else if (error.response != null) {
      return error.response?.data['message'] ??
          "Something went wrong. Please try again.";
    } else {
      return "Unexpected error occurred. Please try again later.";
    }
  }

  // GET request
  Future<dio.Response> get(String url, {Map<String, dynamic>? query}) async {
    try {
      return await _dio.get(url, queryParameters: query);
    } on dio.DioException catch (e) {
      throw Exception(e.error ?? 'API GET failed');
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

  Future<dio.Response> postDio(String url, {dynamic data}) async {
    try {
      return await _dio.post(url, data: data);
    } on dio.DioException catch (e) {
      throw Exception(e.error ?? 'API POST failed');
    }
  }

  // PUT request
  Future<dio.Response> put(String url, {dynamic data}) async {
    try {
      return await _dio.put(url, data: data);
    } on dio.DioException catch (e) {
      throw Exception(e.error ?? 'API PUT failed');
    }
  }

  // DELETE request
  Future<dio.Response> delete(String url) async {
    try {
      return await _dio.delete(url);
    } on dio.DioException catch (e) {
      throw Exception(e.error ?? 'API DELETE failed');
    }
  }

  Future<void> setAuthToken(String token) async {
    final prefs = await _prefs;
    await prefs.setString('auth_token', token);
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Clear auth token (for logout)
  Future<void> clearAuthToken() async {
    final prefs = await _prefs;
    await prefs.remove('auth_token');
    _dio.options.headers.remove('Authorization');
  }
  // Set auth token
  // void setAuthToken(String token) {
  //   _dio.options.headers['Authorization'] = 'Bearer $token';
  // }

  // // Clear auth token
  // Future<void> clearAuthToken() async {
  //   _dio.options.headers.remove('Authorization');
  // }
}
