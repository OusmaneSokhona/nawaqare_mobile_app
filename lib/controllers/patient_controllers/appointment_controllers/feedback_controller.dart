import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/patient_screens/main_screen.dart';

class FeedbackController extends GetxController {
  var selectedRating = 0.obs;
  var reviewText = ''.obs;

  void setRating(int rating) {
    selectedRating.value = rating;
  }

  void updateReviewText(String text) {
    reviewText.value = text;
  }

  bool get isSendButtonEnabled => selectedRating.value > 0;

  void sendFeedback() {
    Get.offAll(MainScreen());
  }

  void viewPrescription() {
    Get.snackbar(
      'Action',
      'Viewing prescription for Dr. Maria Waston',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF4285F4),
      colorText: Colors.white,
    );
  }
}