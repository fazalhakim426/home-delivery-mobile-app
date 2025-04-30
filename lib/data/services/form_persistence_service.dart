import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FormPersistenceService {
  static const String _orderFormKey = 'order_form_data';

  final SharedPreferences _prefs;

  FormPersistenceService._(this._prefs);

  static Future<FormPersistenceService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return FormPersistenceService._(prefs);
  }

  Future<void> saveOrderFormData(Map<String, String> formData) async {
    try {
      await _prefs.setString(_orderFormKey, jsonEncode(formData));
      print('Form data saved successfully: $formData'); // Debug log
    } catch (e) {
      print('Error saving form data: $e'); // Debug log
    }
  }

  Map<String, String>? getOrderFormData() {
    try {
      final String? data = _prefs.getString(_orderFormKey);
      print('Retrieved form data: $data'); // Debug log
      if (data == null) return null;
      return Map<String, String>.from(jsonDecode(data));
    } catch (e) {
      print('Error loading form data: $e'); // Debug log
      return null;
    }
  }

  Future<void> clearOrderFormData() async {
    await _prefs.remove(_orderFormKey);
  }
}
