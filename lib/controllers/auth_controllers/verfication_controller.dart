import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/auth_screens/web_reset_password_screen.dart';

class VerificationController extends GetxController {
  final List<TextEditingController> controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  var secondsRemaining = 60.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    secondsRemaining.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  String get timerText {
    int minutes = secondsRemaining.value ~/ 60;
    int seconds = secondsRemaining.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void handleInput(String value, int index) {
    if (value.length == 1 && index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  void verifyAndNavigate() {
    String otp = controllers.map((e) => e.text).join();
    if (otp.length == 6) {
      Get.back();
      Get.to(WebResetPasswordScreen());
    }else{
      Get.snackbar("Warning", "Please Add Verification Code",backgroundColor: Colors.red,colorText: Colors.white);
    }

  }

  @override
  void onClose() {
    _timer?.cancel();
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}