import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/patient_controllers/appointment_controllers/setting_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/patient_widgets/video_call_widgets/setting widgets.dart';

class SettingScreen extends StatelessWidget {
   SettingScreen({super.key});
SettingsController controller=Get.put(SettingsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.onboardingBackground, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              70.verticalSpace,
              Row(
                children: [
                  InkWell(onTap: (){Get.back();}, child: Image.asset("assets/images/back_icon.png",height: 22.h,)),
                  10.horizontalSpace,
                  Text(
                    "Settings",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
          Expanded(child: SingleChildScrollView(child: Column(
            children: [
              30.verticalSpace,
               AudioVideoSection(controller: controller),
             10.verticalSpace,
               ConnectionHealthSection(controller: controller),
              10.verticalSpace,
               DevicePermissionsSection(controller: controller),
              10.verticalSpace,
               OtherStepsSection(),
              50.verticalSpace,
              Align(alignment:Alignment.centerLeft,child: Text("Last tested: 2 Minutes ago")),
              20.verticalSpace,
              CustomButton(borderRadius: 15, text: "Save Settings", onTap: (){}),
              10.verticalSpace,
              CustomButton(borderRadius: 15, text: "Restore Defaults", onTap: (){
              },bgColor: AppColors.inACtiveButtonColor,fontColor: Colors.black,),
              40.verticalSpace,
            ],
          ),))
            ],
          ),
        ),
      ),
    );
  }
}
