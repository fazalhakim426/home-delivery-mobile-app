import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simpl/data/models/order_model.dart';
import 'package:simpl/data/repositories/order_repository.dart';
import 'package:simpl/data/services/form_persistence_service.dart';
import 'package:dio/dio.dart' as dio;
import 'sender_controller.dart';
import 'recipient_controller.dart';
import 'parcel_controller.dart';
import 'product_controller.dart';

class OrderController extends GetxController {
  final OrderRepository _orderRepository;
  final _formService = Get.find<FormPersistenceService>();

  final fieldErrors = RxMap<String, String>({});
  // Sub-controllers
  late final SenderController senderController;
  late final RecipientController recipientController;
  late final ParcelController parcelController;
  late final ProductController productController;


  OrderController({required OrderRepository orderRepository})
      : _orderRepository = orderRepository {
    senderController = Get.put(SenderController());
    recipientController = Get.put(RecipientController());
    parcelController = Get.put(ParcelController());
    productController = Get.put(ProductController());
    _setupControllerListeners();
  }


  // Step management
  final currentStep = 0.obs;
  final basicInfoFormKey = GlobalKey<FormState>();
  final parcelDetailsFormKey = GlobalKey<FormState>();
  final senderRecipientFormKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final orders = <Order>[].obs;
  final selectedOrder = Rxn<Order>();

  Timer? _debounceTimer;

  void _setupControllerListeners() {
    _removeListeners();

    // Add listeners to all relevant controllers
    parcelController.trackingIdController.addListener(_debouncedSaveForm);
    parcelController.customerReferenceController.addListener(
      _debouncedSaveForm,
    );
    parcelController.weightController.addListener(_debouncedSaveForm);
    parcelController.shipmentValueController.addListener(_debouncedSaveForm);
    parcelController.lengthController.addListener(_debouncedSaveForm);
    parcelController.widthController.addListener(_debouncedSaveForm);
    parcelController.heightController.addListener(_debouncedSaveForm);

    senderController.firstNameController.addListener(_debouncedSaveForm);
    senderController.lastNameController.addListener(_debouncedSaveForm);
    senderController.emailController.addListener(_debouncedSaveForm);

    recipientController.firstNameController.addListener(_debouncedSaveForm);
    recipientController.lastNameController.addListener(_debouncedSaveForm);
    recipientController.emailController.addListener(_debouncedSaveForm);
    recipientController.phoneController.addListener(_debouncedSaveForm);
  }


  void _removeListeners() {
    parcelController.trackingIdController.removeListener(_debouncedSaveForm);
    parcelController.customerReferenceController.removeListener(
      _debouncedSaveForm,
    );
    parcelController.weightController.removeListener(_debouncedSaveForm);
    parcelController.shipmentValueController.removeListener(_debouncedSaveForm);
    parcelController.lengthController.removeListener(_debouncedSaveForm);
    parcelController.widthController.removeListener(_debouncedSaveForm);
    parcelController.heightController.removeListener(_debouncedSaveForm);

    senderController.firstNameController.removeListener(_debouncedSaveForm);
    senderController.lastNameController.removeListener(_debouncedSaveForm);
    senderController.emailController.removeListener(_debouncedSaveForm);

    recipientController.firstNameController.removeListener(_debouncedSaveForm);
    recipientController.lastNameController.removeListener(_debouncedSaveForm);
    recipientController.emailController.removeListener(_debouncedSaveForm);
    recipientController.phoneController.removeListener(_debouncedSaveForm);
  }

  void _debouncedSaveForm() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), _saveFormData);
  }

  String? getFieldError(String fieldKey) {
    if(this.fieldErrors.containsKey(fieldKey) &&
        this.fieldErrors[fieldKey]!.isNotEmpty){
      return this.fieldErrors[fieldKey];
    }
    return null;
  }
  void clearFieldError(String fieldPath) {
    update();
    if (fieldErrors.containsKey(fieldPath)) {
      fieldErrors.remove(fieldPath);
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadSavedFormData();
    fetchOrders();
    fetchCountries();
  }

  void _loadSavedFormData() {
    final savedData = _formService.getOrderFormData();
    if (savedData != null) {
      parcelController.trackingIdController.text =
          savedData['trackingId'] ?? '';
      parcelController.customerReferenceController.text =
          savedData['customerReference'] ?? '';
      parcelController.weightController.text = savedData['weight'] ?? '';
      parcelController.shipmentValueController.text =
          savedData['shipmentValue'] ?? '';
      parcelController.lengthController.text = savedData['length'] ?? '';
      parcelController.widthController.text = savedData['width'] ?? '';
      parcelController.heightController.text = savedData['height'] ?? '';
      senderController.firstNameController.text =
          savedData['senderFirstName'] ?? '';
      senderController.lastNameController.text =
          savedData['senderLastName'] ?? '';
      senderController.emailController.text = savedData['senderEmail'] ?? '';
      senderController.taxIdController.text = savedData['sender_taxId'] ?? '';
      senderController.countryIdController.text =
          savedData['sender_country_id'] ?? '';
      senderController.websiteController.text =
          savedData['sender_website'] ?? '';

      recipientController.firstNameController.text =
          savedData['recipientFirstName'] ?? '';
      recipientController.lastNameController.text =
          savedData['recipientLastName'] ?? '';
      recipientController.emailController.text =
          savedData['recipientEmail'] ?? '';
      recipientController.phoneController.text = savedData['phone'] ?? '';
      recipientController.taxIdController.text = savedData['tax_id'] ?? '';
      recipientController.cityController.text = savedData['city'] ?? '';
      recipientController.streetNoController.text =
          savedData['street_no'] ?? '';
      recipientController.addressController.text = savedData['address'] ?? '';
      recipientController.address2Controller.text = savedData['address2'] ?? '';
      recipientController.accountTypeController.text =
          savedData['account_type'] ?? '';
      recipientController.zipCodeController.text = savedData['zipcode'] ?? '';
      recipientController.stateIdController.text = savedData['state_id'] ?? '';
      recipientController.countryIdController.text =
          savedData['country_id'] ?? '';
    }
  }

  Future<void> _saveFormData() async {
    final formData = {
      // Parcel data
      'trackingId': parcelController.trackingIdController.text,
      'customerReference': parcelController.customerReferenceController.text,
      'weight': parcelController.weightController.text,
      'shipmentValue': parcelController.shipmentValueController.text,
      'length': parcelController.lengthController.text,
      'width': parcelController.widthController.text,
      'height': parcelController.heightController.text,

      // Sender data
      'senderFirstName': senderController.firstNameController.text,
      'senderLastName': senderController.lastNameController.text,
      'senderEmail': senderController.emailController.text,
      'sender_taxId': senderController.taxIdController.text,
      'sender_country_id': senderController.countryIdController.text,
      'sender_website': senderController.websiteController.text,

      // Recipient data
      'recipientFirstName': recipientController.firstNameController.text,
      'recipientLastName': recipientController.lastNameController.text,
      'recipientEmail': recipientController.emailController.text,
      'phone': recipientController.phoneController.text,
      'tax_id': recipientController.taxIdController.text,
      'city': recipientController.cityController.text,
      'street_no': recipientController.streetNoController.text,
      'address': recipientController.addressController.text,
      'address2': recipientController.address2Controller.text,
      'account_type': recipientController.accountTypeController.text,
      'zipcode': recipientController.zipCodeController.text,
      'state_id': recipientController.stateIdController.text,
      'country_id': recipientController.countryIdController.text,
    };

    await _formService.saveOrderFormData(formData);
  }

  Future<void> fetchOrders() async {
    isLoading.value = true;
    try {
      final orderList = await _orderRepository.getAllOrders();
      orders.assignAll(orderList);
    } catch (e) {
      print(e.toString());

      // If it's a DioException, check the status code
      if (e is dio.DioException && e.response?.statusCode == 401) {
        Get.offAllNamed('/login');
      } else {
        Get.snackbar('Error', 'Failed to fetch orders: ${e.toString()}');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCountries() async {
    isLoading.value = true;
    try {
      final countryList = await _orderRepository.fetchCountries();
      parcelController.countries.assignAll(countryList);
    } catch (e) {
      print(e.toString());
      Get.snackbar('Error', 'Failed to fetch countreis: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> fetchCountryStats(id) async {
    print('selected id');
    print(id);
    isLoading.value = true;
    try {
      final countryStateList = await _orderRepository.getStateByCountry(id);
      parcelController.recipientStates.assignAll(countryStateList);
    } catch (e) {
      print(e.toString());
      Get.snackbar('Error', 'Failed to fetch country state: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addOrder() async {
    isLoading.value = true;
    try {
      final orderData = {
        "parcel": parcelController.toJson(),
        "sender": senderController.toJson(),
        "recipient": recipientController.toJson(),
        "products": productController.toJson(),
      };

      final createdOrder = await _orderRepository.createOrder(orderData);
      orders.add(createdOrder);
      Get.back();
      Get.snackbar('Success', 'Order added successfully');
    } catch (e) {
      if (e is Map<String, String>) {
        fieldErrors.assignAll(e); // update UI
      }
      print(e.toString());
      Get.snackbar(
        'Invalid data',
        'Failed to add order: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateOrder() async {
    if (selectedOrder.value == null) {
      Get.snackbar('Error', 'No order selected for update');
      return;
    }

    isLoading.value = true;
    try {
      final updatedOrder = selectedOrder.value!.copyWith();
      final result = await _orderRepository.updateOrder(updatedOrder);

      final index = orders.indexWhere((order) => order.id == result.id);
      if (index != -1) {
        orders[index] = result;
      }

      clearForm();
      Get.back();
      Get.snackbar('Success', 'Order updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update order: ${e.toString()}');
    } finally {
      isLoading.value = false;
      selectedOrder.value = null;
    }
  }

  Future<void> deleteOrder(int id) async {
    isLoading.value = true;
    try {
      final success = await _orderRepository.deleteOrder(id);
      if (success) {
        orders.removeWhere((order) => order.id == id);
        Get.snackbar('Success', 'Order deleted successfully');
        fetchOrders();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete order: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void selectOrderForEdit(Order order) {
    selectedOrder.value = order;
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    _removeListeners();
    super.onClose();
  }

  void clearForm() {
    currentStep.value = 0;
    senderController.clear();
    recipientController.clear();
    parcelController.clear();
    productController.clear();
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
      _saveFormData();
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }


}
