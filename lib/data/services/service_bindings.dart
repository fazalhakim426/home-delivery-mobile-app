import 'package:get/get.dart';

import 'form_persistence_service.dart';

class ServiceBindings {
  static Future<void> init() async {
    // Initialize FormPersistenceService using the static init method
    final formService = await FormPersistenceService.init();
    Get.put(formService);
  }
}
