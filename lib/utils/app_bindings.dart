import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_appoinment_controller.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_home_controller.dart';
import 'package:patient_app/controllers/patient_controllers/chat_controller.dart';
import 'package:patient_app/controllers/patient_controllers/home_controller.dart';
import 'package:patient_app/controllers/patient_controllers/profile_controller.dart';
import 'package:patient_app/controllers/patient_controllers/search_controller.dart';
import 'package:patient_app/controllers/pharmacy_controllers/pharmacy_access_log_controller.dart';
import 'package:patient_app/controllers/pharmacy_controllers/pharmacy_dispensing_controller.dart';
import 'package:patient_app/controllers/pharmacy_controllers/pharmacy_prescription_controller.dart';
import '../controllers/auth_controllers/forget_password_contorller.dart';
import '../controllers/auth_controllers/sign_in_controller.dart';
import '../controllers/auth_controllers/sign_up_controller.dart';
import '../controllers/doctor_controllers/doctor_profile_controller.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    // Auth Controllers
    Get.lazyPut(()=>SignInController());
    Get.lazyPut(()=>SignUpController());
    Get.lazyPut(()=>ForgetPasswordController());

    // Patient Controllers
    Get.lazyPut(()=>ProfileController());
    Get.lazyPut(()=>HomeController());
    Get.lazyPut(()=>ChatController());
    Get.lazyPut(()=>SearchControllerCustom());

    // Doctor Controllers
    Get.lazyPut(()=>DoctorHomeController());
    Get.lazyPut(()=>DoctorAppointmentController());
    Get.lazyPut(()=>DoctorProfileController());

    // Pharmacy Controllers
    Get.lazyPut(()=>PharmacyPrescriptionController());
    Get.lazyPut(()=>PharmacyDispensingController());
    Get.lazyPut(()=>PharmacyAccessLogController());
  }
}