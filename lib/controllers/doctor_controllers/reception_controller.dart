import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/services/api_service.dart';
import 'package:patient_app/utils/api_urls.dart'; // adjust import

class ReceptionController extends GetxController {
  ScrollController scrollControllerNew = ScrollController();
  RxDouble scrollValue = 0.0.obs;

  // Observables for weekly summary data
  RxBool isLoading = true.obs;
  RxString availableHours = ''.obs;
  RxInt slotsBooked = 0.obs;
  RxInt plannedAbsence = 0.obs;

  final ApiService _apiService = ApiService(); // assuming singleton or injected

  @override
  void onInit() {
    super.onInit();
    scrollChange();
  }

  @override
  void onClose() {
    scrollControllerNew.dispose();
    super.onClose();
  }

  void scrollChange() {
    scrollControllerNew.addListener(() {
      scrollValue.value = scrollControllerNew.offset;
    });
  }

  Future<void> fetchWeeklySummary() async {
    isLoading.value = true;
    try {
      final response = await _apiService.get(ApiUrls.weeklySummary);
      print('Weekly Summary Response: ${response.data}'); // Debug print
      if (response.statusCode==200) {
        availableHours.value = response.data["data"]['availableHours'];
        slotsBooked.value = response.data["data"]['slotsBooked'];
        plannedAbsence.value = response.data["data"]['plannedAbsence'];
      } else {
        Get.snackbar('Error', 'Failed to load weekly summary');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }
}