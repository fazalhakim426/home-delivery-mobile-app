import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_delivery_br/modules/auth/controllers/auth_controller.dart';
import 'package:home_delivery_br/routes/app_pages.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _handleStartupLogic();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/splash_logo.png'),
      ),
    );
  }
  void _handleStartupLogic() async {
    final authController = Get.find<AuthController>();

    await Future.delayed(Duration(seconds:1));

    await authController.checkLoginStatus();

    if (authController.isLoggedIn.value) {
      Get.offNamed(Routes.ORDERS);
    } else {
      Get.offNamed(Routes.LOGIN);
    }
  }
}