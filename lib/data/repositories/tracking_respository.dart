import 'package:home_delivery_br/data/models/tracking_model.dart';
import 'package:get/get.dart';
import 'package:home_delivery_br/data/providers/api_provider.dart';
class TrackingRepository {

  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  Future<Tracking> getTracking(String trackingCode) async {
    final response = await _apiProvider.get('order/tracking/$trackingCode');
    print('tracking data');
    print(response);
    if (response.statusCode == 200) {
      return Tracking.fromJson(response.data);
    } else {
      final message = response.data['message'];
      throw Exception('Failed to load tracking: ${message ?? 'Unknown error'}');
    }
  }


}
