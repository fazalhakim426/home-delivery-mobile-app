import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simpl/data/models/tracking_model.dart';
import 'package:simpl/data/repositories/tracking_respository.dart';
import 'package:simpl/modules/tracking/controllers/tracking_controller.dart';
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
      Get.snackbar("Error", "Failed to load tracking data: $e");
    } finally {
      isLoading.value = false;
    }
  }

}