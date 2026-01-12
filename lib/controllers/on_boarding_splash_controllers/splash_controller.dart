import 'package:get/get.dart';
import 'package:patient_app/screens/auth_screens/sign_in_screen.dart';
import 'package:patient_app/screens/auth_screens/web_sign_in_screen.dart';
import 'package:patient_app/screens/doctor_screens/main_screen_doctor.dart';
import 'package:patient_app/screens/patient_screens/main_screen.dart';
import 'package:patient_app/screens/on_boarding_and_splash_screens/on_boarding_screen.dart';
import 'package:patient_app/screens/pharmacy_screens/main_screen_pharmacy.dart';
import 'package:patient_app/utils/app_bindings.dart';
import 'package:patient_app/utils/locat_storage.dart';

import '../../main.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    moveToNextScreen();
  }

  moveToNextScreen() async {
    await Future.delayed( Duration(seconds: isWeb?2:3), () async {
      await LocalStorageUtils.getLogined()
          ? Get.offAll(MainScreen(), binding: AppBinding())
          : await LocalStorageUtils.getLoginedDoctor()
          ? Get.offAll(MainScreenDoctor(), binding: AppBinding())
          : await LocalStorageUtils.getLoginedPharmacy()
          ? Get.offAll(MainScreenPharmacy())
          : await LocalStorageUtils.getFirstTime()
          ? isWeb?Get.offAll(WebSignInScreen()):Get.offAll(SignInScreen(), binding: AppBinding())
          : isWeb?Get.offAll(WebSignInScreen()):Get.offAll(OnBoardingScreen(), binding: AppBinding());
    });
  }
}
