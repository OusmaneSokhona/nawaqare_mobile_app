import 'package:get/get.dart';
import 'package:patient_app/controllers/auth_controllers/forget_password_contorller.dart';
import 'package:patient_app/controllers/auth_controllers/sign_up_controller.dart';
import 'package:patient_app/controllers/chat_controller.dart';
import 'package:patient_app/controllers/home_controller.dart';
import 'package:patient_app/controllers/profile_controller.dart';
import 'package:patient_app/controllers/search_controller.dart';
import '../controllers/auth_controllers/sign_in_controller.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=>SignInController());
    Get.lazyPut(()=>SignUpController());
    Get.lazyPut(()=>ForgetPasswordController());
    Get.lazyPut(()=>ProfileController());
    Get.lazyPut(()=>HomeController());
    Get.lazyPut(()=>ChatController());
    Get.lazyPut(()=>SearchControllerCustom());
  }
}