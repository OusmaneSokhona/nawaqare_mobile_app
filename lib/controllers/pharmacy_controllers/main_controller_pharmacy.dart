import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/pharmacy_controllers/pharmacy_home_controller.dart';
import 'package:patient_app/controllers/pharmacy_controllers/pharmacy_prescription_controller.dart';
import 'package:patient_app/controllers/pharmacy_controllers/pharmacy_profile_controller.dart';
import 'package:patient_app/controllers/pharmacy_controllers/pharmacy_report_controller.dart';
import 'package:patient_app/screens/pharmacy_screens/pharmacy_home_screen.dart';
import 'package:patient_app/screens/pharmacy_screens/pharmacy_profile_screen.dart';
import 'package:patient_app/screens/pharmacy_screens/pharmacy_report_screen.dart';
import 'package:patient_app/screens/pharmacy_screens/prescription_screens/pharmacy_prescription_screen.dart';



class MainControllerPharmacy extends GetxController{
  PharmacyHomeController homeController=Get.put(PharmacyHomeController());
  PharmacyPrescriptionController prescriptionController=Get.put(PharmacyPrescriptionController());
  PharmacyReportController reportController=Get.put(PharmacyReportController());
  PharmacyProfileController profileController=Get.put(PharmacyProfileController());

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
    profileController.scrollValue.value=0.0;
    homeController.scrollValue.value=0.0;
    reportController.scrollValue.value=0.0;
  }
}