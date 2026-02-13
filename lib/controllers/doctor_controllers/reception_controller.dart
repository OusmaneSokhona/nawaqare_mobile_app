import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReceptionController extends GetxController {
  ScrollController scrollControllerNew = ScrollController();
  RxDouble scrollValue = 0.0.obs;

  @override
  void onClose() {
    scrollControllerNew.dispose();
    super.onClose();
  }
@override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    scrollChange();
  }
  void scrollChange() {
    scrollControllerNew.addListener(() {
      scrollValue.value = scrollControllerNew.offset;
    });
  }
}