import 'package:get/get.dart';
import 'package:simpl/data/repositories/order_repository.dart';
import 'package:simpl/modules/order/controllers/order_controller.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderRepository>(() => OrderRepository());

    Get.lazyPut<OrderController>(
      () => OrderController(orderRepository: Get.find()),
    );
  }
}
