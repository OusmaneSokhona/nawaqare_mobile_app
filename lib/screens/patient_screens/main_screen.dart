import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/main_controller.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../utils/app_colors.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final MainController mainController = Get.put(MainController());

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
              icon: ImageIcon(
                const AssetImage("assets/images/home_icon.png"),
                size: 22.h,
              ),
              label: AppStrings.home.tr,
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                const AssetImage("assets/images/chat_icon.png"),
                size: 22.h,
              ),
              label: AppStrings.chat.tr,
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                const AssetImage("assets/images/search_icon.png"),
                size: 22.h,
              ),
              label: AppStrings.search.tr,
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                const AssetImage("assets/images/profile_icon.png"),
                size: 22.h,
              ),
              label: AppStrings.profile.tr,
            ),
          ],
        ),
      ),
      body: Obx(() => mainController.screens[mainController.currentIndex.value]),
    );
  }
}