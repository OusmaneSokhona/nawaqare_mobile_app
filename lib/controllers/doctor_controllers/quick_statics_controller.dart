import 'package:get/get.dart';
import 'package:patient_app/services/api_service.dart';
import 'package:patient_app/utils/api_urls.dart';

class QuickStatisticsController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  var date = ''.obs;
  var averageRating = 0.0.obs;
  var activeConversations = 0.obs;

  String get messagesCount => activeConversations.toString();
  String get ratingDisplay => '${averageRating.value.toStringAsFixed(1)}/5';

  String get formattedDay {
    if (date.value.isEmpty) return '';
    try {
      final DateTime parsedDate = DateTime.parse(date.value);
      return parsedDate.day.toString();
    } catch (e) {
      return '';
    }
  }

  Future<void> fetchQuickStats() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final response = await _apiService.get(ApiUrls.quickStats);

      if (response.data["success"] == true) {
        print("Quick Stats Response: ${response.data}");
        final data = response.data["data"];
        date.value = data['date'] ?? '';
        averageRating.value = (data['averageRating'] ?? 0.0).toDouble();
        activeConversations.value = data['activeConversations'] ?? 0;
      } else {
        hasError.value = true;
        errorMessage.value = 'Failed to load statistics';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error loading statistics: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshStats() async {
    await fetchQuickStats();
  }
}