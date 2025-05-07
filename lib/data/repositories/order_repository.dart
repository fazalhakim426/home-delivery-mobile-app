import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:simpl/app/constants.dart';
import 'package:simpl/data/models/CountryModel.dart';
import 'package:simpl/data/models/CountryStateModel.dart';
import 'package:simpl/data/models/order_model.dart';
import 'package:simpl/data/providers/api_provider.dart';

class OrderRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

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
  // Get all orders
  Future<List<Country>> fetchCountries() async {
    try {
      final response = await _apiProvider.get(Constants.countries);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          List<Country> countries = data
              .map((json) => Country.fromJson(json as Map<String, dynamic>))
              .toList();
          return countries;
        } else {
          throw Exception('Expected list but got ${data.runtimeType}');
        }
      } else {
        throw Exception('Failed to load countries: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get countries: ${e.toString()}');
    }
  }

  // Get order by id
  Future<List<CountryState>> getStateByCountry(int id) async {

    try {
      final response = await _apiProvider.get('v1/country/$id/states');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          List<CountryState> states = data
              .map((json) => CountryState.fromJson(json as Map<String, dynamic>))
              .toList();
          return states;
        } else {
          throw Exception('Expected list but got ${data.runtimeType}');
        }
      } else {
        throw Exception('Failed to load countries: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get countries: ${e.toString()}');
    }

  }
  // Get order by id
  Future<Order> getOrderById(int id) async {
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
      print(order);
      final response = await _apiProvider.post(
        Constants.parcels,
        data: order,
      );
      print('resposne data');
      print(response.data['data']);
      return Order.fromJson(response.data['data']);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'] ?? {};
        final formattedErrors = <String, String>{};
        errors.forEach((key, value) {
          formattedErrors[key] = (value as List).join(', ');
        });

        throw formattedErrors;
      } else {
        print("🚨 General error: ${e.toString()}");
        throw Exception('Failed to create order: ${e.toString()}');
      }
    }

  }

  // Update order
  Future<Order> updateOrder(Order order) async {
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

}