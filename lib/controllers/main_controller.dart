import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/chat_controller.dart';
import 'package:patient_app/controllers/home_controller.dart';
import 'package:patient_app/controllers/profile_controller.dart';
import 'package:patient_app/controllers/search_controller.dart';
import 'package:patient_app/screens/chat_screens/chat_screen.dart';
import 'package:patient_app/screens/home_screen.dart';
import 'package:patient_app/screens/profile_screens/profile_screen.dart';
import 'package:patient_app/screens/search_screens/search_screen.dart';

class MainController extends GetxController{
  ProfileController profileController=Get.find();
  ChatController chatController=Get.find();
  HomeController homeController=Get.find();
  SearchControllerCustom searchController=Get.find();
  var currentIndex = 0.obs;
  var currentTitle = 'Home'.obs;
  final List<Widget> screens = [
    HomeScreen(),
    ChatScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];
  final List<String> titles = [
    'Home',
    'Chat',
    'Search',
    'Profile',
  ];

  void changePage(int index) {
    currentIndex.value = index;
    profileController.scrollValue.value=0.0;
    homeController.scrollValue.value=0.0;
    chatController.scrollValue.value=0.0;
    searchController.scrollValue.value=0.0;
  }
}