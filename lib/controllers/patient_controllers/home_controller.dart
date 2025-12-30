import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../models/appointment_model.dart';

class HomeController extends GetxController{
  ScrollController scrollController=ScrollController();
  RxDouble scrollValue=0.0.obs;
  void scrollChange(){
    scrollController.addListener((){
      scrollValue.value=scrollController.offset;
      print(scrollValue);
    });
  }
}