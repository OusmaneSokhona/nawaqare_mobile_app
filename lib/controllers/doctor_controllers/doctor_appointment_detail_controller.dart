import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_appoinment_controller.dart';
import 'package:patient_app/services/api_service.dart';
import 'package:patient_app/utils/api_urls.dart';

class DoctorAppointmentDetailController extends GetxController {
  final ApiService _apiService = ApiService();
  DoctorAppointmentController appointmentCOntroller=DoctorAppointmentController();

  var isLoading = false.obs;
  var statusSetedHomeVisit = "".obs;

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
        statusSetedHomeVisit.value = status;
        print("status =${response.data}");
Get.back();
if(isDecline){
  Get.back();
}
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
}