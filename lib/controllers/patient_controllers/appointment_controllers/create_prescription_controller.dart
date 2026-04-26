import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/services/api_service.dart';
import 'package:patient_app/utils/api_urls.dart';

class CreatePrescriptionController extends GetxController {
  final ApiService apiService = ApiService();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Form fields
  final patientNameController = TextEditingController();
  final diagnosisController = TextEditingController();
  final notesController = TextEditingController();

  // Medications list
  final medications = <Map<String, dynamic>>[].obs;

  // Current medication being added
  final medicineNameController = TextEditingController();
  final dosageController = TextEditingController();
  final frequencyController = TextEditingController();
  final durationController = TextEditingController();
  final instructionsController = TextEditingController();
  final specialInstructionController = TextEditingController();
  final refillDateController = TextEditingController();

  // Date selection
  final issueDate = DateTime.now().obs;
  final validUntil = DateTime.now().add(const Duration(days: 14)).obs;

  @override
  void onClose() {
    patientNameController.dispose();
    diagnosisController.dispose();
    notesController.dispose();
    medicineNameController.dispose();
    dosageController.dispose();
    frequencyController.dispose();
    durationController.dispose();
    instructionsController.dispose();
    specialInstructionController.dispose();
    refillDateController.dispose();
    super.onClose();
  }

  void addMedication() {
    if (medicineNameController.text.isNotEmpty &&
        dosageController.text.isNotEmpty &&
        frequencyController.text.isNotEmpty) {

      medications.add({
        "name": medicineNameController.text,
        "dosage": dosageController.text,
        "frequency": frequencyController.text,
        "duration": durationController.text.isNotEmpty ? durationController.text : "Not specified",
        "instructions": instructionsController.text.isNotEmpty ? instructionsController.text : "As directed",
        "specialInstruction": specialInstructionController.text.isNotEmpty ? specialInstructionController.text : "",
        "refildate": refillDateController.text.isNotEmpty ? refillDateController.text : DateTime.now().toIso8601String().split('T')[0],
      });

      // Clear medication fields
      medicineNameController.clear();
      dosageController.clear();
      frequencyController.clear();
      durationController.clear();
      instructionsController.clear();
      specialInstructionController.clear();
      refillDateController.clear();
    }
  }

  void removeMedication(int index) {
    medications.removeAt(index);
  }

  void updateIssueDate(DateTime date) {
    issueDate.value = date;
  }

  void updateValidUntil(DateTime date) {
    validUntil.value = date;
  }

  Map<String, dynamic> getPrescriptionData(String appointmentId) {
    return {
      "appointmentId": appointmentId,
      "patientName": patientNameController.text,
      "diagnosis": diagnosisController.text,
      "medications": medications.toList(),
      "notes": notesController.text,
      "issueDate": issueDate.value.toIso8601String().split('T')[0],
      "validUntil": validUntil.value.toIso8601String().split('T')[0],
    };
  }

  String _extractErrorMessage(dynamic error) {
    try {
      if (error is Map && error.containsKey('response')) {
        final response = error['response'];
        if (response != null && response.data != null) {
          if (response.data is Map && response.data['message'] != null) {
            return response.data['message'].toString();
          } else if (response.data is String) {
            return response.data;
          }
        }
      } else if (error.toString().contains('SocketException') ||
          error.toString().contains('Network is unreachable')) {
        return 'Network error. Please check your internet connection.';
      } else if (error.toString().contains('Timeout')) {
        return 'Request timeout. Please try again.';
      }
      return error.toString();
    } catch (e) {
      return 'An unexpected error occurred';
    }
  }

  Future<void> savePrescription(String appointmentId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = getPrescriptionData(appointmentId);
      final response = await apiService.post(ApiUrls.createPrescription, data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        Get.snackbar(
          'Success',
          response.data['message'] ?? 'Prescription saved successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        final errorMsg = response.data['message'] ?? 'Failed to save prescription';
        errorMessage.value = errorMsg;
        Get.snackbar(
          'Error',
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      final errorMsg = _extractErrorMessage(e);
      errorMessage.value = errorMsg;
      Get.snackbar(
        'Error',
        errorMsg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }


  void clearForm() {
    patientNameController.clear();
    diagnosisController.clear();
    notesController.clear();
    medications.clear();
    medicineNameController.clear();
    dosageController.clear();
    frequencyController.clear();
    durationController.clear();
    instructionsController.clear();
    specialInstructionController.clear();
    refillDateController.clear();
    issueDate.value = DateTime.now();
    validUntil.value = DateTime.now().add(const Duration(days: 14));
    errorMessage.value = '';
  }
}