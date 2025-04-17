import 'package:get/get.dart';
import 'package:simpl/data/repositories/todo_repository.dart';
import 'package:simpl/modules/todo/controllers/todo_controller.dart';

class TodoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TodoRepository>(() => TodoRepository());

    Get.lazyPut<TodoController>(
      () => TodoController(todoRepository: Get.find()),
    );
  }
}
