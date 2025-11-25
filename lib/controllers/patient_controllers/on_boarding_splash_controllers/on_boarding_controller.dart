import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:patient_app/models/on_boarding_model.dart';
import 'package:patient_app/screens/on_boarding_and_splash_screens/data_privacy_consent.dart';
import 'package:patient_app/utils/shared_prefrence.dart';

class OnBoardingController extends GetxController {
  RxInt currentPageIndex = 0.obs;
  PageController pageController = PageController();
  void onPageChanged(int index) {
    currentPageIndex.value = index;
  }
  void nextPage() {
    if (currentPageIndex.value < 2) {
      pageController.nextPage(duration: 300.milliseconds, curve: Curves.easeInOut);
    }else{
      Get.to(DataPrivacyConsent());
    }
  }

  void skipPage() {
    Get.to(DataPrivacyConsent());

  }
List<OnBoardingModel> onBoardingPages = [
    OnBoardingModel(image: "assets/images/on_board_one.png", title: "Welcome to nawaQare",subtitle: "Book medical appointments and consult from anywhere"),
    OnBoardingModel(image: "assets/images/on_board_two.png", title: "Book your appointments 100% online"),
    OnBoardingModel(image: "assets/images/on_board_three.png", title: "Key Features",points:["Remote medical consultation","Online appointment booking","Intuitive user interface","Accessibility from anywhere"]),
  ];
}