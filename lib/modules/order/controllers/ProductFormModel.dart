import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simpl/data/models/ProductModel.dart';
import 'package:simpl/data/models/ShCodeModel.dart';
class ProductFormModel {
  final TextEditingController shCodeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController valueController = TextEditingController();

  final RxBool isBattery = false.obs;
  final RxBool isPerfume = false.obs;
  final RxBool isFlameable = false.obs;

  final RxnInt selectedShCode = RxnInt();

  Product toProduct() {
    return Product(
      shCode: selectedShCode.value ?? 0,
      description: descriptionController.text.trim(),
      quantity: int.tryParse(quantityController.text.trim()) ?? 0,
      value: double.tryParse(valueController.text.trim()) ?? 0.0,
      isBattery: isBattery.value ? 1 : 0,
      isPerfume: isPerfume.value ? 1 : 0,
      isFlameable: isFlameable.value ? 1 : 0,
    );
  }

  void dispose() {
  }
}