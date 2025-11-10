import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  RxString signInType="doctor".obs;
  RxBool passwordVisibility=false.obs;
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

  // CORRECT SIGNATURE: Accepts one String? value argument
  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long.';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain an uppercase letter.';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain a digit.';
    }
    return null;
  }


}