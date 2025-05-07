import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simpl/app/constants.dart';
import 'package:simpl/data/models/user_model.dart';
import 'package:simpl/data/providers/api_provider.dart';

class AuthRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  // Login
  Future<User> login(String email, String password) async {
    try {
      final response = await _apiProvider.postDio(
        Constants.login,
        data: {'email': email, 'password': password},
      );
      // Simulate successful login

      User user = User.fromJson(response.data['user']);
      print(user.token);

      // Save user token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(Constants.userToken, user.token ?? '');
      await prefs.setString(Constants.userData, user.email);

      // Set token for future requests
      _apiProvider.setAuthToken(user.token ?? '');

      return user;
    } catch (e) {
       print('Sending email: $email, password: $password');

      print('Failed to login: ${e.toString()}');
      throw Exception('Failed to login: ${e.toString()}');
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
      throw Exception('Failed to register: ${e.toString()}');
    }
  }

  // Verify
  Future<bool> verifyEmail(String code) async {
    try {
      // Dummy implementation
      return true;
    } catch (e) {
      throw Exception('Failed to verify email: ${e.toString()}');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(Constants.userToken);
      await prefs.remove(Constants.userData);
    } catch (e) {
      throw Exception('Failed to logout: ${e.toString()}');
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
