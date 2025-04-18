import 'package:get/get.dart';
import 'package:simpl/modules/auth/controllers/auth_controller.dart';
import 'package:simpl/modules/order/controllers/order_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Register AuthController first
    Get.lazyPut<AuthController>(
          () => AuthController(authRepository: Get.find()),
    );
    // Now Get.find will work
    Get.lazyPut<OrderController>(
          () => OrderController(orderRepository: Get.find()),
    );
  }
}
