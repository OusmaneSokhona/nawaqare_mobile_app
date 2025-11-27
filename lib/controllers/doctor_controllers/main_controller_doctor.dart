import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_home_controller.dart';
import 'package:patient_app/controllers/patient_controllers/chat_controller.dart';
import 'package:patient_app/screens/doctor_screens/doctor_home_screen.dart';
import '../../screens/patient_screens/chat_screens/chat_screen.dart';


class MainControllerDoctor extends GetxController{
  ChatController chatController=Get.find();
  DoctorHomeController homeController=Get.find();
  var currentIndex = 0.obs;
  var currentTitle = 'Home'.obs;
  final List<Widget> screens = [
   DoctorHomeScreen(),
    ChatScreen(),
    Scaffold(body: Center(child: Text("Consultation"),),),
    Scaffold(body: Center(child: Text("Profile"),),),
  ];
  final List<String> titles = [
    'Home',
    'Chat',
    'Search',
    'Profile',
  ];

  void changePage(int index) {
    currentIndex.value = index;
    homeController.scrollValue.value=0.0;
    chatController.scrollValue.value=0.0;
  }
}