import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:patient_app/utils/api_urls.dart';
import 'package:patient_app/services/api_service.dart';
import '../../../screens/auth_screens/sign_in_screen.dart';
import '../../../widgets/validation_check_list.dart';
import '../../utils/app_strings.dart';

class ForgetPasswordController extends GetxController {
  final ApiService _apiService = ApiService();
  final int _initialTime = 60;
  RxInt timerCount = 60.obs;
  RxBool isTimerActive = true.obs;
  RxBool isLoading = false.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  Timer? timer;

  final List<TextEditingController> controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  final RxList<String> _currentCode = List.filled(6, '').obs;

  String get completeCode => _currentCode.join();
  final RxBool isCodeComplete = false.obs;

  final RxString currentPassword = ''.obs;
  RxBool isPasswordActive = false.obs;
  TextEditingController newPassword = TextEditingController();
  TextEditingController confrimNewPassword = TextEditingController();
  RxBool newPasswordVisibility = false.obs;
  RxBool confirmNewPasswordVisibility = false.obs;
  final GlobalKey<FormState> formKeyForget = GlobalKey<FormState>();

  void startTimer() {
    timerCount.value = _initialTime;
    isTimerActive.value = true;
    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerCount.value > 0) {
        timerCount.value--;
      } else {
        timer.cancel();
        isTimerActive.value = false;
      }
    });
  }

  void handleCodeChange(int index, String value) {
    if (value.isNotEmpty) {
      _currentCode[index] = value;
      isCodeComplete.value = completeCode.length == 6;

      if (index < controllers.length - 1) {
        FocusScope.of(Get.context!).requestFocus(focusNodes[index + 1]);
      } else {
        focusNodes[index].unfocus();
      }
    } else {
      _currentCode[index] = '';
      isCodeComplete.value = false;
      if (index > 0) {
        controllers[index].clear();
        FocusScope.of(Get.context!).requestFocus(focusNodes[index - 1]);
      }
    }
  }

  Future<bool> sendResetOtp({bool isEmail = true}) async {
    try {
      isLoading.value = true;
      String url = isEmail ? ApiUrls.sendResetPasswordEmailOtpUrl : ApiUrls.sendResetPasswordPhoneOtpUrl;
      Map<String, dynamic> data = isEmail
          ? {"email": emailController.text.trim()}
          : {"phoneNumber": phoneController.text.trim()};

      final response = await _apiService.post(url, data: data);
      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("OTP sent: ${response.data}");
        Get.snackbar("Success", "OTP sent successfully",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        startTimer();
        return true;
      }
      return false;
    } catch (e) {
      isLoading.value = false;
      _handleError(e);
      return false;
    }
  }

  Future<bool> verifyResetOtp() async {
    try {
      isLoading.value = true;
      bool isEmail = emailController.text.isNotEmpty;

      Map<String, dynamic> data = {
        "otp": completeCode,
      };

      if (isEmail) {
        data["email"] = emailController.text.trim();
      } else {
        data["phoneNumber"] = phoneController.text.trim();
      }

      final response = await _apiService.post(
        ApiUrls.verifyResetPasswordEmailOtpUrl,
        data: data,
      );

      isLoading.value = false;
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      isLoading.value = false;
      _handleError(e);
      return false;
    }
  }

  Future<bool> resetPassword() async {
    try {
      isLoading.value = true;
      bool isEmail = emailController.text.isNotEmpty;

      Map<String, dynamic> data = {
        "newPassword": newPassword.text,
        "confirmPassword": confrimNewPassword.text,
      };

      if (isEmail) {
        data["email"] = emailController.text.trim();
      } else {
        data["phoneNumber"] = phoneController.text.trim();
      }

      final response = await _apiService.post(ApiUrls.resetPasswordUrl, data: data);

      isLoading.value = false;
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Password reset successfully",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        return true;
      }
      return false;
    } catch (e) {
      isLoading.value = false;
      _handleError(e);
      return false;
    }
  }

  void _handleError(dynamic e) {
    String errorMessage = "An error occurred";
    if (e is DioException && e.response?.data != null) {
      errorMessage = e.response!.data["message"] ?? e.response!.data.toString();
    }
    Get.snackbar("Error", errorMessage,
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
  }

  void clearAllFields() {
    for (var controller in controllers) { controller.clear(); }
    _currentCode.value = List.filled(6, '');
    isCodeComplete.value = false;
    if (Get.context != null) { FocusScope.of(Get.context!).requestFocus(focusNodes[0]); }
  }

  String formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  bool get hasMinLength => currentPassword.value.length >= 8;
  bool get hasUppercase => currentPassword.value.contains(RegExp(r'[A-Z]'));
  bool get hasDigit => currentPassword.value.contains(RegExp(r'[0-9]'));
  bool get hasSpecialChar => currentPassword.value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  void setPasswordActive(bool isActive) { isPasswordActive.value = isActive; }

  List<ValidationRule> getValidationRules() {
    return [
      ValidationRule(text: AppStrings.atLeast8Chars.tr, isValid: hasMinLength),
      ValidationRule(text: AppStrings.atLeastOneUpper.tr, isValid: hasUppercase),
      ValidationRule(text: AppStrings.atLeastOneNumber.tr, isValid: hasDigit),
      ValidationRule(text: AppStrings.atLeastOneSpecial.tr, isValid: hasSpecialChar),
    ];
  }

  bool isPasswordValid() => hasMinLength && hasUppercase && hasDigit && hasSpecialChar;

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return AppStrings.confirmPassword.tr;
    if (!isPasswordValid()) return AppStrings.incompleteCodeMsg.tr;
    if (value != newPassword.text) return AppStrings.passwordNotMatch.tr;
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return AppStrings.password.tr;
    if (!isPasswordValid()) return AppStrings.incompleteCodeMsg.tr;
    return null;
  }

  void moveToSignInScreen() {
    confrimNewPassword.clear();
    newPassword.clear();
    emailController.clear();
    phoneController.clear();
    for (var controller in controllers) { controller.clear(); }
    Get.to(SignInScreen());
  }

  @override
  void onClose() {
    timer?.cancel();
    emailController.dispose();
    phoneController.dispose();
    for (var controller in controllers) { controller.dispose(); }
    for (var node in focusNodes) { node.dispose(); }
    super.onClose();
  }
}