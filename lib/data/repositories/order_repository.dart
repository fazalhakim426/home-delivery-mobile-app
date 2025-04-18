import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:simpl/app/constants.dart';
import 'package:simpl/data/models/order_model.dart';
import 'package:simpl/data/providers/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  final bool useDummyData = false; // Set to false for real API calls

  // Get all orders
  Future<List<Order>> getAllOrders() async {
    try {
      final response = await _apiProvider.get(Constants.orders);
      final data = response.data['data'];
      print('order get successfully');
      print(data);

      List<Order> orders = (data as List)
          .map((json) => Order.fromJson(json as Map<String, dynamic>))
          .toList();

      return orders;
    } catch (e) {
      throw Exception('Failed to get orders: ${e.toString()}');
    }
  }

  // Get order by id
  Future<Order> getOrderById(int id) async {
    // if (useDummyData) {
    //   // return _generateDummyOrders().firstWhere((order) => order.id == id);
    // }

    try {
      final response = await _apiProvider.get('${Constants.orders}/$id');
      return Order.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get order: ${e.toString()}');
    }
  }

  // Create order
  Future<Order> createOrder(order) async {
    try {
      print('request sending....');
      final response = await _apiProvider.post(
        Constants.parcels,
        data: order,
      );
      return Order.fromJson(response.data);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'] ?? {};
        print("❌ Validation errors:");
        errors.forEach((key, value) {
          print("🔹 $key: ${(value as List).join(', ')}");
        });
      } else {
        print("🚨 General error: ${e.toString()}");
      }

      throw Exception('Failed to create order: ${e.toString()}');
    }
  }

  // Update order
  Future<Order> updateOrder(Order order) async {
    if (useDummyData) {
      return order;
    }

    try {
      if (order.id == null) {
        throw Exception('Order ID is required for update');
      }

      final response = await _apiProvider.put(
        '${Constants.orders}/${order.id}',
        data: order.toJson(),
      );
      return Order.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update order: ${e.toString()}');
    }
  }

  // Delete order
  Future<bool> deleteOrder(int id) async {
    try {
      final response = await _apiProvider.delete('${Constants.orders}/$id');
      return true;
    } catch (e) {
      throw Exception('Failed to delete order: ${e.toString()}');
    }
  }

  // Toggle order completion
  Future<Order> toggleOrderCompletion(Order order) async {
    if (useDummyData) {
      return order.copyWith(isShipped: !order.isShipped);
    }

    try {
      if (order.id == null) {
        throw Exception('Order ID is required');
      }

      Order updatedOrder = order.copyWith(isShipped: !order.isShipped);
      final response = await _apiProvider.put(
        '${Constants.orders}/${order.id}',
        data: updatedOrder.toJson(),
      );
      return Order.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to toggle order: ${e.toString()}');
    }
  }

  // Dummy data generator
  // List<Order> _generateDummyOrders() {
  //   final now = DateTime.now();
  //   const services = ['Express Shipping', 'Standard Delivery', 'International Priority'];
  //   const countries = ['US', 'UK', 'CA', 'AU', 'BR', 'DE', 'FR'];
  //   const recipients = [
  //     'John Smith',
  //     'Emma Johnson',
  //     'Michael Brown',
  //     'Sarah Wilson',
  //     'David Lee',
  //     'Lisa Garcia',
  //     'Robert Martinez'
  //   ];
  //
  //   return List.generate(15, (index) {
  //     final random = DateTime.now().millisecondsSinceEpoch + index;
  //     final daysAgo = random % 30;
  //
  //     return Order(
  //       id: index + 1,
  //       title: 'Order ${index + 1001}',
  //       description: 'Package containing ${['electronics', 'clothing', 'books', 'documents'][random % 4]}',
  //       isShipped: random % 5 == 0,
  //       createdAt: now.subtract(Duration(days: daysAgo)),
  //       trackingCode: 'TRK${(now.millisecondsSinceEpoch + index).toString().substring(5)}',
  //       serviceName: services[random % services.length],
  //       weight: 0.5 + (random % 10) * 0.3,
  //       orderDate: now.subtract(Duration(days: daysAgo + 1)),
  //       orderValue: 10.0 + (random % 90) * 0.5,
  //       recipientName: recipients[random % recipients.length],
  //       recipientCountry: countries[random % countries.length],
  //     );
  //   });
  // }
}