import 'dart:async';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
class ConnectivityService extends GetxService {
  final RxBool isConnected = true.obs;
  final RxBool isInitialized = false.obs; // Add this line
  late StreamSubscription<InternetConnectionStatus> _listener;

  Future<ConnectivityService> init() async {
    // Initial check
    isConnected.value = await InternetConnectionChecker().hasConnection;
    isInitialized.value = true; // Set to true after first check

    _listener = InternetConnectionChecker().onStatusChange.listen((status) {
      isConnected.value = status == InternetConnectionStatus.connected;
    });

    return this;
  }

  @override
  void onClose() {
    _listener.cancel();
    super.onClose();
  }
}