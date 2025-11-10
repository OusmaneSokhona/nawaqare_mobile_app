import 'package:get/get.dart';
import 'package:patient_app/screens/on_boarding_screen.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    moveToNextScreen();
  }

  moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3), () async {
      Get.offAll(OnBoardingScreen());
    });
  }
}
