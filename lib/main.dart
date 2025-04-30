import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simpl/data/providers/api_provider.dart';
import 'package:simpl/data/services/form_persistence_service.dart';
import 'package:simpl/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize API Provider
  await Get.putAsync(() => ApiProvider().init());

  // Initialize FormPersistenceService
  final formService = await FormPersistenceService.init();
  Get.put(formService);

  runApp(
    GetMaterialApp(
      title: 'HomeDelivery BR',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      defaultTransition: Transition.fade,
    ),
  );
}
