import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/auth_screens/forgot_password.dart';

import '../widgets/validation_check_list.dart';

class SignInController extends GetxController {
  RxString signInType="doctor".obs;
  RxBool passwordVisibility=false.obs;

  RxBool isPasswordActive = false.obs;

  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  final RxString currentPassword = ''.obs;

  bool get hasMinLength => currentPassword.value.length >= 8;
  bool get hasUppercase => currentPassword.value.contains(RegExp(r'[A-Z]'));
  bool get hasDigit => currentPassword.value.contains(RegExp(r'[0-9]'));
  bool get hasSpecialChar => currentPassword.value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  void toggleVisibility() {
    passwordVisibility.value = !passwordVisibility.value;
  }

  List<ValidationRule> getValidationRules() {
    return [
      ValidationRule(
        text: 'At least 8 characters',
        isValid: hasMinLength,
      ),
      ValidationRule(
        text: 'At least one uppercase letter E.g: X,Y,Z',
        isValid: hasUppercase,
      ),
      ValidationRule(
        text: 'At least one number E.g: 1,2,3',
        isValid: hasDigit,
      ),
      ValidationRule(
        text: 'At least one special character E.g: @,!, \$',
        isValid: hasSpecialChar,
      ),
    ];
  }

  bool isPasswordValid() {
    return hasMinLength && hasUppercase && hasDigit && hasSpecialChar;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }
    if (!isPasswordValid()) {
      return 'Password does not meet all requirements.';
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

// Add a method to explicitly mark as interacted, used after form submit
  void markPasswordInteracted() {
    hasPasswordInteracted.value = true;
  }
  void goToForgotPasswordScreen(){
    Get.to(ForgotPassword());
  }




}