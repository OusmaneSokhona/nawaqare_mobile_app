import 'package:get/get.dart';
import 'package:patient_app/screens/auth_screens/sign_in_screen.dart';
import 'package:patient_app/screens/main_screen.dart';
import 'package:patient_app/screens/on_boarding_and_splash_screens/on_boarding_screen.dart';
import 'package:patient_app/utils/shared_prefrence.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    moveToNextScreen();
  }

  moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3), () async {
      await LocalStorageUtils.getLogined()?Get.offAll(MainScreen()):
      await LocalStorageUtils.getFirstTime()?Get.offAll(SignInScreen()):
      Get.offAll(OnBoardingScreen());
    });
  }
}
