import 'package:get/get.dart';
import 'package:home_delivery_br/data/repositories/order_repository.dart';
import 'package:home_delivery_br/modules/order/controllers/order_create_controller.dart';

class OrderCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderRepository>(() => OrderRepository());
    Get.put<OrderCreateController>(
      OrderCreateController(orderRepository: Get.find()),
      permanent: false, // Keep controller instance alive
    );
  }
}
