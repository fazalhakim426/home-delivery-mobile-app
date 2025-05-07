import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simpl/data/models/CountryModel.dart';
import 'package:simpl/data/models/CountryStateModel.dart';
import 'package:simpl/data/models/ServiceModel.dart';
import 'package:dio/dio.dart' as dio;
import 'package:simpl/data/models/ShCodeModel.dart';
import 'package:simpl/data/repositories/order_repository.dart';
import 'package:simpl/modules/order/controllers/recipient_controller.dart';

class ParcelController extends GetxController {

  final OrderRepository _orderRepository= new OrderRepository();
  final trackingIdController = TextEditingController();
  final customerReferenceController = TextEditingController();
  final weightController = TextEditingController();
  final shipmentValueController = TextEditingController();
  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final heightController = TextEditingController();



  final List<Country> countries = [
    Country(id: 1, name: 'Brazil',code:'BR'),
  ];
  final List<CountryState> recipientStates = [
  ];

  final isLoading = false.obs;

  final RxnString taxModality = RxnString('DDU');
  final RxnInt selectedServiceId = RxnInt();
  final RxMap<String, String> fieldErrors = <String, String>{}.obs;

  final List<Service> services = [
    Service(id: 1, name: 'Standard Delivery')
  ];
  final List<ShCode> shCodes = [
    ShCode(code: 610799, description: "jamas"),
    ShCode(code: 620590, description: "Vestuário")
  ];

  @override
  void onInit() {
    super.onInit();
    if (services.isNotEmpty) {
      selectedServiceId.value = services.first.id;
    }
    fetchShippingServices();
    fetchShCodes();

  }

  @override
  void onClose() {
    // trackingIdController.dispose();
    // customerReferenceController.dispose();
    // weightController.dispose();
    // shipmentValueController.dispose();
    // lengthController.dispose();
    // widthController.dispose();
    // heightController.dispose();
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
      "merchant": Get.find<RecipientController>().firstNameController.text,
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

  Future<void> fetchShippingServices() async{
    isLoading.value = true;
    try {
      final serviceList = await _orderRepository.getAllServices();
      services.assignAll(serviceList);
    } catch (e) {
        print(e.toString());
        Get.snackbar('Error', 'Failed to fetch orders: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }

  }
  Future<void> fetchShCodes() async {
    isLoading.value = true;
    try {
      final shCodesList = await _orderRepository.getAllShCodes();
      shCodes.assignAll(shCodesList);
    } catch (e) {
      print(e.toString());
        Get.snackbar('Error', 'Failed to fetch shCode: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}