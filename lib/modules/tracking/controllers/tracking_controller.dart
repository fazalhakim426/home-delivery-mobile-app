import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_delivery_br/data/models/tracking_model.dart';
import 'package:home_delivery_br/data/repositories/tracking_respository.dart';
import 'package:home_delivery_br/modules/tracking/controllers/tracking_controller.dart';
import 'package:intl/intl.dart';


class TrackingController extends GetxController {
  final TrackingRepository repository;

  TrackingController({required this.repository});

  Rx<Tracking?> tracking = Rx<Tracking?>(null);
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchTracking(String trackingCode) async {
    try {
      isLoading.value = true;
      final result = await repository.getTracking(trackingCode);
      tracking.value = result;

    } catch (e) {
      print('Error in fetchTracking: $e');
      Get.snackbar("Error", "Failed to load tracking data: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError);
    } finally {
      isLoading.value = false;
    }
  }

}