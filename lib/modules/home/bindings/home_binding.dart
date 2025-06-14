import 'package:get/get.dart';
import 'package:home_delivery_br/modules/auth/controllers/auth_controller.dart';
import 'package:home_delivery_br/modules/order/controllers/order_create_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Register AuthController first
    Get.lazyPut<AuthController>(
          () => AuthController(authRepository: Get.find()),
    );
    // Now Get.find will work
    Get.lazyPut<OrderCreateController>(
          () => OrderCreateController(orderRepository: Get.find()),
    );
  }
}
