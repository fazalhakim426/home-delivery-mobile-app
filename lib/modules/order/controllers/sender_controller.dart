import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SenderController extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final taxIdController = TextEditingController();
  final countryIdController = TextEditingController();
  final stateIdController = TextEditingController();
  final websiteController = TextEditingController();
  final zipCodeController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();

  final RxMap<String, String> fieldErrors = <String, String>{}.obs;
  final RxInt selectedCountryId = 250.obs;
  final RxnInt selectedStateId = RxnInt();
  @override
  void onClose() {
    super.onClose();
  }

  void clear() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    taxIdController.clear();
    countryIdController.clear();
    stateIdController.clear();
    websiteController.clear();
    zipCodeController.clear();
    addressController.clear();
    phoneController.clear();
    cityController.clear();
    fieldErrors.clear();
  }

  Map<String, dynamic> toJson() {
    return {
      "sender_first_name": firstNameController.text,
      "sender_last_name": lastNameController.text,
      "sender_email": emailController.text,
      "sender_taxId": taxIdController.text,
      "sender_country_id": selectedCountryId.value,
      "sender_state_id": selectedStateId.value,
      "sender_website": websiteController.text,
      "sender_zipcode": zipCodeController.text,
      "sender_address": addressController.text,
      "sender_phone": phoneController.text,
      "sender_city": cityController.text,
    };
  }
}