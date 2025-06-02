import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:home_delivery_br/app/constants.dart';
import 'package:home_delivery_br/data/models/CountryModel.dart';
import 'package:home_delivery_br/data/models/CountryStateModel.dart';
import 'package:home_delivery_br/data/models/ServiceModel.dart';
import 'package:home_delivery_br/data/models/ShCodeModel.dart';
import 'package:home_delivery_br/data/models/order_model.dart';
import 'package:home_delivery_br/data/providers/api_provider.dart';

import 'package:intl/intl.dart';

class OrderRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  List<Country>? _cachedCountries;

  Future<List<Order>> getAllOrders({
    int page = 1,
    int perPage = 10,
    String? search,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'page': page.toString(),
        'per_page': perPage.toString(),
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      if (startDate != null) {
        queryParams['start_date'] = DateFormat('yyyy-MM-dd').format(startDate);
      }

      if (endDate != null) {
        queryParams['end_date'] = DateFormat('yyyy-MM-dd').format(endDate);
      }

      final response = await _apiProvider.get(
        Constants.orders,
        query: queryParams,
      );
      final data = response.data['data'];

      return (data as List)
          .map((json) => Order.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get orders: ${e.toString()}');
    }
  }

  Future<List<Country>> fetchCountries() async {
    if (_cachedCountries != null) {
      return _cachedCountries!;
    }
    try {
      final response = await _apiProvider.get(Constants.countries);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          _cachedCountries =
              data
                  .map((json) => Country.fromJson(json as Map<String, dynamic>))
                  .toList();
          return _cachedCountries!;
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
      final response = await _apiProvider.get('country/$id/states');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          List<CountryState> states =
              data
                  .map(
                    (json) =>
                        CountryState.fromJson(json as Map<String, dynamic>),
                  )
                  .toList();
          return states;
        } else {
          throw Exception('Expected list but got ${data.runtimeType}');
        }
      } else {
        throw Exception(
          'Failed to load countries states: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to get countries states: ${e.toString()}');
    }
  }

  // Get order by id
  Future<Order> getOrderById(int id) async {
    try {
      final response = await _apiProvider.get('${Constants.orders}/$id');
      return Order.fromJson(response.data);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> createOrder(order) async {
    try {
      final response = await _apiProvider.post(Constants.parcels, data: order);

      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'] ?? {};
        final formattedErrors = <String, String>{};

        errors.forEach((key, value) {
          formattedErrors[key] = (value as List).join(', ');
        });

        // Combine all error messages into a single string for the message
        final combinedErrorMessage = formattedErrors.values.join(' | ');

        // Return a consistent failure format with combined message
        return {
          "success": false,
          "message": "Validation error: $combinedErrorMessage",
          "errors": formattedErrors,
        };
      }

      return {"success": false, "message": "Unexpected error: ${e.message}"};
    } catch (e) {
      return {"success": false, "message": "Unexpected error: ${e.toString()}"};
    }
  }

  Future<Map<String, dynamic>> updateOrder(updateRequest, Order order) async {
    try {
      final response = await _apiProvider.put(
        '${Constants.parcels}/${order.id}',
        data: updateRequest,
      );

      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'] ?? {};
        final formattedErrors = <String, String>{};

        errors.forEach((key, value) {
          formattedErrors[key] = (value as List).join(', ');
        });

        // Combine all error messages into a single string for the message
        final combinedErrorMessage = formattedErrors.values.join(' | ');

        // Return a consistent failure format with combined message
        return {
          "success": false,
          "message": "Validation error: $combinedErrorMessage",
          "errors": formattedErrors,
        };
      }

      return {"success": false, "message": "Unexpected error: ${e.message}"};
    } catch (e) {
      return {"success": false, "message": "Unexpected error: ${e.toString()}"};
    }
  }

  // Delete order
  Future<bool> deleteOrder(int id) async {
    try {
      await _apiProvider.delete('${Constants.orders}/$id');
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> printLabel(int id) async {
    try {
      final response = await _apiProvider.get('parcel/$id/cn23');
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'] ?? {};
        final formattedErrors = <String, String>{};

        errors.forEach((key, value) {
          formattedErrors[key] = (value as List).join(', ');
        });

        // Combine all error messages into a single string for the message
        final combinedErrorMessage = formattedErrors.values.join(' | ');

        // Return a consistent failure format with combined message
        return {
          "success": false,
          "message": "Validation error: $combinedErrorMessage",
          "errors": formattedErrors,
        };
      }

      return {"success": false, "message": "Unexpected error: ${e.message}"};
    } catch (e) {
      return {"success": false, "message": "Unexpected error: ${e.toString()}"};
    }
  }

  // Toggle order completion
  Future<Order> toggleOrderCompletion(Order order) async {
    try {
      if (order.id == null) {
        throw Exception('Order ID is required');
      }

      Order updatedOrder = order.copyWith();
      final response = await _apiProvider.put(
        '${Constants.orders}/${order.id}',
        data: updatedOrder.toJson(),
      );
      return Order.fromJson(response.data);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Service>> getAllServices() async {
    try {
      final response = await _apiProvider.get(Constants.services);
      final data = response.data['data'];
      print('${Constants.services} output');
      print(data);
      List<Service> services =
          (data as List)
              .map((json) => Service.fromJson(json as Map<String, dynamic>))
              .toList();

      return services;
    } catch (e) {
      throw Exception('${Constants.services} ${e.toString()}');
    }
  }

  Future<List<ShCode>> getAllShCodes() async {
    try {
      final response = await _apiProvider.get(Constants.shcodes);
      final data = response.data;
      print('${Constants.shcodes} output');
      print(data);
      List<ShCode> shcodes =
          (data as List)
              .map((json) => ShCode.fromJson(json as Map<String, dynamic>))
              .toList();
      return shcodes;
    } catch (e) {
      throw Exception('${Constants.shcodes} ${e.toString()}');
    }
  }
}
