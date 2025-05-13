import 'package:get/get.dart';
import 'package:home_delivery_br/SplashScreen.dart';
import 'package:home_delivery_br/modules/auth/bindings/auth_binding.dart';
import 'package:home_delivery_br/modules/auth/views/login_view.dart';
import 'package:home_delivery_br/modules/auth/views/register_view.dart';
import 'package:home_delivery_br/modules/auth/views/verification_view.dart';
import 'package:home_delivery_br/modules/order/bindings/order_view_binding.dart';
import 'package:home_delivery_br/modules/order/bindings/order_create_binding.dart';
import 'package:home_delivery_br/modules/order/views/order_create_view.dart';
import 'package:home_delivery_br/modules/order/views/order_view.dart';
import 'package:home_delivery_br/modules/tracking/bindings/tracking_binding.dart';
import 'package:home_delivery_br/modules/tracking/views/tracking_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.Splash;

  static final routes = [
    GetPage(
        name: Routes.Splash,
        page: () => SplashScreen()
    ),
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
      name: Routes.TRACKINGS,
      page: () => const TrackingView(),
      binding: TrackingBinding(),
    ),
    GetPage(
      name: Routes.ORDERS,
      page: () => const OrderView(),
      bindings : [
        AuthBinding(),
        OrderViewBinding(),
      ],
    ),
    GetPage(
      name: Routes.CREATE_ORDER,
      page: () => const OrderCreateView(),
      binding: OrderCreateBinding(),
    ),
  ];
}
