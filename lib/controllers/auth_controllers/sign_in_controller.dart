import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/auth_screens/forgot_password.dart';
import 'package:patient_app/screens/auth_screens/sign_up_screen.dart';
import 'package:patient_app/screens/doctor_screens/main_screen_doctor.dart';
import 'package:patient_app/screens/patient_screens/main_screen.dart';
import 'package:patient_app/utils/app_bindings.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/shared_prefrence.dart';

import '../../../widgets/validation_check_list.dart';

class SignInController extends GetxController {
  RxString signInType = "doctor".obs;
  RxBool passwordVisibility = false.obs;

  RxBool isPasswordActive = false.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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

  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required and cannot be empty.';
    }
    return null;
  }

  String? phoneNumberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required.';
    }

    // 1. Clean the input: Remove common non-digit characters (spaces, dashes, parens, dots)
    final cleanedValue = value.replaceAll(RegExp(r'[^\d+]'), '');

    // 2. Define a flexible pattern.
    // This pattern matches:
    // - Optional leading '+' (for international format)
    // - Followed by 7 to 15 digits (a reasonable range for most international and domestic numbers)
    const pattern = r'^\+?\d{7,15}$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(cleanedValue)) {
      // If you need to enforce a specific 10-digit US/Canadian format,
      // you would change the pattern to r'^\+?1?\d{10}$' and adjust the error message.
      return 'Please enter a valid phone number (7-15 digits, optional leading +).';
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
      ValidationRule(text: 'At least 8 characters', isValid: hasMinLength),
      ValidationRule(
        text: 'At least one uppercase letter E.g: X,Y,Z',
        isValid: hasUppercase,
      ),
      ValidationRule(text: 'At least one number E.g: 1,2,3', isValid: hasDigit),
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

  void markPasswordInteracted() {
    hasPasswordInteracted.value = true;
  }

  void goToForgotPasswordScreen() {
    Get.to(ForgotPassword());
  }

  void goToSignUpScreen() {
    Get.to(SignUpScreen());
  }

  void goToMainScreen() {
    Get.offAll(MainScreen(),binding: AppBinding());
  }

  void goToMainScreenDocotor() {
    Get.offAll(MainScreenDoctor(),binding: AppBinding());
  }

  void signInTap() {
    if (formKey.currentState!.validate()) {
      if (isPasswordValid()) {
        if (emailController.text == "patient@gmail.com") {
          goToMainScreen();
          LocalStorageUtils.setLogined();
        } else if (emailController.text == "doctor@gmail.com") {
          goToMainScreenDocotor();
          LocalStorageUtils.setLoginedDoctor();
        } else {
          Get.snackbar(
            "Invalid Credentials",
            "Wrong Email or Password",
          );
        }
      } else {
        markPasswordInteracted();
        FocusManager.instance.primaryFocus!.unfocus();
        print("Password validation failed.");
      }
    } else {
      markPasswordInteracted();
      print("Form validation failed.");
    }
  }
}
