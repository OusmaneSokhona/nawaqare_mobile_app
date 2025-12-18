import 'package:get/get.dart';
import 'package:patient_app/controllers/language_controller.dart';

class AppStrings {
  static LanguageController get _controller => Get.put(LanguageController());

  static RxBool get isEnglish => (_controller.language.value == "english").obs;

  static String get myName => isEnglish.value ? "English" : "French";
  static const String loginButton = "Log In";
  static const String signUpButton = "Sign Up";
  static const String logoutButton = "Log Out";
  static const String forgotPassword = "Forgot Password?";
  static const String resetPassword = "Reset Password";
  static const String fullName="Full Name";
  static const String email="Email";
  static const String password="Password";
  static const String phoneNumber="Phone Number";
  static const String gender="Gender";
}