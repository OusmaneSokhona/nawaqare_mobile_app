import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/api_service.dart';
import '../../../utils/nest_api_urls.dart';

enum CertificateType {
  MEDICAL_CERTIFICATE,
  SICK_LEAVE,
  ATTESTATION,
}

class MedicalCertificate {
  String? id;
  String type; // MEDICAL_CERTIFICATE, SICK_LEAVE, ATTESTATION
  String content;
  int? durationDays; // For SICK_LEAVE
  bool? isSigned;
  String? signedByDoctor;
  DateTime? signedAt;
  String? consultationId;
  DateTime? createdAt;
  DateTime? updatedAt;

  MedicalCertificate({
    this.id,
    required this.type,
    required this.content,
    this.durationDays,
    this.isSigned,
    this.signedByDoctor,
    this.signedAt,
    this.consultationId,
    this.createdAt,
    this.updatedAt,
  });

  factory MedicalCertificate.fromJson(Map<String, dynamic> json) {
    return MedicalCertificate(
      id: json['id']?.toString(),
      type: json['type'] ?? 'MEDICAL_CERTIFICATE',
      content: json['content'] ?? '',
      durationDays: json['durationDays'],
      isSigned: json['isSigned'] ?? false,
      signedByDoctor: json['signedByDoctor']?.toString(),
      signedAt: json['signedAt'] != null ? DateTime.parse(json['signedAt']) : null,
      consultationId: json['consultationId']?.toString(),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'content': content,
      if (durationDays != null) 'durationDays': durationDays,
    };
  }
}

class MedicalCertificateController extends GetxController {
  final ApiService _apiService = ApiService();

  // Form controllers
  final typeController = Rx<CertificateType>(CertificateType.MEDICAL_CERTIFICATE);
  final contentController = TextEditingController();
  final durationController = TextEditingController();
  final isSignedCheckbox = false.obs;

  // Data
  final certificates = <MedicalCertificate>[].obs;
  final isLoading = false.obs;
  final isSaving = false.obs;
  final errorMessage = ''.obs;
  final String consultationId;

  MedicalCertificateController({required this.consultationId});

  @override
  void onInit() {
    super.onInit();
    fetchCertificates();
  }

  @override
  void onClose() {
    contentController.dispose();
    durationController.dispose();
    super.onClose();
  }

  /// Fetch certificates from backend
  Future<void> fetchCertificates() async {
    isLoading.value = true;
    try {
      final url = NestApiUrls.getCertificates(consultationId);
      final response = await _apiService.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List ? response.data : [];
        certificates.value = data.map((item) => MedicalCertificate.fromJson(item)).toList();
      }
    } catch (e) {
      print('Fetch certificates error: $e');
      errorMessage.value = 'Failed to load certificates';
    } finally {
      isLoading.value = false;
    }
  }

  /// Create and sign new certificate
  Future<bool> createAndSignCertificate() async {
    if (!_validateForm()) return false;

    isSaving.value = true;
    try {
      final url = NestApiUrls.createCertificate(consultationId);
      final payload = {
        'type': typeController.value.toString().split('.').last,
        'content': contentController.text.trim(),
        if (typeController.value == CertificateType.SICK_LEAVE &&
            durationController.text.isNotEmpty)
          'durationDays': int.tryParse(durationController.text) ?? 1,
        'isSigned': isSignedCheckbox.value,
      };

      final response = await _apiService.post(url, data: payload);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newCertificate = MedicalCertificate.fromJson(response.data);
        certificates.add(newCertificate);
        _resetForm();

        Get.snackbar(
          "Success",
          "Certificate created and ${isSignedCheckbox.value ? 'signed' : 'saved'}",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        return true;
      } else {
        errorMessage.value = response.data['message'] ?? 'Failed to create certificate';
        Get.snackbar("Error", errorMessage.value, backgroundColor: Colors.red);
        return false;
      }
    } catch (e) {
      print('Create certificate error: $e');
      errorMessage.value = 'An error occurred: $e';
      Get.snackbar("Error", errorMessage.value, backgroundColor: Colors.red);
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  /// Validate form fields
  bool _validateForm() {
    if (contentController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter certificate content';
      return false;
    }
    if (typeController.value == CertificateType.SICK_LEAVE &&
        durationController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter duration in days';
      return false;
    }
    if (!isSignedCheckbox.value) {
      errorMessage.value = 'Please confirm you are signing this document';
      return false;
    }
    return true;
  }

  /// Reset form fields
  void _resetForm() {
    typeController.value = CertificateType.MEDICAL_CERTIFICATE;
    contentController.clear();
    durationController.clear();
    isSignedCheckbox.value = false;
    errorMessage.value = '';
  }

  /// Get certificate type label
  String getCertificateTypeLabel(String type) {
    switch (type) {
      case 'MEDICAL_CERTIFICATE':
        return 'Medical Certificate';
      case 'SICK_LEAVE':
        return 'Sick Leave';
      case 'ATTESTATION':
        return 'Attestation';
      default:
        return type;
    }
  }

  /// Get certificate type color
  Color getCertificateTypeColor(String type) {
    switch (type) {
      case 'MEDICAL_CERTIFICATE':
        return const Color(0xFF2F80ED); // Blue
      case 'SICK_LEAVE':
        return const Color(0xFFF2994A); // Orange
      case 'ATTESTATION':
        return const Color(0xFF6C5CE7); // Purple
      default:
        return const Color(0xFF828282); // Grey
    }
  }
}
