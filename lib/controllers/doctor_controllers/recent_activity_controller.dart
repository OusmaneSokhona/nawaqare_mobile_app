import 'package:get/get.dart';
import 'package:patient_app/services/api_service.dart';
import 'package:patient_app/utils/api_urls.dart';

class RecentActivityController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  var activities = <String>[].obs;



  Future<void> fetchRecentActivity() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final response = await _apiService.get(ApiUrls.recentActivity);

      if (response.data["success"] == true) {
        print("Recent Activity Response: ${response.data}");
        activities.value = List<String>.from(response.data["activities"] ?? []);
      } else {
        hasError.value = true;
        errorMessage.value = 'Failed to load recent activity';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error loading recent activity: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshActivity() async {
    await fetchRecentActivity();
  }
}