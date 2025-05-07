import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecipientController extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final taxIdController = TextEditingController();
  final cityController = TextEditingController();
  final streetNoController = TextEditingController();
  final addressController = TextEditingController();
  final address2Controller = TextEditingController();
  final accountTypeController = TextEditingController();
  final zipCodeController = TextEditingController();
  final stateIdController = TextEditingController();
  final countryIdController = TextEditingController();

  final RxMap<String, String> fieldErrors = <String, String>{}.obs;


  final RxnString accountType = RxnString('individual');
  final RxnInt selectedCountryId = RxnInt();
  final RxnInt selectedStateId = RxnInt();

  @override
  void onClose() {
    // firstNameController.dispose();
    // lastNameController.dispose();
    // emailController.dispose();
    // phoneController.dispose();
    // taxIdController.dispose();
    // cityController.dispose();
    // streetNoController.dispose();
    // addressController.dispose();
    // address2Controller.dispose();
    // accountTypeController.dispose();
    // zipCodeController.dispose();
    // stateIdController.dispose();
    // countryIdController.dispose();
    super.onClose();
  }

  void clear() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneController.clear();
    taxIdController.clear();
    cityController.clear();
    streetNoController.clear();
    addressController.clear();
    address2Controller.clear();
    accountTypeController.clear();
    zipCodeController.clear();
    stateIdController.clear();
    countryIdController.clear();
    fieldErrors.clear();
  }

  Map<String, dynamic> toJson() {
    return {
      "first_name": firstNameController.text,
      "last_name": lastNameController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      "tax_id": taxIdController.text,
      "city": cityController.text,
      "street_no": streetNoController.text,
      "address": addressController.text,
      "address2": address2Controller.text,
      "account_type": accountTypeController.text,
      "zipcode": zipCodeController.text,
      "state_id": stateIdController.text,
      "country_id": countryIdController.text,
    };
  }
}