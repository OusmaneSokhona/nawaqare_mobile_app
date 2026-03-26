import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:patient_app/services/api_service.dart';
import 'package:patient_app/utils/api_urls.dart';

class AbsenceExceptionController extends GetxController {
  final selectedDate = DateTime.now().obs;
  RxBool allService = true.obs;
  RxBool specific = false.obs;
  RxBool notifyAffectedPatient = false.obs;
  RxString selectedReason = "Vacation".obs;
  final DateTime initialDate = DateTime.now();

  final ApiService _apiService = ApiService();
  RxBool isLoading = false.obs;
  RxBool isLoadingHistory = true.obs;
  RxList<CancelledAppointment> cancelledHistory = <CancelledAppointment>[].obs;



  void selectNewDate(DateTime date) {
    selectedDate.value = date;
  }

  Future<void> sendAbsenceException() async {
    isLoading.value = true;
    try {
      String formattedDate = selectedDate.value.toIso8601String().split('T')[0];
      Map<String, dynamic> requestBody = {
        "date": formattedDate,
        "reason": _getReasonDescription(selectedReason.value),
      };

      final response = await _apiService.post(ApiUrls.absenceException, data: requestBody);
      print('Absence Exception Response: ${response}${response.statusCode}');
      print("message: ${response.data['message']}");
      if (response.statusCode == 200) {
        print('Absence exception recorded successfully: ${response.data}');
        String message = response.data['message'] ??
            'Absence recorded successfully';
        Get.snackbar('Success', message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        await fetchPastAbsences();
      }
      else {
        String errorMessage = response.data['message'] ?? 'Failed to record absence';
        Get.snackbar('Error', errorMessage,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      print('Error sending absence: $e');
      Get.snackbar('Error', 'Something went wrong. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPastAbsences() async {
    isLoadingHistory.value = true;
    try {
      final response = await _apiService.get(ApiUrls.getAbsenceException);
      if (response.statusCode == 200 && response.data['success'] == true) {
        List<dynamic> historyData = response.data['cancelledHistory'];
        cancelledHistory.value = historyData.map((item) => CancelledAppointment.fromJson(item)).toList();
      } else {
        Get.snackbar('Error', 'Failed to load past absences',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      print('Error fetching past absences: $e');
      Get.snackbar('Error', 'Could not load past absences',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoadingHistory.value = false;
    }
  }

  String _getReasonDescription(String reasonKey) {
    switch (reasonKey) {
      case 'Vacation':
        return 'Doctor is on vacation';
      case 'OnWork':
        return 'Doctor is on work-related duty';
      case 'WeekEnd':
        return 'Weekend off';
      default:
        return 'Doctor is on leave due to personal emergency';
    }
  }
}

class CancelledAppointment {
  final DateTime appointmentDate;
  final DateTime cancelledAt;
  final String status;
  final String reason;

  CancelledAppointment({
    required this.appointmentDate,
    required this.cancelledAt,
    required this.status,
    required this.reason,
  });

  factory CancelledAppointment.fromJson(Map<String, dynamic> json) {
    return CancelledAppointment(
      appointmentDate: DateTime.parse(json['appointmentDate']),
      cancelledAt: DateTime.parse(json['cancelledAt']),
      status: json['status'],
      reason: json['reason'],
    );
  }

  String get formattedDate => DateFormat('MMM d, yyyy').format(cancelledAt);
}