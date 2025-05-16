import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_delivery_br/app/app_colors.dart' show AppColors;
import 'package:home_delivery_br/modules/auth/controllers/auth_controller.dart';
import 'package:home_delivery_br/routes/app_pages.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user from AuthController
    final authController = Get.find<AuthController>();
    final user = authController.user;

    return Drawer(
      child: Column(
        children: [
          // User Profile Section
          UserAccountsDrawerHeader(
            accountName: Text(
              user.value?.name ?? 'Guest',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              user.value?.email ?? 'no-email@example.com',
              style: const TextStyle(fontSize: 14),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: ClipOval(
                child: user.value?.photoUrl != null
                    ? Image.network(
                  user.value!.photoUrl!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                )
                    : const Icon(
                  Icons.person,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
            ),
            decoration: const BoxDecoration(
              color: AppColors.primary,
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.home, color: AppColors.primary),
                  title: const Text('Dashboard'),
                  onTap: () {
                    Get.offAllNamed(Routes.DASHBOARD);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.add, color: AppColors.primary),
                  title: const Text('Place Order'),
                  onTap: () {
                    Get.offAllNamed(Routes.CREATE_ORDER);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.shopping_cart, color: AppColors.primary),
                  title: const Text('My Orders'),
                  onTap: () {
                    Get.offAllNamed(Routes.ORDERS);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.local_shipping, color: AppColors.primary),
                  title: const Text('Tracking'),
                  onTap: () {
                    Get.offAllNamed(Routes.TRACKINGS);
                  },
                ),
              ],
            ),
          ),

          // Logout Button
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 8, 25, 50),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.red),
                ),
                onPressed: () {
                  authController.logout();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}