import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/api_service.dart';
import '../../../utils/nest_api_urls.dart';

enum ReferralUrgency { ROUTINE, URGENT, EMERGENCY }

class ReferenceLetter {
  String? id;
  String specialty;
  String urgency; // ROUTINE, URGENT, EMERGENCY
  String clinicalSummary;
  String reasonForReferral;
  String? status; // SENT, ACCEPTED, RESPONDED
  String? responseContent;
  String? consultationId;
  DateTime? sentAt;
  DateTime? acceptedAt;
  DateTime? respondedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  ReferenceLetter({
    this.id,
    required this.specialty,
    required this.urgency,
    required this.clinicalSummary,
    required this.reasonForReferral,
    this.status,
    this.responseContent,
    this.consultationId,
    this.sentAt,
    this.acceptedAt,
    this.respondedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory ReferenceLetter.fromJson(Map<String, dynamic> json) {
    return ReferenceLetter(
      id: json['id']?.toString(),
      specialty: json['specialty'] ?? '',
      urgency: json['urgency'] ?? 'ROUTINE',
      clinicalSummary: json['clinicalSummary'] ?? '',
      reasonForReferral: json['reasonForReferral'] ?? '',
      status: json['status']?.toString(),
      responseContent: json['responseContent']?.toString(),
      consultationId: json['consultationId']?.toString(),
      sentAt: json['sentAt'] != null ? DateTime.parse(json['sentAt']) : null,
      acceptedAt: json['acceptedAt'] != null ? DateTime.parse(json['acceptedAt']) : null,
      respondedAt: json['respondedAt'] != null ? DateTime.parse(json['respondedAt']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'specialty': specialty,
      'urgency': urgency,
      'clinicalSummary': clinicalSummary,
      'reasonForReferral': reasonForReferral,
    };
  }
}

class ReferenceLetterController extends GetxController {
  final ApiService _apiService = ApiService();

  // Form controllers
  final specialtyController = TextEditingController();
  final urgencyController = Rx<ReferralUrgency>(ReferralUrgency.ROUTINE);
  final clinicalSummaryController = TextEditingController();
  final reasonForReferralController = TextEditingController();

  // Data
  final referenceLetters = <ReferenceLetter>[].obs;
  final isLoading = false.obs;
  final isSaving = false.obs;
  final errorMessage = ''.obs;
  final String consultationId;

  ReferenceLetterController({required this.consultationId});

  @override
  void onInit() {
    super.onInit();
    fetchReferenceLetters();
  }

  @override
  void onClose() {
    specialtyController.dispose();
    clinicalSummaryController.dispose();
    reasonForReferralController.dispose();
    super.onClose();
  }

  /// Fetch reference letters from backend
  Future<void> fetchReferenceLetters() async {
    isLoading.value = true;
    try {
      final url = NestApiUrls.getReferenceLetters(consultationId);
      final response = await _apiService.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List ? response.data : [];
        referenceLetters.value = data.map((item) => ReferenceLetter.fromJson(item)).toList();
      }
    } catch (e) {
      print('Fetch reference letters error: $e');
      errorMessage.value = 'Failed to load reference letters';
    } finally {
      isLoading.value = false;
    }
  }

  /// Create and send referral letter
  Future<bool> sendReferralLetter() async {
    if (!_validateForm()) return false;

    isSaving.value = true;
    try {
      final url = NestApiUrls.createReferenceLetter(consultationId);
      final payload = {
        'specialty': specialtyController.text.trim(),
        'urgency': urgencyController.value.toString().split('.').last,
        'clinicalSummary': clinicalSummaryController.text.trim(),
        'reasonForReferral': reasonForReferralController.text.trim(),
        'status': 'SENT',
      };

      final response = await _apiService.post(url, data: payload);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newLetter = ReferenceLetter.fromJson(response.data);
        referenceLetters.add(newLetter);
        _resetForm();

        Get.snackbar(
          "Success",
          "Referral sent to specialist",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        return true;
      } else {
        errorMessage.value = response.data['message'] ?? 'Failed to send referral';
        Get.snackbar("Error", errorMessage.value, backgroundColor: Colors.red);
        return false;
      }
    } catch (e) {
      print('Send referral letter error: $e');
      errorMessage.value = 'An error occurred: $e';
      Get.snackbar("Error", errorMessage.value, backgroundColor: Colors.red);
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  /// Validate form fields
  bool _validateForm() {
    if (specialtyController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter specialty';
      return false;
    }
    if (clinicalSummaryController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter clinical summary';
      return false;
    }
    if (reasonForReferralController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter reason for referral';
      return false;
    }
    return true;
  }

  /// Reset form fields
  void _resetForm() {
    specialtyController.clear();
    urgencyController.value = ReferralUrgency.ROUTINE;
    clinicalSummaryController.clear();
    reasonForReferralController.clear();
    errorMessage.value = '';
  }

  /// Get status color based on letter status
  Color getStatusColor(String? status) {
    switch (status) {
      case 'SENT':
        return const Color(0xFF2F80ED); // Blue
      case 'ACCEPTED':
        return const Color(0xFF27AE60); // Green
      case 'RESPONDED':
        return const Color(0xFF6C5CE7); // Purple
      default:
        return const Color(0xFF828282); // Grey
    }
  }

  /// Get readable status text
  String getStatusLabel(String? status) {
    switch (status) {
      case 'SENT':
        return 'Sent';
      case 'ACCEPTED':
        return 'Accepted';
      case 'RESPONDED':
        return 'Responded';
      default:
        return status ?? 'Unknown';
    }
  }

  /// Get urgency badge color
  Color getUrgencyColor(String urgency) {
    switch (urgency) {
      case 'ROUTINE':
        return const Color(0xFF828282); // Grey
      case 'URGENT':
        return const Color(0xFFF2994A); // Orange
      case 'EMERGENCY':
        return const Color(0xFFEB4824); // Red
      default:
        return const Color(0xFF828282);
    }
  }
}
