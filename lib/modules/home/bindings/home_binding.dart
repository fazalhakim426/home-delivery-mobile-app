import 'package:get/get.dart';
import 'package:simpl/modules/auth/controllers/auth_controller.dart';
import 'package:simpl/modules/todo/controllers/todo_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure controllers are initialized
    Get.find<AuthController>();
    Get.lazyPut<TodoController>(
          () => TodoController(todoRepository: Get.find()),
    );

  }
}
