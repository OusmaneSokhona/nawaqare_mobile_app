import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:patient_app/services/api_service.dart';
import 'package:patient_app/utils/api_urls.dart';
import 'package:patient_app/utils/app_strings.dart';

import '../../models/time_slot_model_doctor.dart';
import '../../utils/app_fonts.dart';

class TimeSlotController extends GetxController {
  final ApiService _apiService = ApiService();

  var selectedDate = DateTime.now().obs;
  var selectedDateForSlot = DateTime.now().obs;
  var startTime = TimeOfDay.now().obs;
  var endTime = TimeOfDay.now().obs;

  var allSlots = <TimeSlotModelDoctor>[].obs;
  var isLoading = false.obs;
  var isCreating = false.obs;

  @override
  void onInit() {
    super.onInit();
    endTime.value = _addMinutesToTimeOfDay(startTime.value, 30);
    fetchSlotsForDate(selectedDate.value);
  }

  TimeOfDay _addMinutesToTimeOfDay(TimeOfDay time, int minutes) {
    final totalMinutes = time.hour * 60 + time.minute + minutes;
    final newHour = totalMinutes ~/ 60;
    final newMinute = totalMinutes % 60;
    return TimeOfDay(hour: newHour % 24, minute: newMinute);
  }

  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> fetchSlotsForDate(DateTime date) async {
    try {
      isLoading.value = true;
      allSlots.clear();

      final response = await _apiService.get(ApiUrls.doctorSlotsApi);

      if (response.statusCode == 200) {
        final data = response.data;
        final doctorResponse = DoctorSlotsResponse.fromJson(data);

        final filteredSlots = doctorResponse.doctor.allSlots.where((slot) {
          final slotDate = DateFormat('yyyy-MM-dd').format(slot.startTime.toLocal());
          final selectedDateFormatted = DateFormat('yyyy-MM-dd').format(date);
          return slotDate == selectedDateFormatted;
        }).toList();

        allSlots.value = filteredSlots;
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.warning.tr,
        AppStrings.failedToLoadSlots.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  int get availableSlotsCount {
    return allSlots.where((slot) => slot.status == 'available').length;
  }

  int get bookedSlotsCount {
    return allSlots.where((slot) => slot.status == 'booked').length;
  }

  Future<void> createTimeSlot() async {
    try {
      isCreating.value = true;

      final startDateTime = DateTime(
        selectedDateForSlot.value.year,
        selectedDateForSlot.value.month,
        selectedDateForSlot.value.day,
        startTime.value.hour,
        startTime.value.minute,
      );

      final endDateTime = DateTime(
        selectedDateForSlot.value.year,
        selectedDateForSlot.value.month,
        selectedDateForSlot.value.day,
        endTime.value.hour,
        endTime.value.minute,
      );

      if (endDateTime.isBefore(startDateTime) || endDateTime.isAtSameMomentAs(startDateTime)) {
        Get.snackbar(
          AppStrings.warning.tr,
          AppStrings.endTimeMustBeAfterStartTime.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isCreating.value = false;
        return;
      }

      final response = await _apiService.post(
        ApiUrls.createSlotApi,
        data: {
          'startTime': startDateTime.toUtc().toIso8601String(),
          'endTime': endDateTime.toUtc().toIso8601String(),
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.back();
        await fetchSlotsForDate(selectedDateForSlot.value);

        Get.snackbar(
          "Success",
          AppStrings.timeSlotCreated.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        startTime.value = TimeOfDay.now();
        endTime.value = _addMinutesToTimeOfDay(TimeOfDay.now(), 30);
      } else {
        Get.snackbar(
          AppStrings.warning.tr,
          AppStrings.failedToCreateSlot.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.warning.tr,
        AppStrings.failedToCreateSlot.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> deleteTimeSlot(String slotId) async {
    try {
      Get.dialog(
        AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          title: Text(
            AppStrings.deleteSlot.tr,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              fontFamily: AppFonts.jakartaBold,
            ),
          ),
          content: Text(
            AppStrings.areYouSureDeleteSlot.tr,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16.sp,
              fontFamily: AppFonts.jakartaRegular,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                AppStrings.cancel.tr,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.sp,
                  fontFamily: AppFonts.jakartaMedium,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Get.back();
                print("Deleting slot with ID: $slotId");

                // Show loading indicator
                Get.dialog(
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                  barrierDismissible: false,
                );

                try {
                  // Check if the URL is formed correctly
                  final deleteUrl = '${ApiUrls.deleteSlotApi}$slotId';
                  print("Delete URL: $deleteUrl");

                  final response = await _apiService.delete(deleteUrl);

                  Get.back(); // Close loading dialog

                  if (response.statusCode == 200) {
                    print("Successfully deleted slot: ${response.data}");

                    await fetchSlotsForDate(selectedDate.value);
                    Get.snackbar(
                      "Success",
                      AppStrings.slotDeleted.tr,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  } else {
                    // Handle different status codes
                    print("Delete failed with status: ${response.statusCode}");
                    print("Response data: ${response.data}");

                    Get.snackbar(
                      AppStrings.warning.tr,
                      "Failed to delete slot. Server returned: ${response.statusCode}",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                } catch (e) {
                  Get.back(); // Close loading dialog
                  print("Exception during delete: $e");

                  if (e is DioException) {
                    print("Dio Error Type: ${e.type}");
                    print("Dio Error Message: ${e.message}");
                    print("Dio Error Response: ${e.response?.data}");

                    // Handle specific Dio errors
                    if (e.response != null) {
                      Get.snackbar(
                        AppStrings.warning.tr,
                        "Server Error: ${e.response?.statusCode} - ${e.response?.data['message'] ?? 'Unknown error'}",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    } else {
                      Get.snackbar(
                        AppStrings.warning.tr,
                        "Network error: ${e.message}",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  } else {
                    Get.snackbar(
                      AppStrings.warning.tr,
                      AppStrings.failedToDeleteSlot.tr,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                }
              },
              child: Text(
                AppStrings.delete.tr,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16.sp,
                  fontFamily: AppFonts.jakartaMedium,
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      print("Outer exception: $e");
      Get.snackbar(
        AppStrings.warning.tr,
        AppStrings.failedToDeleteSlot.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}