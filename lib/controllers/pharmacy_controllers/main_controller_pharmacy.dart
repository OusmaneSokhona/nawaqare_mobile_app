import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/pharmacy_screens/pharmacy_home_screen.dart';
import 'package:patient_app/screens/pharmacy_screens/pharmacy_profile_screen.dart';
import 'package:patient_app/screens/pharmacy_screens/pharmacy_report_screen.dart';
import 'package:patient_app/screens/pharmacy_screens/prescription_screens/pharmacy_prescription_screen.dart';



class MainControllerPharmacy extends GetxController{
  var currentIndex = 0.obs;
  var currentTitle = 'Home'.obs;
  final List<Widget> screens = [
    PharmacyHomeScreen(),
    PharmacyPrescriptionScreen(),
    PharmacyReportScreen(),
    PharmacyProfileScreen(),
  ];

  void changePage(int index) {
    currentIndex.value = index;
  }
}