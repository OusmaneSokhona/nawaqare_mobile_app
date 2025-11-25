import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/chat_controller.dart';
import 'package:patient_app/controllers/patient_controllers/home_controller.dart';
import 'package:patient_app/controllers/patient_controllers/profile_controller.dart';
import 'package:patient_app/controllers/patient_controllers/search_controller.dart';
import '../controllers/patient_controllers/auth_controllers/forget_password_contorller.dart';
import '../controllers/patient_controllers/auth_controllers/sign_in_controller.dart';
import '../controllers/patient_controllers/auth_controllers/sign_up_controller.dart';

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