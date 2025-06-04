import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_delivery_br/app/app_colors.dart' show AppColors;
import 'package:home_delivery_br/modules/auth/controllers/auth_controller.dart';
import 'package:home_delivery_br/routes/app_pages.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final user = authController.user;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Enhanced User Profile Section
            UserAccountsDrawerHeader(
              accountName: Text(
                user.value?.name ?? 'Guest',
                style: const TextStyle(
                  fontSize: 20, // Increased size
                  fontWeight: FontWeight.w700, // Bolder
                  letterSpacing: 0.3, // Better readability
                ),
              ),
              accountEmail: Text(
                user.value?.email ?? 'no-email@example.com',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500, // Medium weight
                ),
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

            // Menu Items with improved styling
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    icon: Icons.home,
                    title: 'Dashboard',
                    route: Routes.DASHBOARD,
                  ),
                  _buildDrawerItem(
                    icon: Icons.add,
                    title: 'Place Order',
                    route: Routes.CREATE_ORDER,
                  ),
                  _buildDrawerItem(
                    icon: Icons.shopping_cart,
                    title: 'Orders',
                    route: Routes.ORDERS,
                  ),
                  _buildDrawerItem(
                    icon: Icons.local_shipping,
                    title: 'Tracking',
                    route: Routes.TRACKINGS,
                  ),
                ],
              ),
            ),

            // Enhanced Logout Button
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 8, 25, 25),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout, size: 20),
                  label: const Text(
                    'LOGOUT',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[50], // Light red background
                    foregroundColor: Colors.red, // Red text and icon
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    side: BorderSide(color: Colors.red.shade300, width: 1.5),
                  ),
                  onPressed: () {
                    authController.logout();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for consistent drawer items
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required String route,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () {
        Get.offAllNamed(route);
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      dense: true,
    );
  }
}