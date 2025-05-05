import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simpl/app/app_colors.dart';
import 'package:simpl/data/providers/api_provider.dart';
import 'package:simpl/data/repositories/auth_repository.dart';
import 'package:simpl/data/services/form_persistence_service.dart';
import 'package:simpl/modules/auth/bindings/auth_binding.dart';
import 'package:simpl/modules/auth/controllers/auth_controller.dart';
import 'package:simpl/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize API Provider
  await Get.putAsync(() => ApiProvider().init());

  // Initialize FormPersistenceService
  final formService = await FormPersistenceService.init();
  Get.put(formService);

  Get.put(AuthController(authRepository: AuthRepository()));
  runApp(
    GetMaterialApp(
      title: 'HomeDelivery BR',
      initialBinding: AuthBinding(),
      theme: ThemeData(
        useMaterial3: true,

        primaryColor: AppColors.primary, // set primary color
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
    ),
  );
}
