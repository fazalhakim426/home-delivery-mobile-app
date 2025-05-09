import 'package:get/get.dart';
import 'package:home_delivery_br/data/repositories/auth_repository.dart';
import 'package:home_delivery_br/modules/auth/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepository());

    Get.lazyPut<AuthController>(
      () => AuthController(authRepository: Get.find()),
    );
  }
}
