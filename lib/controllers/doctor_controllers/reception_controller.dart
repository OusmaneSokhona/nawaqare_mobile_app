import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReceptionController extends GetxController {
  ScrollController scrollController = ScrollController();
  RxDouble scrollValue = 0.0.obs;

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void scrollChange() {
    scrollController.addListener(() {
      scrollValue.value = scrollController.offset;
    });
  }
}