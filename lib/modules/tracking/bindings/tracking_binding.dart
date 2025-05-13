import 'package:get/get.dart';
import 'package:home_delivery_br/data/repositories/tracking_respository.dart';
import 'package:home_delivery_br/modules/tracking/controllers/tracking_controller.dart';
class TrackingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrackingRepository>(() => TrackingRepository());
    Get.lazyPut<TrackingController>(() => TrackingController(repository: Get.find()));
  }
}

