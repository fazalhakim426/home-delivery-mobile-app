import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:home_delivery_br/data/models/order_model.dart';
import 'package:home_delivery_br/data/repositories/order_repository.dart';
import 'package:dio/dio.dart' as dio;

class OrderViewController extends GetxController {
  final OrderRepository _orderRepository;
  final isFilterVisible = false.obs;
  final scrollController = ScrollController();
  OrderViewController({required OrderRepository orderRepository})
    : _orderRepository = orderRepository {}
// In your controller class
  final searchController = TextEditingController();


  var orders = <Order>[].obs;
  var isLoading = true.obs;
  var isLoadMore = false.obs;
  var page = 1;
  var hasMore = true;
  var searchQuery = ''.obs;
  var startDate = DateTime.now().subtract(const Duration(days: 30)).obs;
  var endDate = DateTime.now().obs;

  @override
  void onInit() {
    fetchOrders();
    super.onInit();
    scrollController.addListener(_handleScroll);
  }
  void _handleScroll() {
    if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (isFilterVisible.value) {
        isFilterVisible.value = false;
      }
    }
  }

  void toggleFilterVisibility() {
    isFilterVisible.value = !isFilterVisible.value;
  }
  Future<void> fetchOrders({bool loadMore = false}) async {
    if (loadMore) {
      if (!hasMore || isLoadMore.value) return;
      isLoadMore.value = true;
      page++;
    } else {
      isLoading.value = true;
      page = 1;
      hasMore = true;
    }

    try {
      final orderList = await _orderRepository.getAllOrders(
        page: page,
        search: searchQuery.value,
        startDate: startDate.value,
        endDate: endDate.value,
      );

      if (loadMore) {
        orders.addAll(orderList);
      } else {
        orders.assignAll(orderList);
      }

      // Check if we've reached the end of data
      if (orderList.isEmpty) {
        hasMore = false;
      }
    } catch (e) {
      print(e.toString());
      if (e is dio.DioException && e.response?.statusCode == 401) {
        Get.offAllNamed('/login');
      } else {
        Get.snackbar('Error', e.toString());
      }
    } finally {
      isLoading.value = false;
      isLoadMore.value = false;
    }
  }

  void searchOrders(String query) {
    searchQuery.value = query;
    fetchOrders();
  }

  void filterByDate(DateTime newStartDate, DateTime newEndDate) {
    startDate.value = newStartDate;
    endDate.value = newEndDate;
    fetchOrders();
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
    scrollController.dispose();
    super.onClose();
  }
}
