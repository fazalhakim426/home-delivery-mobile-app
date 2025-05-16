import 'package:get/get.dart';
import 'package:home_delivery_br/data/models/Dashboard.dart';
import 'package:intl/intl.dart';
import 'package:home_delivery_br/app/constants.dart';
import 'package:home_delivery_br/data/providers/api_provider.dart';

class DashboardRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  Future<Dashboard> getDashboard({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};

      if (startDate != null) {
        queryParams['start_date'] = DateFormat('yyyy-MM-dd').format(startDate);
      }

      if (endDate != null) {
        queryParams['end_date'] = DateFormat('yyyy-MM-dd').format(endDate);
      }

      final response = await _apiProvider.get(
        Constants.dashboard,
        query: queryParams,
      );

      final data = response.data['data'];
      return Dashboard.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch dashboard stats: ${e.toString()}');
    }
  }
}