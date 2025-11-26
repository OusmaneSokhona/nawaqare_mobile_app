import 'package:flutter/material.dart';
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
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon:Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Consultation',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_outlined),
              label: 'Profile',
            ),
          ],
        ),
      ),
      body: Obx(()=>mainController.screens[mainController.currentIndex.value]),
    );
  }
}
