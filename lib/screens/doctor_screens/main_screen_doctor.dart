import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/main_controller_doctor.dart';
import 'package:patient_app/utils/app_strings.dart';

import '../../utils/app_colors.dart';

class MainScreenDoctor extends StatelessWidget {
  MainScreenDoctor({super.key});

  // Using Get.put to initialize the controller
  final MainControllerDoctor mainController = Get.put(MainControllerDoctor());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body updates based on the current index reactively
      body: Obx(() => mainController.screens[mainController.currentIndex.value]),

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
              icon: ImageIcon(const AssetImage("assets/images/chat_icon.png"), size: 22.h),
              label: AppStrings.chat.tr,
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(const AssetImage("assets/images/reception_icon.png"), size: 22.h),
              label: AppStrings.reception.tr,
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(const AssetImage("assets/images/profile_icon.png"), size: 22.h),
              label: AppStrings.profile.tr,
            ),
          ],
        ),
      ),
    );
  }
}