import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/auth_screens/forgot_password.dart';
import 'package:patient_app/screens/auth_screens/sign_up_screen.dart';
import 'package:patient_app/screens/doctor_screens/main_screen_doctor.dart';
import 'package:patient_app/screens/patient_screens/main_screen.dart';
import 'package:patient_app/screens/pharmacy_screens/main_screen_pharmacy.dart';
import 'package:patient_app/utils/app_bindings.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/shared_prefrence.dart';
import '../../utils/app_strings.dart';

import '../../../widgets/validation_check_list.dart';

class SignInController extends GetxController {
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

  void goToSignUpScreen() {
    Get.to(SignUpScreen(), binding: AppBinding());
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

  void signInTap() {
    if (formKey.currentState!.validate()) {
      if (isPasswordValid()) {
        if (emailController.text == "patient@gmail.com") {
          goToMainScreen();
          clearControllers();
          LocalStorageUtils.setLogined();
        } else if (emailController.text == "doctor@gmail.com") {
          goToMainScreenDocotor();
          clearControllers();
          LocalStorageUtils.setLoginedDoctor();
        } else if (emailController.text == "pharmacy@gmail.com") {
          goToMainScreenPharmacist();
          clearControllers();
          LocalStorageUtils.setLoginedPharmacy();
        } else {
          Get.snackbar(
            AppStrings.signIn.tr,
            AppStrings.incompleteCodeMsg.tr,
          );
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