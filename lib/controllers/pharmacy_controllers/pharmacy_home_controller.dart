import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PharmacyHomeController extends GetxController{
  ScrollController scrollController=ScrollController();
  RxDouble scrollValue=0.0.obs;
  void scrollChange(){
    scrollController.addListener((){
      scrollValue.value=scrollController.offset;
      print(scrollValue);
    });
  }
}