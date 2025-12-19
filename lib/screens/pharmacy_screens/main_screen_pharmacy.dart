import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/pharmacy_controllers/main_controller_pharmacy.dart';

import '../../utils/app_colors.dart';

class MainScreenPharmacy extends StatelessWidget {
  MainScreenPharmacy({super.key});
  MainControllerPharmacy mainController=Get.put(MainControllerPharmacy());
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
              icon:ImageIcon(AssetImage("assets/images/prescription_icon_bottom_bar.png"),size: 22.h,),
              label: 'Prescription',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/images/reports_icon.png"),size: 22.h,),
              label: 'Reports',
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
