import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:home_delivery_br/app/constants.dart';
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
        onRequest: (options, handler) async {
          // Always read token from storage before each request
          final token = await _getTokenFromStorage();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) async {
          String message = _handleDioError(error);
          if (error.response?.statusCode == 401) {
            // Clear token on 401 and redirect to login
            await clearAuthToken();
            Get.offAllNamed('/login');
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

  // Helper to get token from storage
  Future<String?> _getTokenFromStorage() async {
    final prefs = await _prefs;
    return prefs.getString('auth_token');
  }

  String _handleDioError(dio.DioException error) {
    if (error.type == dio.DioExceptionType.connectionTimeout ||
        error.type == dio.DioExceptionType.receiveTimeout) {
      return "Connection timed out.";
    } else if (error.type == dio.DioExceptionType.badCertificate ||
        error.error.toString().contains("HandshakeException")) {
      return "Please check your internet or use a trusted network.";
    } else if (error.type == dio.DioExceptionType.connectionError) {
      return "Please check your internet.";
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
  }

  Future<void> clearAuthToken() async {
    final prefs = await _prefs;
    await prefs.remove('auth_token');
    // No longer need to remove from headers here
  }
}