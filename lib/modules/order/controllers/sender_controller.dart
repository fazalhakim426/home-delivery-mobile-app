import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SenderController extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final taxIdController = TextEditingController();
  final countryIdController = TextEditingController();
  final websiteController = TextEditingController();

  final RxMap<String, String> fieldErrors = <String, String>{}.obs;
 final RxnInt selectedCountryId = RxnInt();
  @override
  void onClose() {
    // firstNameController.dispose();
    // lastNameController.dispose();
    // emailController.dispose();
    // taxIdController.dispose();
    // countryIdController.dispose();
    // websiteController.dispose();
    super.onClose();
  }

  void clear() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    taxIdController.clear();
    countryIdController.clear();
    websiteController.clear();
    fieldErrors.clear();
  }

  Map<String, dynamic> toJson() {
    return {
      "sender_first_name": firstNameController.text,
      "sender_last_name": lastNameController.text,
      "sender_email": emailController.text,
      "sender_taxId": taxIdController.text,
      "sender_country_id": selectedCountryId.value,
      "sender_website": websiteController.text,
    };
  }
}