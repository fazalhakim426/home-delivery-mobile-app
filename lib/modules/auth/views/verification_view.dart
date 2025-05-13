import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_delivery_br/modules/auth/controllers/auth_controller.dart';

class VerificationView extends GetView<AuthController> {
  const VerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Email Verification',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'We\'ve sent a verification code to your email. Please enter it below to verify your account.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: controller.verificationCodeController,
              decoration: InputDecoration(
                labelText: 'Verification Code',
                prefixIcon: const Icon(Icons.code, color: Colors.purple),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.purple, width: 2),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            Obx(
              () => ElevatedButton(
                onPressed:
                    controller.isLoading.value
                        ? null
                        : () => controller.verifyEmail(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child:
                    controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          'Verify Email',
                          style: TextStyle(fontSize: 16),
                        ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                'Resend Code',
                style: TextStyle(color: Colors.purple),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
