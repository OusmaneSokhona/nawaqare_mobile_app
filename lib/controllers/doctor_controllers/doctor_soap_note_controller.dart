// controllers/doctor_controllers/doctor_soap_notes_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/api_service.dart';
import '../../../utils/api_urls.dart';
import '../../../utils/nest_api_urls.dart';

class SoapNote {
  String? id;
  String subjective;
  String objective;
  String assessment;
  String plan;
  String diagnosis;
  String? icdCode;
  String? icdLabel;
  String? consultationId;
  String? signedByDoctor;
  DateTime? signedAt;
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
    this.icdCode,
    this.icdLabel,
    this.consultationId,
    this.signedByDoctor,
    this.signedAt,
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
      icdCode: json['icdCode']?.toString(),
      icdLabel: json['icdLabel']?.toString(),
      consultationId: json['consultationId']?.toString(),
      signedByDoctor: json['signedByDoctor']?.toString(),
      signedAt: json['signedAt'] != null ? DateTime.parse(json['signedAt']) : null,
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
      'icdCode': icdCode,
      'icdLabel': icdLabel,
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
  final icdCodeController = TextEditingController();
  final icdLabelController = TextEditingController();

  // Existing notes data
  final existingNotes = Rx<SoapNote?>(null);
  final isLoading = false.obs;
  final isSaving = false.obs;
  final isSigned = false.obs;
  final errorMessage = ''.obs;
  final String consultationId;

  DoctorSoapNotesController({required this.consultationId});

  @override
  void onInit() {
    super.onInit();
    fetchSoapNotes();
  }

  @override
  void onClose() {
    reasonController.dispose();
    subjectiveController.dispose();
    objectiveController.dispose();
    assessmentController.dispose();
    planController.dispose();
    diagnosisController.dispose();
    icdCodeController.dispose();
    icdLabelController.dispose();
    super.onClose();
  }



  // Validate fields before saving
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

  /// Fetch existing SOAP notes from backend
  Future<void> fetchSoapNotes() async {
    isLoading.value = true;
    try {
      final url = NestApiUrls.getSoapNotes(consultationId);
      final response = await _apiService.get(url);

      if (response.statusCode == 200) {
        if (response.data is List && (response.data as List).isNotEmpty) {
          existingNotes.value = SoapNote.fromJson(response.data[0]);
          _populateForm();
          isSigned.value = existingNotes.value?.isSigned ?? false;
        }
      }
    } catch (e) {
      print('Fetch SOAP notes error: $e');
      // Don't show error for first fetch, might be no notes yet
    } finally {
      isLoading.value = false;
    }
  }

  /// Populate form fields from existing notes
  void _populateForm() {
    if (existingNotes.value != null) {
      subjectiveController.text = existingNotes.value!.subjective;
      objectiveController.text = existingNotes.value!.objective;
      assessmentController.text = existingNotes.value!.assessment;
      planController.text = existingNotes.value!.plan;
      diagnosisController.text = existingNotes.value!.diagnosis;
      icdCodeController.text = existingNotes.value!.icdCode ?? '';
      icdLabelController.text = existingNotes.value!.icdLabel ?? '';
    }
  }

  /// Save SOAP notes (create or update)
  Future<bool> saveSoapNotes() async {
    if (!validateFields()) return false;

    isSaving.value = true;
    try {
      final url = NestApiUrls.createSoapNote(consultationId);
      final payload = {
        'subjective': subjectiveController.text.trim(),
        'objective': objectiveController.text.trim(),
        'assessment': assessmentController.text.trim(),
        'plan': planController.text.trim(),
        'diagnosis': diagnosisController.text.trim(),
        'icdCode': icdCodeController.text.trim(),
        'icdLabel': icdLabelController.text.trim(),
      };

      final response = await _apiService.post(url, data: payload);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          "Success",
          "SOAP notes saved successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        return true;
      } else {
        errorMessage.value = response.data['message'] ?? 'Failed to save SOAP notes';
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
      print('Save SOAP notes error: $e');
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

  /// Sign SOAP notes with confirmation
  Future<bool> signSoapNotes() async {
    if (!validateFields()) return false;

    isSaving.value = true;
    try {
      final url = NestApiUrls.createSoapNote(consultationId);
      final payload = {
        'subjective': subjectiveController.text.trim(),
        'objective': objectiveController.text.trim(),
        'assessment': assessmentController.text.trim(),
        'plan': planController.text.trim(),
        'diagnosis': diagnosisController.text.trim(),
        'icdCode': icdCodeController.text.trim(),
        'icdLabel': icdLabelController.text.trim(),
        'isSigned': true,
      };

      final response = await _apiService.post(url, data: payload);

      if (response.statusCode == 200 || response.statusCode == 201) {
        isSigned.value = true;
        existingNotes.value = SoapNote.fromJson(response.data);

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

  /// Reset form to initial state
  void resetForm() {
    subjectiveController.clear();
    objectiveController.clear();
    assessmentController.clear();
    planController.clear();
    diagnosisController.clear();
    icdCodeController.clear();
    icdLabelController.clear();
    errorMessage.value = '';
  }

  /// Check if form has been modified
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