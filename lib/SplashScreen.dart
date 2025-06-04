import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_delivery_br/modules/auth/controllers/auth_controller.dart';
import 'package:home_delivery_br/routes/app_pages.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _handleStartupLogic(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/splash_logo.png'),
      ),
    );
  }

  void _handleStartupLogic(BuildContext context) async {
    final authController = Get.find<AuthController>();

    await Future.delayed(Duration(seconds: 1));

    // Get version info
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String platform = Platform.isAndroid ? 'android' : 'ios';
    // Fetch app config
    final configResponse = await authController.checkAppConfig(platform, version);

    if (configResponse != null) {
      final config= configResponse['data'];
      if (config['update_required'] == true) {
        String url = Platform.isAndroid ? config['playstore_link'] : config['appstore_link'];
        _showUpdateDialog(context, config['message'], url);
        return;
      }
      if (config['debug_mode'] == true) {
        _showErrorDialog(context, 'Sorry for the inconvenience. The application is currently undergoing maintenance. Please try again later.');
        return;
      }
    }

    // You can use config['debug_mode'] to toggle debug logs or banners

    await authController.checkLoginStatus();

    if (authController.isLoggedIn.value) {
      Get.offNamed(Routes.DASHBOARD);
      // Get.offNamed(Routes.DASHBOARD);
    } else {
      Get.offNamed(Routes.LOGIN);
    }
  }

  void _showUpdateDialog(BuildContext context, String message, String url) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text("Update Required"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () async {
              if (await canLaunch(url)) {
                await launch(url);
              }
            },
            child: Text("Update Now"),
          ),
        ],
      ),
    );
  }


  void _showErrorDialog(BuildContext context, String message) {
    Get.snackbar(
      "Message",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
      icon: Icon(Icons.error_outline, color: Colors.white),
      borderRadius: 12,
      margin: EdgeInsets.all(16),
      isDismissible: false,
      duration: Duration(days: 1), // Persistent until manually exited
      mainButton: TextButton(
        onPressed: () {
          exit(0); // Exit app
        },
        child: Text(
          "Exit",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}