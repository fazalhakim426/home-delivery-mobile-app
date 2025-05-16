import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_delivery_br/modules/auth/controllers/auth_controller.dart';
import 'package:home_delivery_br/modules/order/controllers/validators/order_validators.dart';
import 'package:home_delivery_br/app/app_colors.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 200,
                    child: Image.asset(
                      'assets/splash_logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Text('Image failed to load');
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: controller.emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email, color: AppColors.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (_) => controller.update(),
                    validator: OrderValidators.validateRequired,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock, color: AppColors.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                    obscureText: true,
                    onChanged: (_) => controller.update(),
                    validator: OrderValidators.validateRequired,
                  ),
                  const SizedBox(height: 24),
                  Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                      if (_formKey.currentState!.validate()) {
                        controller.login();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18), // Increased vertical padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Slightly more rounded
                      ),
                      elevation: 4, // Subtle shadow
                      shadowColor: AppColors.primary.withOpacity(0.3), // Soft shadow color
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3, // Thicker loader
                    )
                        : const Text(
                      'LOGIN', // Uppercase for better visibility
                      style: TextStyle(
                        fontSize: 18, // Larger font
                        fontWeight: FontWeight.w700, // Bold
                        letterSpacing: 0.5, // Slightly spaced letters
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}