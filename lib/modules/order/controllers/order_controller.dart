import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simpl/data/models/ServiceModel.dart';
import 'package:simpl/data/models/order_model.dart';
import 'package:simpl/data/repositories/order_repository.dart';
import 'package:simpl/data/services/form_persistence_service.dart';
import 'package:simpl/modules/order/controllers/ProductFormModel.dart';

class OrderController extends GetxController {
  final RxList<ProductFormModel> products = <ProductFormModel>[].obs;

  final OrderRepository _orderRepository;
  final _formService = Get.find<FormPersistenceService>();

  OrderController({required OrderRepository orderRepository})
      : _orderRepository = orderRepository {
    _setupControllerListeners();
  }

  final senderLastNameController = TextEditingController();
  final senderEmailController = TextEditingController();
  final senderFirstNameController = TextEditingController();
  final senderTaxIdController = TextEditingController();
  final senderCountryIdController = TextEditingController();
  final senderWebsiteController = TextEditingController();
  // Add step management
  final currentStep = 0.obs;
  final basicInfoFormKey = GlobalKey<FormState>();
  final parcelDetailsFormKey = GlobalKey<FormState>();
  final senderRecipientFormKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  final orders = <Order>[].obs;
  final fieldErrors = RxMap<String, String>({});
  final RxnString taxModality = RxnString();
  final RxnInt selectedServiceId = RxnInt();
  final serviceController = TextEditingController();
  final trackingIdController = TextEditingController();
  final customerReferenceController = TextEditingController();
  final weightController = TextEditingController();
  final shipmentValueController = TextEditingController();
  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final heightController = TextEditingController();
  final recipientFirstNameController = TextEditingController();
  final recipientLastNameController = TextEditingController();
  final recipientCityController = TextEditingController();
  final recipientTaxIdController = TextEditingController();
  final recipientEmailController = TextEditingController();
  final recipientStreetNoController = TextEditingController();
  final recipientAddressController = TextEditingController();
  final recipientAddress2Controller = TextEditingController();
  final recipientAccountTypeController = TextEditingController();
  final recipientStateIdController = TextEditingController();
  final recipientCountryIdController = TextEditingController();
  final recipientZipCodeController = TextEditingController();
  final recipientPhoneController = TextEditingController();
  final List<Service> services = [
    Service(id: 1, name: 'Standard  '),
    Service(id: 2, name: 'Express Delivery'),
    // Add more as needed
  ];

  // Selected order for editing
  final selectedOrder = Rxn<Order>();

  void _setupControllerListeners() {
    _removeListeners();

    trackingIdController.addListener(_debouncedSaveForm);
    customerReferenceController.addListener(_debouncedSaveForm);
    weightController.addListener(_debouncedSaveForm);
    shipmentValueController.addListener(_debouncedSaveForm);
    lengthController.addListener(_debouncedSaveForm);
    widthController.addListener(_debouncedSaveForm);
    heightController.addListener(_debouncedSaveForm);
    senderFirstNameController.addListener(_debouncedSaveForm);
    senderLastNameController.addListener(_debouncedSaveForm);
    senderEmailController.addListener(_debouncedSaveForm);
    recipientFirstNameController.addListener(_debouncedSaveForm);
    recipientLastNameController.addListener(_debouncedSaveForm);
    recipientEmailController.addListener(_debouncedSaveForm);
    recipientPhoneController.addListener(_debouncedSaveForm);
  }

  Timer? _debounceTimer;
  void _debouncedSaveForm() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _saveFormData();
    });
  }

  void _removeListeners() {
    trackingIdController.removeListener(_debouncedSaveForm);
    customerReferenceController.removeListener(_debouncedSaveForm);
    weightController.removeListener(_debouncedSaveForm);
    shipmentValueController.removeListener(_debouncedSaveForm);
    lengthController.removeListener(_debouncedSaveForm);
    widthController.removeListener(_debouncedSaveForm);
    heightController.removeListener(_debouncedSaveForm);
    senderFirstNameController.removeListener(_debouncedSaveForm);
    senderLastNameController.removeListener(_debouncedSaveForm);
    senderEmailController.removeListener(_debouncedSaveForm);
    recipientFirstNameController.removeListener(_debouncedSaveForm);
    recipientLastNameController.removeListener(_debouncedSaveForm);
    recipientEmailController.removeListener(_debouncedSaveForm);
    recipientPhoneController.removeListener(_debouncedSaveForm);
  }

  @override
  void onInit() {
    super.onInit();
    // Load saved data immediately when controller is initialized
    _loadSavedFormData();
    fetchOrders();
    // Optionally set a default selected service
    if (services.isNotEmpty) {
      selectedServiceId.value = services.first.id;
    }
    taxModality.value = 'DDU';
  }

  void _loadSavedFormData() {
    final savedData = _formService.getOrderFormData();
    if (savedData != null) {
      trackingIdController.text = savedData['trackingId'] ?? '';
      customerReferenceController.text = savedData['customerReference'] ?? '';
      weightController.text = savedData['weight'] ?? '';
      shipmentValueController.text = savedData['shipmentValue'] ?? '';
      lengthController.text = savedData['length'] ?? '';
      widthController.text = savedData['width'] ?? '';
      heightController.text = savedData['height'] ?? '';
      senderFirstNameController.text = savedData['senderFirstName'] ?? '';
      senderLastNameController.text = savedData['senderLastName'] ?? '';
      senderEmailController.text = savedData['senderEmail'] ?? '';
      recipientFirstNameController.text = savedData['recipientFirstName'] ?? '';
      recipientLastNameController.text = savedData['recipientLastName'] ?? '';
      recipientEmailController.text = savedData['recipientEmail'] ?? '';
      recipientPhoneController.text = savedData['recipientPhone'] ?? '';
    }
  }

  Future<void> _saveFormData() async {
    final formData = {
      'trackingId': trackingIdController.text,
      'customerReference': customerReferenceController.text,
      'weight': weightController.text,
      'shipmentValue': shipmentValueController.text,
      'length': lengthController.text,
      'width': widthController.text,
      'height': heightController.text,
      'senderFirstName': senderFirstNameController.text,
      'senderLastName': senderLastNameController.text,
      'senderEmail': senderEmailController.text,
      'recipientFirstName': recipientFirstNameController.text,
      'recipientLastName': recipientLastNameController.text,
      'recipientEmail': recipientEmailController.text,
      'recipientPhone': recipientPhoneController.text,
    };
    await _formService.saveOrderFormData(formData);
  }


  // Fetch all orders
  Future<void> fetchOrders() async {
    isLoading.value = true;
    try {
      final orderList = await _orderRepository.getAllOrders();
      orders.assignAll(orderList);
    } catch (e) {
      print(e.toString());
      Get.snackbar(
        'Error',
        'Failed to fetch orders: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Add new order
  Future<void> addOrder() async {
    isLoading.value = true;

    try {
      final orderData = {
        "parcel": {
          "service_id": selectedServiceId.value,
          "merchant": recipientFirstNameController.text,
          "carrier": "Carrier",
          "tracking_id": trackingIdController.text,
          "customer_reference": trackingIdController.text,
          "measurement_unit": "kg/cm",
          "weight": weightController.text,
          "length": lengthController.text,
          "width": widthController.text,
          "height": heightController.text,
          "tax_modality": "DDU",
          "shipment_value": shipmentValueController.text,
        },
        "sender": {
          "sender_first_name": senderFirstNameController.text,
          "sender_last_name": senderLastNameController.text,
          "sender_email": senderEmailController.text,
          "sender_taxId": senderTaxIdController.text,
          "sender_country_id": senderCountryIdController.text,
          "sender_website": senderWebsiteController.text,
        },
        "recipient": {
          "first_name": recipientFirstNameController.text,
          "last_name": recipientLastNameController.text,
          "email": recipientEmailController.text,
          "phone": recipientPhoneController.text,
          "tax_id": recipientTaxIdController.text,
          "city": recipientCityController.text,
          "street_no": recipientStreetNoController.text,
          "address": recipientAddressController.text,
          "address2": recipientAddress2Controller.text,
          "account_type": recipientAccountTypeController.text,
          "zipcode": recipientZipCodeController.text,
          "state_id": recipientStateIdController.text,
          "country_id": recipientCountryIdController.text,
        },


        "products": products.map((p) => p.toProduct().toJson()).toList()
      };

      print('Sending to API:');
      print(orderData);

      final createdOrder = await _orderRepository.createOrder(orderData);
      orders.add(createdOrder);
      // clearForm();
      Get.back(); // Close the add order dialog/screen
        Get.snackbar(
          'Success',
          'Order added successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
    } catch (e) {
      if (e is Map<String, String>) {
        fieldErrors.assignAll(e); // update UI
      }
      Get.snackbar(
        'Invalid data',
        'Failed to add order: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update order
  Future<void> updateOrder() async {
    if (selectedOrder.value == null) {
      Get.snackbar(
        'Error',
        'No order selected for update',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
    //   Get.snackbar(
    //     'Error',
    //     'Title and description are required',
    //     snackPosition: SnackPosition.BOTTOM,
    //   );
    //   return;
    // }

    isLoading.value = true;
    try {
      final updatedOrder = selectedOrder.value!.copyWith();

      final result = await _orderRepository.updateOrder(updatedOrder);

      // Update order in the list
      final index = orders.indexWhere((order) => order.id == result.id);
      if (index != -1) {
        orders[index] = result;
      }

      clearForm();

      Get.back(); // Close the edit order dialog/screen
      Get.snackbar(
        'Success',
        'Order updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update order: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
      selectedOrder.value = null;
    }
  }

  // Delete order
  Future<void> deleteOrder(int id) async {
    isLoading.value = true;
    try {
      final success = await _orderRepository.deleteOrder(id);

      if (success) {
        orders.removeWhere((order) => order.id == id);
        Get.snackbar(
          'Success',
          'Order deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete order: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle order completion
  Future<void> toggleOrderCompletion(Order order) async {
    try {
      final updatedOrder = await _orderRepository.toggleOrderCompletion(order);

      // Update order in the list
      final index = orders.indexWhere((t) => t.id == updatedOrder.id);
      if (index != -1) {
        orders[index] = updatedOrder;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update order: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Set selected order for editing
  void selectOrderForEdit(Order order) {
    selectedOrder.value = order;
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    _removeListeners();
    trackingIdController.dispose();
    customerReferenceController.dispose();
    weightController.dispose();
    shipmentValueController.dispose();
    lengthController.dispose();
    widthController.dispose();
    heightController.dispose();
    senderEmailController.dispose();
    recipientEmailController.dispose();
    recipientPhoneController.dispose();
    super.onClose();
  }

  void clearForm() {
    // Only clear form data if explicitly requested
    currentStep.value = 0;
    trackingIdController.clear();
    customerReferenceController.clear();
    weightController.clear();
    shipmentValueController.clear();
    lengthController.clear();
    widthController.clear();
    heightController.clear();
    senderEmailController.clear();
    recipientEmailController.clear();
    recipientPhoneController.clear();
    selectedOrder.value = null;
    _formService.clearOrderFormData();
  }

  void nextStep() {
    bool isValid = false;
    switch (currentStep.value) {
      case 0:
        isValid = basicInfoFormKey.currentState?.validate() ?? false;
        break;
      case 1:
        isValid = senderRecipientFormKey.currentState?.validate() ?? false;
        break;
      case 2:
        isValid = parcelDetailsFormKey.currentState?.validate() ?? false;
        break;
    }

    if (isValid && currentStep.value < 2) {
      _saveFormData(); // Save form data when moving to next step
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  String? validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  void addProduct() {
    final newProduct = ProductFormModel();
    products.add(newProduct);
    products.refresh(); // Force UI update
  }

  void removeProduct(int index) {
    if (index >= 0 && index < products.length) {
      products[index].dispose();
      products.removeAt(index);
      products.refresh(); // Force UI update
    }
  }
}

