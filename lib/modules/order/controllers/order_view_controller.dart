import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_delivery_br/data/models/order_model.dart';
import 'package:home_delivery_br/data/repositories/order_repository.dart';
import 'package:home_delivery_br/data/services/form_persistence_service.dart';
import 'package:dio/dio.dart' as dio;
import 'sender_controller.dart';
import 'recipient_controller.dart';
import 'parcel_controller.dart';
import 'product_controller.dart';

class OrderViewController extends GetxController {
  final OrderRepository _orderRepository;


  OrderViewController({required OrderRepository orderRepository}) : _orderRepository = orderRepository {
  }


  final isLoading = false.obs;
  final orders = <Order>[].obs;




  @override
  void onInit() {
    super.onInit();
    fetchOrders();
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
        Get.snackbar('Error', e.toString());
      }
    } finally {
      isLoading.value = false;
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
      Get.snackbar('Error',e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

}
