import 'package:get/get.dart';
import 'package:simpl/modules/auth/bindings/auth_binding.dart';
import 'package:simpl/modules/auth/views/login_view.dart';
import 'package:simpl/modules/auth/views/register_view.dart';
import 'package:simpl/modules/auth/views/verification_view.dart';
import 'package:simpl/modules/home/bindings/home_binding.dart';
import 'package:simpl/modules/home/views/home_view.dart';
import 'package:simpl/modules/todo/bindings/todo_binding.dart';
import 'package:simpl/modules/todo/views/todo_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.VERIFICATION,
      page: () => const VerificationView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.TODO,
      page: () => const TodoView(),
      binding: TodoBinding(),
    ),
  ];
}
