import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/api_urls.dart';
import '../models/soap_model.dart';
import '../services/api_service.dart';

class SoapNoteController extends GetxController {
  final ApiService _apiService = ApiService();

  late TextEditingController reasonController;
  late TextEditingController subjectiveController;
  late TextEditingController objectiveController;
  late TextEditingController assessmentController;
  late TextEditingController planController;

  final isLoading = false.obs;
  final errorMessage = Rxn<String>();
  final isSuccess = false.obs;

  final String appointmentId;

  SoapNoteController({required this.appointmentId});

  @override
  void onInit() {
    super.onInit();
    initializeControllers();
  }

  void initializeControllers() {
    reasonController = TextEditingController();
    subjectiveController = TextEditingController();
    objectiveController = TextEditingController();
    assessmentController = TextEditingController();
    planController = TextEditingController();
  }

  @override
  void onClose() {
    reasonController.dispose();
    subjectiveController.dispose();
    objectiveController.dispose();
    assessmentController.dispose();
    planController.dispose();
    super.onClose();
  }

  Future<void> createSoapNote() async {
    if (subjectiveController.text.trim().isEmpty ||
        objectiveController.text.trim().isEmpty ||
        assessmentController.text.trim().isEmpty ||
        planController.text.trim().isEmpty) {
      Get.snackbar(
        'Required Fields',
        'Please fill in Subjective, Objective, Assessment, and Plan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = null;

      final soapNote = SoapNoteModel(
        subjective: subjectiveController.text.trim(),
        objective: objectiveController.text.trim(),
        assessment: assessmentController.text.trim(),
        plan: planController.text.trim(),
        diagnosis: reasonController.text.trim(),
      );

      final String url = '${ApiUrls.createSoapNoteApi}$appointmentId';

      final response = await _apiService.put(
        url,
        data: soapNote.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        isSuccess.value = true;
        clearFields();
        Get.back();
        Get.snackbar(
          'Success',
          'SOAP note created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        errorMessage.value = 'Failed to create SOAP note';
        Get.snackbar(
          'Error',
          'Failed to create SOAP note',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearFields() {
    reasonController.clear();
    subjectiveController.clear();
    objectiveController.clear();
    assessmentController.clear();
    planController.clear();
  }
}