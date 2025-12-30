import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/pharmacy_controllers/main_controller_pharmacy.dart';
import 'package:patient_app/utils/app_strings.dart';

import '../../utils/app_colors.dart';

class MainScreenPharmacy extends StatelessWidget {
  MainScreenPharmacy({super.key});
  final MainControllerPharmacy mainController = Get.put(MainControllerPharmacy());

  @override
  Widget build(BuildContext context) {
    mainController.currentIndex.value=0;
    return Scaffold(
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          unselectedItemColor: Colors.grey,
          selectedItemColor: AppColors.primaryColor,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          backgroundColor: Colors.white,
          currentIndex: mainController.currentIndex.value,
          onTap: mainController.changePage,
          items: [
            BottomNavigationBarItem(
              icon: ImageIcon(const AssetImage("assets/images/home_icon.png"), size: 22.h),
              label: AppStrings.home.tr,
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(const AssetImage("assets/images/prescription_icon_bottom_bar.png"), size: 22.h),
              label: AppStrings.prescription.tr,
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(const AssetImage("assets/images/reports_icon.png"), size: 22.h),
              label: AppStrings.reports.tr,
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(const AssetImage("assets/images/profile_icon.png"), size: 22.h),
              label: AppStrings.profile.tr,
            ),
          ],
        ),
      ),
      body: Obx(() => mainController.screens[mainController.currentIndex.value]),
    );
  }
}