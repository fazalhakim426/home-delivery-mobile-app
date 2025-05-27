import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_delivery_br/app/app_colors.dart';
import 'package:home_delivery_br/connectivity_service.dart';
import 'package:home_delivery_br/data/providers/api_provider.dart';
import 'package:home_delivery_br/data/repositories/auth_repository.dart';
import 'package:home_delivery_br/data/services/form_persistence_service.dart';
import 'package:home_delivery_br/modules/auth/bindings/auth_binding.dart';
import 'package:home_delivery_br/modules/auth/controllers/auth_controller.dart';
import 'package:home_delivery_br/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize API Provider
  await Get.putAsync(() => ApiProvider().init());

  // Initialize FormPersistenceService
  final formService = await FormPersistenceService.init();
  Get.put(formService);

  // Initialize ConnectivityService
  await Get.putAsync(() => ConnectivityService().init());

  Get.put(AuthController(authRepository: AuthRepository()));

  runApp(
    GetMaterialApp(
      title: 'HomeDelivery BR',
      initialBinding: AuthBinding(),
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      defaultTransition: Transition.fade,
      builder: (context, child) {
        final connectivity = Get.find<ConnectivityService>();
        return Stack(
          children: [
            child!,
            Obx(() {
              if (connectivity.isConnected.value) return const SizedBox();

              return Positioned(
                top: 0, // Position below app bar
                left: 0,
                right: 0,
                child: SafeArea(
                  bottom: false,
                  child: Material(
                    elevation: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.red[400],
                        gradient: LinearGradient(
                          colors: [Colors.red[600]!, Colors.red[400]!],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.wifi_off,
                              color: Colors.white, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'No internet connection',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    ),
  );
}