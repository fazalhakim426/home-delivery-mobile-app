import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simpl/modules/auth/controllers/auth_controller.dart';
import 'package:simpl/routes/app_pages.dart';

class HomeView extends GetView<AuthController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => controller.logout(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(
              () => Text(
                'Welcome, ${controller.user.value?.name ?? 'User'}!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              label: const Text(
                'Order list',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => Get.toNamed(Routes.TODO),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white, // Sets text/icon color if not overridden
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.local_shipping, color: Colors.white),
              label: const Text(
                'Order Tracking',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => (),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white, // Sets text/icon color if not overridden
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'App Features:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(Icons.shopping_cart, 'Place order'),
            _buildFeatureItem(Icons.local_shipping, 'Track order'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.indigo),
          const SizedBox(width: 16),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
