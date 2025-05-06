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

    // Load token from storage and set it if available
    final prefs = await _prefs;
    final token = prefs.getString('auth_token');
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }

    _dio.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: (options, handler) async {
          // You could add token refresh logic here if needed
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // Handle unauthorized error (token expired or invalid)
            // You might want to:
            // 1. Try to refresh the token
            // 2. If refresh fails, redirect to login
            Get.offAllNamed('/login'); // Example logout action
          }
          return handler.next(error);
        },
      ),
    );

    return this;
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


  // Future<ApiProvider> init() async {
  //   _dio = dio.Dio(
  //     dio.BaseOptions(
  //       baseUrl: Constants.baseUrl,
  //       connectTimeout: const Duration(seconds: 15),
  //       receiveTimeout: const Duration(seconds: 20),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //       },
  //     ),
  //   );
  //
  //   _dio.interceptors.add(
  //     dio.InterceptorsWrapper(
  //       onRequest: (options, handler) {
  //         // Add token if available
  //         return handler.next(options);
  //       },
  //       onResponse: (response, handler) {
  //         return handler.next(response);
  //       },
  //       onError: (error, handler) {
  //         return handler.next(error);
  //       },
  //     ),
  //   );
  //
  //   return this;
  // }

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
  // void setAuthToken(String token) {
  //   print(setAuthToken);
  //   print('Bearer $token');
  //   _dio.options.headers['Authorization'] = 'Bearer $token';
  // }
}
