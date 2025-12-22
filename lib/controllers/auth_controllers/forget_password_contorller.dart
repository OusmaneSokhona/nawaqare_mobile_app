import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../screens/auth_screens/sign_in_screen.dart';
import '../../../widgets/validation_check_list.dart';
import '../../utils/app_strings.dart';

class ForgetPasswordController extends GetxController {
  final int _initialTime = 60;
  RxInt timerCount = 60.obs;
  RxBool isTimerActive = true.obs;
  Timer? timer;

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
        Get.snackbar(
          AppStrings.verification.tr,
          AppStrings.requestNewCode.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFF44336),
          colorText: const Color(0xFFFFFFFF),
        );
      }
    });
  }

  final List<TextEditingController> controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  final RxList<String> _currentCode = List.filled(6, '').obs;

  String get completeCode => _currentCode.join();
  final RxBool isCodeComplete = false.obs;

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

  void completeCodeVerification() {
    if (completeCode.length == 6) {
      print('Verification Code Ready: $completeCode');
    } else {
      Get.snackbar(
          AppStrings.incompleteCode.tr,
          AppStrings.incompleteCodeMsg.tr,
          snackPosition: SnackPosition.BOTTOM
      );
    }
  }

  void clearAllFields() {
    for (var controller in controllers) {
      controller.clear();
    }
    _currentCode.value = List.filled(6, '');
    isCodeComplete.value = false;
    if (Get.context != null) {
      FocusScope.of(Get.context!).requestFocus(focusNodes[0]);
    }
  }

  String formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  final RxString currentPassword = ''.obs;
  bool get hasMinLength => currentPassword.value.length >= 8;
  bool get hasUppercase => currentPassword.value.contains(RegExp(r'[A-Z]'));
  bool get hasDigit => currentPassword.value.contains(RegExp(r'[0-9]'));
  bool get hasSpecialChar => currentPassword.value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  RxBool isPasswordActive = false.obs;
  TextEditingController newPassword = TextEditingController();
  TextEditingController confrimNewPassword = TextEditingController();
  RxBool newPasswordVisibility = false.obs;
  RxBool confirmNewPasswordVisibility = false.obs;
  final GlobalKey<FormState> formKeyForget = GlobalKey<FormState>();

  void setPasswordActive(bool isActive) {
    isPasswordActive.value = isActive;
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

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.confirmPassword.tr;
    }
    if (!isPasswordValid()) {
      return AppStrings.incompleteCodeMsg.tr;
    }
    if (value != newPassword.text) {
      return 'Passwords do not match.';
    }
    return null;
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

  void moveToSignInScreen() {
    confrimNewPassword.clear();
    newPassword.clear();
    for (var controller in controllers) {
      controller.clear();
    }
    Get.to(SignInScreen());
  }

  @override
  void onClose() {
    timer?.cancel();
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}