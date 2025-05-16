import 'package:get/get.dart';
import 'package:home_delivery_br/data/repositories/dashboard_repository.dart';
import 'package:home_delivery_br/modules/dashboard/controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardRepository>(() => DashboardRepository());

    Get.lazyPut<DashboardController>(
      () => DashboardController(dashboardRepository: Get.find()),
    );
  }
}
