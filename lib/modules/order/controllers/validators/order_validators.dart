import 'package:get/get.dart';
class OrderValidators {
  static String? validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Phone Number Validator (new)
  static String? validatePhone(String? value, {bool isRequired = true}) {
    if (value == null || value.isEmpty) {
      return isRequired ? 'Phone number is required' : null;
    }

    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');

    // Basic validation - adjust these rules as needed
    if (digitsOnly.length < 8) {
      return 'Phone number too short';
    }
    if (digitsOnly.length > 15) {
      return 'Phone number too long';
    }
    if (!GetUtils.isPhoneNumber(value)) {  // Using GetX's built-in check
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? validateNumber(String? value) {

    if (value == null || value.isEmpty) {
      return 'Please enter a number';
    }
    final number = num.tryParse(value);
    if (number == null) {
      return 'Invalid number';
    }
    return null;
  }

}