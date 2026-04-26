// controllers/doctor_controllers/doctor_soap_notes_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/api_service.dart';
import '../../../utils/api_urls.dart';

class SoapNote {
  String? id;
  String subjective;
  String objective;
  String assessment;
  String plan;
  String diagnosis;
  String? appointmentId;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isSigned;

  SoapNote({
    this.id,
    required this.subjective,
    required this.objective,
    required this.assessment,
    required this.plan,
    required this.diagnosis,
    this.appointmentId,
    this.createdAt,
    this.updatedAt,
    this.isSigned,
  });

  factory SoapNote.fromJson(Map<String, dynamic> json) {
    return SoapNote(
      id: json['id']?.toString(),
      subjective: json['subjective'] ?? '',
      objective: json['objective'] ?? '',
      assessment: json['assessment'] ?? '',
      plan: json['plan'] ?? '',
      diagnosis: json['diagnosis'] ?? '',
      appointmentId: json['appointmentId']?.toString(),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isSigned: json['isSigned'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subjective': subjective,
      'objective': objective,
      'assessment': assessment,
      'plan': plan,
      'diagnosis': diagnosis,
    };
  }
}

class DoctorSoapNotesController extends GetxController {
  final ApiService _apiService = ApiService();

  // SOAP Notes fields
  final reasonController = TextEditingController();
  final subjectiveController = TextEditingController();
  final objectiveController = TextEditingController();
  final assessmentController = TextEditingController();
  final planController = TextEditingController();
  final diagnosisController = TextEditingController();

  // Existing notes data
  final existingNotes = Rx<SoapNote?>(null);
  final isLoading = false.obs;
  final isSaving = false.obs;
  final isSigned = false.obs;
  final errorMessage = ''.obs;
  final String appointmentId;

  DoctorSoapNotesController({required this.appointmentId});

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    reasonController.dispose();
    subjectiveController.dispose();
    objectiveController.dispose();
    assessmentController.dispose();
    planController.dispose();
    diagnosisController.dispose();
    super.onClose();
  }



  // Validate fields
  bool validateFields() {
    if (subjectiveController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter subjective notes';
      return false;
    }
    if (objectiveController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter objective notes';
      return false;
    }
    if (assessmentController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter assessment';
      return false;
    }
    if (planController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter plan';
      return false;
    }
    if (diagnosisController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter diagnosis';
      return false;
    }
    errorMessage.value = '';
    return true;
  }



  // Sign SOAP notes
  Future<bool> signSoapNotes() async {
    if (!validateFields()) return false;

    isSaving.value = true;
    try {
      print("Signing SOAP notes for appointment: $appointmentId");

      final response = await _apiService.post(
        '${ApiUrls.createSoapNoteApi}$appointmentId',
        data: {
          'subjective': subjectiveController.text.trim(),
          'objective': objectiveController.text.trim(),
          'assessment': assessmentController.text.trim(),
          'plan': planController.text.trim(),
          'diagnosis': diagnosisController.text.trim(),
          'isSigned': true,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        isSigned.value = true;

        Get.snackbar(
          "Success",
          "SOAP notes signed successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );

        return true;
      } else {
        errorMessage.value = response.data['message'] ?? 'Failed to sign SOAP notes';
        Get.snackbar(
          "Error",
          errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      print('Sign SOAP notes error: $e');
      errorMessage.value = 'An error occurred: $e';
      Get.snackbar(
        "Error",
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  // Reset form
  void resetForm() {
    subjectiveController.clear();
    objectiveController.clear();
    assessmentController.clear();
    planController.clear();
    diagnosisController.clear();
    errorMessage.value = '';
  }

  // Check if notes have been modified
  bool get hasChanges {
    if (existingNotes.value == null) {
      return subjectiveController.text.isNotEmpty ||
          objectiveController.text.isNotEmpty ||
          assessmentController.text.isNotEmpty ||
          planController.text.isNotEmpty ||
          diagnosisController.text.isNotEmpty;
    }

    return subjectiveController.text != existingNotes.value!.subjective ||
        objectiveController.text != existingNotes.value!.objective ||
        assessmentController.text != existingNotes.value!.assessment ||
        planController.text != existingNotes.value!.plan ||
        diagnosisController.text != existingNotes.value!.diagnosis;
  }
}