import 'package:get/get.dart';
import 'package:simpl/data/repositories/order_repository.dart';
import 'package:simpl/modules/order/controllers/order_create_controller.dart';
import 'package:simpl/modules/order/controllers/order_view_controller.dart';

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
