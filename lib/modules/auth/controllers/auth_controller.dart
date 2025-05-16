import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_delivery_br/data/models/user_model.dart';
import 'package:home_delivery_br/data/repositories/auth_repository.dart';
import 'package:home_delivery_br/routes/app_pages.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;

  AuthController({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final isLoading = false.obs;
  final isLoggedIn = false.obs;
  final user = Rxn<User>();

  // Text controllers

  final loginFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final verificationCodeController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    emailController.text = '';
    passwordController.text = '';
    checkLoginStatus();
  }

  @override
  void onClose() {
    // emailController.dispose();
    // passwordController.dispose();
    // nameController.dispose();
    // verificationCodeController.dispose();
    super.onClose();
  }

  // Check if user is logged in
  Future<void> checkLoginStatus() async {
    isLoading.value = true;
    try {
      final loggedIn = await _authRepository.isLoggedIn();
      isLoggedIn.value = loggedIn;

      if (loggedIn) {
        user.value = await _authRepository.getCurrentUser();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to check login status',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Login
  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Email and password are required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      user.value = await _authRepository.login(
        emailController.text,
        passwordController.text,
      );
      isLoggedIn.value = true;
      Get.offAllNamed(Routes.ORDERS);
    } catch (e) {

      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Register
  Future<void> register() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'All fields are required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      await _authRepository.register(
        nameController.text,
        emailController.text,
        passwordController.text,
      );
      Get.toNamed(Routes.VERIFICATION);
    } catch (e) {
      Get.snackbar(
        'Error',
        '${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Verify email
  Future<void> verifyEmail() async {
    if (verificationCodeController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Verification code is required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      final success = await _authRepository.verifyEmail(
        verificationCodeController.text,
      );

      if (success) {
        Get.offAllNamed(Routes.LOGIN);
        Get.snackbar(
          'Success',
          'Email verified successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        '${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Logout
  Future<void> logout() async {
    isLoading.value = true;
    try {
      await _authRepository.logout();
      isLoggedIn.value = false;
      user.value = null;
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar(
        'Error',
        '${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
