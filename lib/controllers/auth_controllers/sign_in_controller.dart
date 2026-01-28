import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/auth_screens/forgot_password.dart';
import 'package:patient_app/screens/auth_screens/sign_up_screen.dart';
import 'package:patient_app/screens/auth_screens/web_reset_password_screen.dart';
import 'package:patient_app/screens/auth_screens/web_sign_up_screen.dart';
import 'package:patient_app/screens/doctor_screens/main_screen_doctor.dart';
import 'package:patient_app/screens/patient_screens/main_screen.dart';
import 'package:patient_app/screens/pharmacy_screens/main_screen_pharmacy.dart';
import 'package:patient_app/services/api_service.dart';
import 'package:patient_app/utils/api_urls.dart';
import 'package:patient_app/utils/app_bindings.dart';
import 'package:patient_app/utils/locat_storage.dart';
import '../../utils/app_strings.dart';
import '../../../widgets/validation_check_list.dart';

class SignInController extends GetxController {
  final ApiService _apiService = ApiService();
  RxBool isLoading = false.obs;
  RxString signInType = "doctor".obs;
  RxBool passwordVisibility = false.obs;
  RxBool isPasswordActive = false.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.email.tr;
    }
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return AppStrings.email.tr;
    }
    return null;
  }

  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fullName.tr;
    }
    return null;
  }

  String? phoneNumberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.phoneNumber.tr;
    }
    final cleanedValue = value.replaceAll(RegExp(r'[^\d+]'), '');
    const pattern = r'^\+?\d{7,15}$';
    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(cleanedValue)) {
      return AppStrings.phoneNumber.tr;
    }
    return null;
  }

  final RxString currentPassword = ''.obs;

  bool get hasMinLength => currentPassword.value.length >= 8;
  bool get hasUppercase => currentPassword.value.contains(RegExp(r'[A-Z]'));
  bool get hasDigit => currentPassword.value.contains(RegExp(r'[0-9]'));
  bool get hasSpecialChar =>
      currentPassword.value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  void toggleVisibility() {
    passwordVisibility.value = !passwordVisibility.value;
  }

  List<ValidationRule> getValidationRules() {
    return [
      ValidationRule(text: AppStrings.atLeast8Chars.tr, isValid: hasMinLength),
      ValidationRule(text: AppStrings.atLeastOneUpper.tr, isValid: hasUppercase),
      ValidationRule(text: AppStrings.atLeastOneNumber.tr, isValid: hasDigit),
      ValidationRule(text: AppStrings.atLeastOneSpecial.tr, isValid: hasSpecialChar),
    ];
  }

  bool isPasswordValid() {
    return hasMinLength && hasUppercase && hasDigit && hasSpecialChar;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.password.tr;
    }
    if (!isPasswordValid()) {
      return AppStrings.incompleteCodeMsg.tr;
    }
    return null;
  }

  RxBool hasPasswordInteracted = false.obs;

  void setPasswordActive(bool isActive) {
    isPasswordActive.value = isActive;
    if (isActive || currentPassword.value.isNotEmpty) {
      hasPasswordInteracted.value = true;
    }
  }

  void markPasswordInteracted() {
    hasPasswordInteracted.value = true;
  }

  void goToForgotPasswordScreen() {
    Get.to(ForgotPassword());
  }

  void goToForgotPasswordScreenWeb() {
    Get.to(WebResetPasswordScreen());
  }

  void goToSignUpScreen() {
    Get.to(SignUpScreen(), binding: AppBinding());
  }

  void goToSignUpScreenWeb() {
    Get.to(WebSignUpScreen(), binding: AppBinding());
  }

  void goToMainScreen() {
    Get.offAll(MainScreen(), binding: AppBinding());
  }

  void goToMainScreenDocotor() {
    Get.offAll(MainScreenDoctor(), binding: AppBinding());
  }

  void goToMainScreenPharmacist() {
    Get.offAll(MainScreenPharmacy(), binding: AppBinding());
  }

  Future<void> signInTap() async {
    if (formKey.currentState!.validate()) {
      if (isPasswordValid()) {
        try {
          isLoading.value = true;
          final Map<String, dynamic> loginData = {
            "email": emailController.text.trim(),
            "password": passwordController.text,
          };
         print("Login Data: $loginData");
          final response = await _apiService.post(
            ApiUrls.signInUrl,
            data: loginData,
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            final String role = response.data['user']['role'];
           print("User role: $role");
            if (role == "patient") {
              LocalStorageUtils.setLogined();
              goToMainScreen();
            } else if (role == "doctor") {
              LocalStorageUtils.setLoginedDoctor();
              goToMainScreenDocotor();
            } else if (role == "pharmacy") {
              LocalStorageUtils.setLoginedPharmacy();
              goToMainScreenPharmacist();
            }
            clearControllers();
          }
        } catch (e) {
          String errorMessage = "An unexpected error occurred";
          print("Error during sign-in: $e");
          if (e is DioException) {
            if (e.response != null && e.response!.data != null) {
              errorMessage = e.response!.data["message"] ?? "Server Error";
            } else {
              errorMessage = "No response from server";
            }
          }
          Get.snackbar("Error", errorMessage, backgroundColor: Colors.red, colorText: Colors.white);
        } finally {
          isLoading.value = false;
        }
      } else {
        markPasswordInteracted();
        FocusManager.instance.primaryFocus!.unfocus();
      }
    } else {
      markPasswordInteracted();
    }
  }

  void webSignInTap() async {
    if (formKey.currentState!.validate()) {
      if (isPasswordValid()) {
        try {
          isLoading.value = true;
          final response = await _apiService.post(
            ApiUrls.signInUrl,
            data: {
              "email": emailController.text.trim(),
              "password": passwordController.text,
            },
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            LocalStorageUtils.setLoginedDoctor();
            goToMainScreenDocotor();
            clearControllers();
          }
        } catch (e) {
          Get.snackbar("Warning", "Wrong Credentials", backgroundColor: Colors.red, colorText: Colors.white);
        } finally {
          isLoading.value = false;
        }
      } else {
        markPasswordInteracted();
        FocusManager.instance.primaryFocus!.unfocus();
      }
    } else {
      markPasswordInteracted();
    }
  }
}