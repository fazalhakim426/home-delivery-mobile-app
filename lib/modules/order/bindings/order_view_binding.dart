import 'package:get/get.dart';
import 'package:home_delivery_br/data/repositories/order_repository.dart';
import 'package:home_delivery_br/modules/order/controllers/order_create_controller.dart';
import 'package:home_delivery_br/modules/order/controllers/order_view_controller.dart';

class OrderViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderRepository>(() => OrderRepository());
    Get.put<OrderViewController>(
      OrderViewController(orderRepository: Get.find()),
      permanent: true, // Keep controller instance alive
    );
  }
}
