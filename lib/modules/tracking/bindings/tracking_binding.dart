import 'package:get/get.dart';
import 'package:simpl/data/repositories/tracking_respository.dart';
import 'package:simpl/modules/tracking/controllers/tracking_controller.dart';
class TrackingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrackingRepository>(() => TrackingRepository());
    Get.lazyPut<TrackingController>(() => TrackingController(repository: Get.find()));
  }
}

