import 'package:get/get.dart';
import 'package:simpl/data/repositories/auth_repository.dart';
import 'package:simpl/modules/auth/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepository());

    Get.lazyPut<AuthController>(
      () => AuthController(authRepository: Get.find()),
    );
  }
}
