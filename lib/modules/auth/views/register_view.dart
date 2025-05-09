import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simpl/modules/auth/controllers/auth_controller.dart';
import 'package:simpl/routes/app_pages.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Create Account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller.nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: const Icon(Icons.person, color: Colors.purple),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.purple, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email, color: Colors.purple),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.purple, width: 2),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock, color: Colors.purple),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.purple, width: 2),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            Obx(
              () => ElevatedButton(
                onPressed:
                    controller.isLoading.value
                        ? null
                        : () => controller.register(),
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
                          'Register',
                          style: TextStyle(fontSize: 16),
                        ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Get.toNamed(Routes.LOGIN),
              child: const Text(
                'Already have an account? Login',
                style: TextStyle(color: Colors.purple),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
