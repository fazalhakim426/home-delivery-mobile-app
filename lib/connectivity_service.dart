import 'dart:async';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';


class ConnectivityService extends GetxService {
  final RxBool isConnected = true.obs;
  late StreamSubscription<InternetConnectionStatus> _listener;

  Future<ConnectivityService> init() async {
    _listener = InternetConnectionChecker().onStatusChange.listen((status) {
      isConnected.value = status == InternetConnectionStatus.connected;
    });
    // Initial check
    isConnected.value = await InternetConnectionChecker().hasConnection;
    return this;
  }

  @override
  void onClose() {
    _listener.cancel();
    super.onClose();
  }
}

