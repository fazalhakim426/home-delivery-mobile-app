import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:home_delivery_br/data/models/Dashboard.dart';
import 'package:home_delivery_br/data/repositories/dashboard_repository.dart';
import 'package:dio/dio.dart' as dio;

class DashboardController extends GetxController {
  final DashboardRepository _dashboardRepository;

  DashboardController({required DashboardRepository dashboardRepository})
      : _dashboardRepository = dashboardRepository;

  final searchController = TextEditingController();

  var dashboard = Rxn<Dashboard>(); // ✅ holds a single Dashboard object
  var isLoading = true.obs;
  var isLoadMore = false.obs;
  var page = 1;
  var hasMore = true;
  var searchQuery = ''.obs;
  var startDate = DateTime.now().subtract(const Duration(days: 30)).obs;
  var endDate = DateTime.now().obs;

  static const String cacheKey = 'dashboard_cache';

  @override
  void onInit() {
    _loadCachedDashboard(); // 🔹 load and display cached data first
    fetchDashboard(); // 🔹 then fetch fresh data from API
    super.onInit();
  }

  /// 🔹 Load dashboard from local cache
  Future<void> _loadCachedDashboard() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(cacheKey);

    if (cached != null) {
      try {
        final decoded = jsonDecode(cached);
        dashboard.value = Dashboard.fromJson(decoded);
      } catch (e) {
        print('Error decoding cached dashboard: $e');
      }
    }
  }

  /// 🔹 Fetch dashboard from API and update cache
  Future<void> fetchDashboard() async {
    isLoading.value = true;

    try {
      print('Dashboard API request sent');

      final result = await _dashboardRepository.getDashboard(
        startDate: startDate.value,
        endDate: endDate.value,
      );

      dashboard.value = result;

      // 🔸 Save new data to cache
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(cacheKey, jsonEncode(result.toJson()));

    } catch (e) {
      print('Dashboard fetch error: $e');
      if (e is dio.DioException && e.response?.statusCode == 401) {
        Get.offAllNamed('/login');
      } else {
        Get.snackbar('Network Error', 'Using cached data');
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 Search logic
  void searchDashboard(String query) {
    searchQuery.value = query;
    fetchDashboard();
  }

  /// 🔹 Date filter logic
  void filterByDate(DateTime newStartDate, DateTime newEndDate) {
    startDate.value = newStartDate;
    endDate.value = newEndDate;
    fetchDashboard();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}