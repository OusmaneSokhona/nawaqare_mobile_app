import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/api_service.dart';
import '../../utils/api_urls.dart';
import '../../utils/app_strings.dart';

class ProfileCompletionController extends GetxController {
  final ApiService _apiService = ApiService();
  final RxDouble completionValue = 0.0.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfileCompletion();
  }

  Future<void> fetchProfileCompletion() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _apiService.get(ApiUrls.profileCompletion);

      if (response.statusCode == 200) {
        final jsonResponse = response.data is String
            ? json.decode(response.data)
            : response.data;

        if (jsonResponse['success'] == true) {
          final completionRate = jsonResponse['data']['completionRate'];
          completionValue.value = completionRate / 100;
        } else {
          errorMessage.value = 'Failed to fetch profile completion';
        }
      } else {
        errorMessage.value = 'Failed with status code: ${response.statusCode}';
        Get.snackbar(
          AppStrings.warning.tr,
          'Failed to fetch profile completion: ${response.statusCode}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error fetching profile completion: ${e.toString()}');
      Get.snackbar(
        AppStrings.warning.tr,
        'Failed to load profile completion',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
