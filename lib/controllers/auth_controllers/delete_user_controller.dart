import 'package:get/get.dart';
import 'package:patient_app/services/api_service.dart';
import 'package:patient_app/utils/api_urls.dart';

class DeleteUserController extends GetxController{
  final RxBool isLoading = false.obs;
  final ApiService _apiService = ApiService();
  Future<bool> deleteUserAccount() async {
    try {
      isLoading.value = true;
      final response = await _apiService.delete(ApiUrls.deleteUserUrl);
      if (response.statusCode == 200 || response.statusCode == 204) {
        isLoading.value=false;
        print("response data: ${response.data}");
        return true;
      } else {
        isLoading.value=false;
        return false;
      }
    } catch (e) {
      isLoading.value=false;
      print("Error deleting user account: $e");
      return false;
    }
  }
}