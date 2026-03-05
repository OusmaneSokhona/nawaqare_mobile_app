import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:patient_app/utils/api_urls.dart';
import '../../../services/api_service.dart';

class UpdatePasswordController extends GetxController {
  final ApiService apiService = ApiService();
  final GlobalKey<FormState> formKeyUpdate = GlobalKey<FormState>();

  final TextEditingController oldPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmNewPassword = TextEditingController();

  var oldPasswordVisibility = true.obs;
  var newPasswordVisibility = true.obs;
  var confirmNewPasswordVisibility = true.obs;

  var isLoading = false.obs;
  var isPasswordActive = false.obs;
  var currentPassword = ''.obs;

  void setPasswordActive(bool active) {
    isPasswordActive.value = active;
  }

  String? validateOldPassword(String? value) {
    if (value == null || value.isEmpty) return 'Old password is required';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'New password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    if (!value.contains(RegExp(r'[0-9]'))) return 'Must contain a number';
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return 'Must contain a special character';
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != newPassword.text) return 'Passwords do not match';
    return null;
  }

  Map<String, bool> getValidationRules() {
    return {
      "At least 8 characters": currentPassword.value.length >= 8,
      "Contains a number": currentPassword.value.contains(RegExp(r'[0-9]')),
      "Contains special character": currentPassword.value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
    };
  }

  Future<void> resetPasswordApi() async {
    if (!formKeyUpdate.currentState!.validate()) return;

    try {
      isLoading.value = true;

      Map<String, dynamic> data = {
        "oldPassword": oldPassword.text.trim(),
        "newPassword": newPassword.text.trim(),
      };

      final response = await apiService.post(
        ApiUrls.updatePasswordApi,
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        Get.snackbar('Success', 'Password updated successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      String errorMsg = "Failed to update password";
      if (e is dio.DioException && e.response?.data != null) {
        errorMsg = e.response?.data['message'] ?? errorMsg;
      }
      Get.snackbar('Error', errorMsg,
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    oldPassword.dispose();
    newPassword.dispose();
    confirmNewPassword.dispose();
    super.onClose();
  }
}