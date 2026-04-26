import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/services/api_service.dart';
import 'package:patient_app/utils/api_urls.dart';


class FeedbackController extends GetxController {
  var selectedRating = 0.obs;
  var reviewText = ''.obs;
  var isSubmitting = false.obs;

  final ApiService apiService = ApiService();
  final String appointmentId;

  FeedbackController({required this.appointmentId});

  void setRating(int rating) {
    selectedRating.value = rating;
  }

  void updateReviewText(String text) {
    reviewText.value = text;
  }

  bool get isSendButtonEnabled => selectedRating.value > 0 && !isSubmitting.value;

  Future<void> sendFeedback(Function onComplete) async {
    if (!isSendButtonEnabled) return;

    isSubmitting.value = true;

    try {
      final Map<String, dynamic> requestBody = {
        'appointmentId': appointmentId,
        'review': reviewText.value,
        'rating': selectedRating.value,
      };

      final response = await apiService.post(
        ApiUrls.submitReviewApi,
        data: requestBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        onComplete();
        Get.snackbar(
          'Success',
          'Your feedback has been submitted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw Exception('Failed to submit feedback: ${response.statusCode}');
      }
    } catch (e) {
      print('Error submitting feedback: $e');
      Get.snackbar(
        'Error',
        'Failed to submit feedback. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  void viewPrescription() {
    Get.snackbar(
      'Action',
      'Viewing prescription',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF4285F4),
      colorText: Colors.white,
    );
  }
}