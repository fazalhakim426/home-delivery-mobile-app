import 'package:flutter/services.dart'; // Add this import
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
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: connectivity.isConnected.value
              ? SystemUiOverlayStyle.dark // Default style when connected
              : SystemUiOverlayStyle.light, // Light style (white icons) when disconnected
          child: Stack(
            children: [
              child!,
              Obx(() {
                if (!connectivity.isInitialized.value || connectivity.isConnected.value) {
                  return const SizedBox();
                }

                return Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: MediaQuery.of(context).padding.top,
                    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top > 30 ? 6 : 2),
                    alignment: Alignment.center,
                    color: Colors.red,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wifi_off, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'No internet',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    ),
  );
}