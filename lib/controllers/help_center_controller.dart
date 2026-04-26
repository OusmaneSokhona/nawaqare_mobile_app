import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/services/api_service.dart';
import 'package:patient_app/utils/api_urls.dart';

class HelpCenterController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var contactEmail = ''.obs;
  var contactPhone = ''.obs;
  var faqs = <FaqModel>[].obs;
  var isFaqExpanded = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHelpCenterDetails();
  }

  void toggleFaq() {
    isFaqExpanded.value = !isFaqExpanded.value;
  }

  Future<void> fetchHelpCenterDetails() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(ApiUrls.helpCenter);

      if (response.data['success'] == true) {
        final data = response.data['data'];

        if (data['contact'] != null) {
          contactEmail.value = data['contact']['email'] ?? '';
          contactPhone.value = data['contact']['phoneNumber'] ?? '';
        }

        if (data['faqs'] != null && data['faqs'] is List) {
          faqs.value = (data['faqs'] as List)
              .map((faq) => FaqModel.fromJson(faq))
              .toList();
        }
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to load help center details',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

class FaqModel {
  final String id;
  final String question;
  final String answer;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  FaqModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['_id'] ?? '',
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}