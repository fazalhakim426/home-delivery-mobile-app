import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_delivery_br/data/models/order_model.dart';
import 'package:home_delivery_br/data/repositories/order_repository.dart';
import 'package:home_delivery_br/data/services/form_persistence_service.dart';
import 'sender_controller.dart';
import 'recipient_controller.dart';
import 'parcel_controller.dart';
import 'product_controller.dart';

class OrderCreateController extends GetxController {
  final OrderRepository _orderRepository;
  final _formService = Get.find<FormPersistenceService>();

  final fieldErrors = RxMap<String, String>({});
  late final SenderController senderController;
  late final RecipientController recipientController;
  late final ParcelController parcelController;
  late final ProductController productController;

  OrderCreateController({required OrderRepository orderRepository}) : _orderRepository = orderRepository {
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
  final selectedOrder = Rxn<Order>();

  Timer? _debounceTimer;

  void _setupControllerListeners() {
    _removeListeners();

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

  Future<void> fetchCountries() async {
    isLoading.value = true;
    try {
      final countryList = await _orderRepository.fetchCountries();
      parcelController.countries.value = countryList;
    } catch (e) {
//       print(e.toString());
//       Get.snackbar('Error', 'Failed to fetch countreis: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> fetchCountryStats(id) async {
    isLoading.value = true;
    try {
      final countryStateList = await _orderRepository.getStateByCountry(id);
      parcelController.recipientStates.assignAll(countryStateList);
    } catch (e) {
//       print(e.toString());toString
//       Get.snackbar('Error', 'Failed to fetch country state: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addOrder() async {
    isLoading.value = true;
    try {
      final parcel = parcelController.toJson();
      parcel['merchant'] = senderController.firstNameController.text;
      final orderData = {
        "parcel": parcel,
        "sender": senderController.toJson(),
        "recipient": recipientController.toJson(),
        "products": productController.toJson(),
      }; 
      final response = await _orderRepository.createOrder(orderData);

      if (response['success'] == true) {
        Get.back();
        Get.snackbar('Success', 'Order added successfully');
      } else {
        // Handle error returned from the API
        if (response['errors'] != null && response['errors'] is Map<String, String>) {
          fieldErrors.assignAll(response['errors']);
        }
        Get.snackbar(
          'Failed',
          response['message'] ?? 'Failed to add order.',
          snackPosition: SnackPosition.BOTTOM,
          isDismissible: true,
          duration: const Duration(seconds: 5), // Optional: controls how long it stays
          mainButton: TextButton(
            onPressed: () {
              if (Get.isSnackbarOpen) Get.back(); // Closes the snackbar
            },
            child: const Text(
              'CLOSE',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }

    } catch (e) {
      print(e.toString());
      Get.snackbar('Invalid data', e.toString(),snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
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
