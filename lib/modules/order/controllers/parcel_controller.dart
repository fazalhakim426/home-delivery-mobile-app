import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_delivery_br/data/models/CountryModel.dart';
import 'package:home_delivery_br/data/models/CountryStateModel.dart';
import 'package:home_delivery_br/data/models/ServiceModel.dart';
import 'package:home_delivery_br/data/models/ShCodeModel.dart';
import 'package:home_delivery_br/data/repositories/order_repository.dart';
import 'package:home_delivery_br/modules/order/controllers/recipient_controller.dart';

class ParcelController extends GetxController {
  final OrderRepository _orderRepository = OrderRepository();
  final trackingIdController = TextEditingController();
  final customerReferenceController = TextEditingController();
  final weightController = TextEditingController();
  final shipmentValueController = TextEditingController();
  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final heightController = TextEditingController();

  final List<CountryState> recipientStates = [];
  final List<CountryState> senderStates = [];

  final isLoading = false.obs;

  final RxnString taxModality = RxnString('ddu');
  final RxnInt selectedServiceId = RxnInt();
  final RxMap<String, String> fieldErrors = <String, String>{}.obs;

  final RxList<Country> countries = <Country>[].obs; // Changed to RxList
  final RxList<Service> services = <Service>[].obs; // Changed to RxList
  final RxList<ShCode> shCodes = <ShCode>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    try {
      await Future.wait([
        fetchShippingServices(),
        fetchShCodes(),
      ]);
    } catch (e) {
      // Get.snackbar('Error', 'Failed to load initial data: ${e.toString()}');
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  void clear() {
    trackingIdController.clear();
    customerReferenceController.clear();
    weightController.clear();
    shipmentValueController.clear();
    lengthController.clear();
    widthController.clear();
    heightController.clear();
    fieldErrors.clear();
  }

  Map<String, dynamic> toJson() {
    return {
      "service_id": selectedServiceId.value,
      "carrier": "Carrier",
      "tracking_id": trackingIdController.text,
      "customer_reference": trackingIdController.text,
      "measurement_unit": "kg/cm",
      "weight": weightController.text,
      "length": lengthController.text,
      "width": widthController.text,
      "height": heightController.text,
      "tax_modality": taxModality.value,
      "shipment_value": shipmentValueController.text,
    };
  }

  Future<void> fetchShippingServices() async {
    // isLoading.value = true;
    try {
      final serviceList = await _orderRepository.getAllServices();
      services.assignAll(serviceList);
    } catch (e) {
      // Get.snackbar('Error', 'Failed to fetch services: ${e.toString()}',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Get.theme.colorScheme.primary,
      //   colorText: Get.theme.colorScheme.onPrimary);
    } finally {
      // isLoading.value = false;
    }
  }

  Future<void> fetchShCodes() async {
    // isLoading.value = true;
    try {
      final shCodesList = await _orderRepository.getAllShCodes();
      final seen = <dynamic>{};
      final duplicates = <dynamic>{};

      for (var code in shCodesList) {
        if (!seen.add(code)) {
          duplicates.add(code);
        }
      }

      if (duplicates.isNotEmpty) {
        // print('Duplicate shCodes detected: $duplicates');
      }

      shCodes.assignAll(shCodesList);
    } catch (e) {
      // print(e.toString());
      // Get.snackbar('Error', 'Failed to fetch shCodes: ${e.toString()}');
    } finally {
      // isLoading.value = false;
    }
  }
}