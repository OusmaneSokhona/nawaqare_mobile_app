import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/chat_screens/chat_screen.dart';
import 'package:patient_app/screens/home_screen.dart';
import 'package:patient_app/screens/profile_screens/profile_screen.dart';
import 'package:patient_app/screens/search_screens/search_screen.dart';

class MainController extends GetxController{
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
  }
}