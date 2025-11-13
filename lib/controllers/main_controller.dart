import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/home_screen.dart';

class MainController extends GetxController{
  var currentIndex = 0.obs; // Use .obs for reactive state
  var currentTitle = 'Home'.obs;
  final List<Widget> screens = [
    HomeScreen(),
    Scaffold(body: Center(child: Text("Coming Soon Chat"),),),
    Scaffold(body: Center(child: Text("Coming Soon Search"),),),
    Scaffold(body: Center(child: Text("Coming Soon Profile"),),),
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