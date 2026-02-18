import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_appoinment_controller.dart';
import 'package:patient_app/services/api_service.dart';
import 'package:patient_app/utils/api_urls.dart';

import '../../utils/app_strings.dart';

class DoctorAppointmentDetailController extends GetxController {
  final ApiService _apiService = ApiService();
  DoctorAppointmentController appointmentCOntroller=Get.find();

  var isLoading = false.obs;

  Future<bool> updateAppointmentStatus({
    required String appointmentId,
    required String status,
    required bool isDecline,
  }) async {
    try {
      isLoading.value = true;

      final response = await _apiService.patch(
          "${ApiUrls.homeVisitStatusApi}$appointmentId",
          data: {
            "visitstatus": status
          }
      );

      if (response.statusCode == 200) {
        print("status =${response.data}");
Get.back();
        Get.back();
        appointmentCOntroller.fetchDoctorAppointments();
appointmentCOntroller.fetchDoctorAppointments();
        Get.snackbar(
          'Success',
          "Appointment updated",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.back();
        Get.snackbar(
          'Error',
          "Failed to update appointment",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        'Failed to update appointment status',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> acceptAppointment(String appointmentId) async {
    return await updateAppointmentStatus(
      isDecline: false,
      appointmentId: appointmentId,
      status: 'accepted',
    );
  }

  Future<bool> declineAppointment(String appointmentId) async {
    return await updateAppointmentStatus(
      isDecline: true,
      appointmentId: appointmentId,
      status: 'rejected',
    );
  }
  Future<bool> acceptRescheduleRequest(String appointmentId) async {
    try {
      isLoading.value = true;

      final Map<String, dynamic> requestData = {
        'appointmentId': appointmentId,
      };

      print("Accepting reschedule request for appointment: $appointmentId");

      final response = await _apiService.post(
        ApiUrls.acceptRescheduleRequest,
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Reschedule request accepted successfully");
        Get.back();
        appointmentCOntroller.fetchDoctorAppointments();
         // Refresh appointments list

        Get.snackbar(
          "Success",
          'Reschedule request accepted successfully',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
        return true;
      } else {
        String errorMsg = response.data['message'] ?? 'Failed to accept reschedule request';
        Get.snackbar(
          AppStrings.warning.tr,
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
        );
        return false;
      }
    } catch (e) {
      print('Accept reschedule request error: $e');
      Get.snackbar(
        AppStrings.warning.tr,
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> rejectRescheduleRequest(String appointmentId) async {
    try {
      isLoading.value = true;

      final Map<String, dynamic> requestData = {
        'appointmentId': appointmentId,
      };

      print("Rejecting reschedule request for appointment: $appointmentId");

      final response = await _apiService.post(
        ApiUrls.rejectRescheduleRequest,
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Reschedule request rejected successfully");
        Get.back();
         appointmentCOntroller.fetchDoctorAppointments();

        Get.snackbar(
          "Success",
          'Reschedule request rejected successfully',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
        return true;
      } else {
        String errorMsg = response.data['message'] ?? 'Failed to reject reschedule request';
        Get.snackbar(
          AppStrings.warning.tr,
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
        );
        return false;
      }
    } catch (e) {
      print('Reject reschedule request error: $e');
      Get.snackbar(
        AppStrings.warning.tr,
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}