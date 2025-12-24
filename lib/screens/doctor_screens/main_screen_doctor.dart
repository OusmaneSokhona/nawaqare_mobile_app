import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/main_controller_doctor.dart';

import '../../utils/app_colors.dart';

class MainScreenDoctor extends StatelessWidget {
   MainScreenDoctor({super.key});
  MainControllerDoctor mainController=Get.put(MainControllerDoctor());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          unselectedItemColor: Colors.grey,
          selectedItemColor: AppColors.primaryColor,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          backgroundColor:Colors.white,
          currentIndex: mainController.currentIndex.value,
          onTap: mainController.changePage,
          items:  [
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/images/home_icon.png"),size: 22.h,),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon:ImageIcon(AssetImage("assets/images/chat_icon.png"),size: 22.h,),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/images/reception_icon.png"),size: 22.h,),
              label: 'Reception',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/images/profile_icon.png"),size: 22.h,),
              label: 'Profile',
            ),
          ],
        ),
      ),
      body: Obx(()=>mainController.screens[mainController.currentIndex.value]),
    );
  }
}
