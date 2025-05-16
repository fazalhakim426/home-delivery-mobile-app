import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:home_delivery_br/app/constants.dart';
import 'package:home_delivery_br/data/models/user_model.dart';
import 'package:home_delivery_br/data/providers/api_provider.dart';

class AuthRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  // Login
  Future<User> login(String email, String password) async {
    try {
      final response = await _apiProvider.postDio(
        Constants.login,
        data: {'email': email, 'password': password},
      );
      User user = User.fromJson(response.data['user']);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(Constants.userToken, user.token ?? '');
      await prefs.setString(Constants.userData, user.email);
      _apiProvider.setAuthToken(user.token ?? '');
      return user;
    } catch (e) {
      throw e;
    }
  }

  // Register
  Future<User> register(String name, String email, String password) async {
    try {
      // Dummy implementation
      final userData = {
        'id': 1,
        'name': name,
        'email': email,
        'token': 'test_token_12345',
      };

      User user = User.fromJson(userData);
      return user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Verify
  Future<bool> verifyEmail(String code) async {
    try {
      // Dummy implementation
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(Constants.userToken);
      await prefs.remove(Constants.userData);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(Constants.userToken);
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Get current user
  Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString(Constants.userData);

      if (email != null && email.isNotEmpty) {
        // Dummy user data
        return User(
          id: 1,
          name: 'Test User',
          email: email,
          token: prefs.getString(Constants.userToken),
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
