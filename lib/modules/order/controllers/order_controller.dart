import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simpl/data/models/order_model.dart';
import 'package:simpl/data/repositories/order_repository.dart';
import 'package:simpl/data/services/form_persistence_service.dart';

class OrderController extends GetxController {
  final OrderRepository _orderRepository;
  final _formService = Get.find<FormPersistenceService>();

  OrderController({required OrderRepository orderRepository})
      : _orderRepository = orderRepository {
    _setupControllerListeners();
  }

  // Add step management
  final currentStep = 0.obs;
  final basicInfoFormKey = GlobalKey<FormState>();
  final parcelDetailsFormKey = GlobalKey<FormState>();
  final senderRecipientFormKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final orders = <Order>[].obs;
  final fieldErrors = RxMap<String, String>({});

  // Text controllers for adding/editing orders
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final trackingIdController = TextEditingController();
  final customerReferenceController = TextEditingController();
  final weightController = TextEditingController();
  final shipmentValueController = TextEditingController();
  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final heightController = TextEditingController();
  final senderNameController = TextEditingController();
  final senderEmailController = TextEditingController();
  final recipientNameController = TextEditingController();
  final recipientEmailController = TextEditingController();
  final recipientPhoneController = TextEditingController();

  // Selected order for editing
  final selectedOrder = Rxn<Order>();

  void _setupControllerListeners() {
    // Remove existing listeners first to avoid duplicates
    _removeListeners();

    titleController.addListener(_debouncedSaveForm);
    descriptionController.addListener(_debouncedSaveForm);
    trackingIdController.addListener(_debouncedSaveForm);
    customerReferenceController.addListener(_debouncedSaveForm);
    weightController.addListener(_debouncedSaveForm);
    shipmentValueController.addListener(_debouncedSaveForm);
    lengthController.addListener(_debouncedSaveForm);
    widthController.addListener(_debouncedSaveForm);
    heightController.addListener(_debouncedSaveForm);
    senderNameController.addListener(_debouncedSaveForm);
    senderEmailController.addListener(_debouncedSaveForm);
    recipientNameController.addListener(_debouncedSaveForm);
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
    titleController.removeListener(_debouncedSaveForm);
    descriptionController.removeListener(_debouncedSaveForm);
    trackingIdController.removeListener(_debouncedSaveForm);
    customerReferenceController.removeListener(_debouncedSaveForm);
    weightController.removeListener(_debouncedSaveForm);
    shipmentValueController.removeListener(_debouncedSaveForm);
    lengthController.removeListener(_debouncedSaveForm);
    widthController.removeListener(_debouncedSaveForm);
    heightController.removeListener(_debouncedSaveForm);
    senderNameController.removeListener(_debouncedSaveForm);
    senderEmailController.removeListener(_debouncedSaveForm);
    recipientNameController.removeListener(_debouncedSaveForm);
    recipientEmailController.removeListener(_debouncedSaveForm);
    recipientPhoneController.removeListener(_debouncedSaveForm);
  }

  @override
  void onInit() {
    super.onInit();
    // Load saved data immediately when controller is initialized
    _loadSavedFormData();
    fetchOrders();
  }

  void _loadSavedFormData() {
    final savedData = _formService.getOrderFormData();
    if (savedData != null) {
      // Only set text if the field is currently empty
      if (titleController.text.isEmpty) {
        titleController.text = savedData['title'] ?? '';
      }
      if (descriptionController.text.isEmpty) {
        descriptionController.text = savedData['description'] ?? '';
      }
      if (trackingIdController.text.isEmpty) {
        trackingIdController.text = savedData['trackingId'] ?? '';
      }
      if (customerReferenceController.text.isEmpty) {
        customerReferenceController.text = savedData['customerReference'] ?? '';
      }
      if (weightController.text.isEmpty) {
        weightController.text = savedData['weight'] ?? '';
      }
      if (shipmentValueController.text.isEmpty) {
        shipmentValueController.text = savedData['shipmentValue'] ?? '';
      }
      if (lengthController.text.isEmpty) {
        lengthController.text = savedData['length'] ?? '';
      }
      if (widthController.text.isEmpty) {
        widthController.text = savedData['width'] ?? '';
      }
      if (heightController.text.isEmpty) {
        heightController.text = savedData['height'] ?? '';
      }
      if (senderNameController.text.isEmpty) {
        senderNameController.text = savedData['senderName'] ?? '';
      }
      if (senderEmailController.text.isEmpty) {
        senderEmailController.text = savedData['senderEmail'] ?? '';
      }
      if (recipientNameController.text.isEmpty) {
        recipientNameController.text = savedData['recipientName'] ?? '';
      }
      if (recipientEmailController.text.isEmpty) {
        recipientEmailController.text = savedData['recipientEmail'] ?? '';
      }
      if (recipientPhoneController.text.isEmpty) {
        recipientPhoneController.text = savedData['recipientPhone'] ?? '';
      }
    }
  }

  Future<void> _saveFormData() async {
    final formData = {
      'title': titleController.text,
      'description': descriptionController.text,
      'trackingId': trackingIdController.text,
      'customerReference': customerReferenceController.text,
      'weight': weightController.text,
      'shipmentValue': shipmentValueController.text,
      'length': lengthController.text,
      'width': widthController.text,
      'height': heightController.text,
      'senderName': senderNameController.text,
      'senderEmail': senderEmailController.text,
      'recipientName': recipientNameController.text,
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
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Title and description are required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      // final newOrder =
      // Order(
      //   title: titleController.text,
      //   description: descriptionController.text,
      // );
      //
      final orderData = {
        "parcel": {
          "service_id": 1,
          "merchant": "John",
          "carrier": "Carrier",
          "tracking_id": trackingIdController.text,
          "customer_reference": customerReferenceController.text,
          "measurement_unit": "kg/cm",
          "weight": weightController.text,
          "length": lengthController.text,
          "width": widthController.text,
          "height": heightController.text,
          "tax_modality": "DDU",
          "shipment_value": shipmentValueController.text,
        },
        "sender": {
          "sender_first_name": senderNameController.text.split(' ').first,
          "sender_last_name": senderNameController.text.split(' ').length > 1
              ? senderNameController.text.split(' ').last
              : '',
          "sender_email": senderEmailController.text,
          "sender_taxId": "32786897807",
          "sender_country_id": "US",
          "sender_website": "https://dev.homedeliverybr.com"
        },
        "recipient": {
          "first_name": recipientNameController.text.split(' ').first,
          "last_name": recipientNameController.text.split(' ').length > 1
              ? recipientNameController.text.split(' ').last
              : '',
          "email": recipientEmailController.text,
          "phone": recipientPhoneController.text,
          "tax_id": "73489158172",
          "city": "Brasilia",
          "street_no": "0",
          "address": "Sample Address",
          "address2": "",
          "account_type": "individual",
          "zipcode": "71680389",
          "state_id": "509",
          "country_id": 30
        },
        "products": [
          {
            "sh_code": "61019090",
            "description": titleController.text,
            "quantity": 1,
            "value": shipmentValueController.text,
            "is_battery": 0,
            "is_perfume": 0,
            "is_flameable": 0
          }
        ]
      };
      print('orderData sending to repo');
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

    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Title and description are required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      final updatedOrder = selectedOrder.value!.copyWith(
        title: titleController.text,
        description: descriptionController.text,
      );

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
    titleController.text = order.title;
    descriptionController.text = order.description;
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    _removeListeners();
    // Don't clear the form data here, just dispose the controllers
    titleController.dispose();
    descriptionController.dispose();
    trackingIdController.dispose();
    customerReferenceController.dispose();
    weightController.dispose();
    shipmentValueController.dispose();
    lengthController.dispose();
    widthController.dispose();
    heightController.dispose();
    senderNameController.dispose();
    senderEmailController.dispose();
    recipientNameController.dispose();
    recipientEmailController.dispose();
    recipientPhoneController.dispose();
    super.onClose();
  }

  Future<void> createOrder() async {
    print('create order init');
      if (titleController.text.isEmpty || trackingIdController.text.isEmpty) {
        Get.snackbar('Error', 'Required fields are missing');
        return;
      }


      isLoading.value = true;
      try {
      final orderData = {
      "parcel": {
      "service_id": 1,
      "merchant": "John",
      "carrier": "Carrier",
      "tracking_id": trackingIdController.text,
      "customer_reference": customerReferenceController.text,
      "measurement_unit": "kg/cm",
      "weight": weightController.text,
      "length": lengthController.text,
      "width": widthController.text,
      "height": heightController.text,
      "tax_modality": "DDU",
      "shipment_value": shipmentValueController.text,
      },
      "sender": {
      "sender_first_name": senderNameController.text.split(' ').first,
      "sender_last_name": senderNameController.text.split(' ').length > 1
      ? senderNameController.text.split(' ').last
          : '',
      "sender_email": senderEmailController.text,
      "sender_taxId": "32786897807",
      "sender_country_id": "US",
      "sender_website": "https://dev.homedeliverybr.com"
      },
      "recipient": {
      "first_name": recipientNameController.text.split(' ').first,
      "last_name": recipientNameController.text.split(' ').length > 1
      ? recipientNameController.text.split(' ').last
            : '',
        "email": recipientEmailController.text,
        "phone": recipientPhoneController.text,
        "tax_id": "73489158172",
        "city": "Brasilia",
        "street_no": "0",
        "address": "Sample Address",
        "address2": "",
        "account_type": "individual",
        "zipcode": "71680389",
        "state_id": "509",
        "country_id": 30
      },
        "products": [
          {
            "sh_code": "61019090",
            "description": titleController.text,
            "quantity": 1,
            "value": shipmentValueController.text,
            "is_battery": 0,
            "is_perfume": 0,
            "is_flameable": 0
          }
        ]
      };

      print('order data');
      print(orderData);
      // Call your API to create the order
      final response = await _orderRepository.createOrder(orderData);
      // Handle response
      print('create order response');
      print(response);

      Get.back();
      Get.snackbar('Success', 'Order created successfully');
      fetchOrders();
      } catch (e) {
      Get.snackbar('Error', 'Failed to create order: ${e.toString()}');
      } finally {
      isLoading.value = false;
      }
  }

  void clearForm() {
    // Only clear form data if explicitly requested
    currentStep.value = 0;
    titleController.clear();
    descriptionController.clear();
    trackingIdController.clear();
    customerReferenceController.clear();
    weightController.clear();
    shipmentValueController.clear();
    lengthController.clear();
    widthController.clear();
    heightController.clear();
    senderNameController.clear();
    senderEmailController.clear();
    recipientNameController.clear();
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
        isValid = parcelDetailsFormKey.currentState?.validate() ?? false;
        break;
      case 2:
        isValid = senderRecipientFormKey.currentState?.validate() ?? false;
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
}
