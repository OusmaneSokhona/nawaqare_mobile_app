import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_profile_controller.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/patient_widgets/video_call_widgets/setting widgets.dart';

class AddServiceScreen extends StatelessWidget {
  DoctorProfileController controller=Get.find();
   AddServiceScreen({super.key});

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
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(children: [
            70.verticalSpace,
            Row(
              children: [
                InkWell(
                  onTap: (){
                    Get.back();
                  },
                  child: Image.asset(
                    AppImages.backIcon,
                    height: 33.h,
                    fit: BoxFit.fill,
                  ),
                ),
                10.horizontalSpace,
                Text(
                  "Add Services",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 23.sp,
                    fontWeight: FontWeight.w800,
                    fontFamily: AppFonts.jakartaBold,
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.verticalSpace,
                    Text("Create a new service to offer to your patients",style: TextStyle(
                      color: AppColors.lightGrey,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppFonts.jakartaRegular,
                    ),),
                    10.verticalSpace,
                    CustomTextField(labelText: "Service Name",hintText: "MA-PK-457621",),
                    10.verticalSpace,
                    CustomTextField(labelText: "Default Duration",hintText: "15 mint",),
                    10.verticalSpace,
                    CustomTextField(labelText: "Fee",hintText: "\$590",),
                    10.verticalSpace,
                    CustomDropdown(label: "Mode", options: controller.mode, currentValue: controller.selectedMode.value, onChanged: (_){}),
                    10.verticalSpace,
                    CustomDropdown(label: "Status", options: controller.serviceTypeList, currentValue: controller.selectedServiceType.value, onChanged: (_){}),
                    20.verticalSpace,
                    CustomButton(
                      text: "Add & Save",
                      onTap: (){
                        Get.back();
                      },
                      borderRadius: 15,
                    ),
                    10.verticalSpace,
                    CustomButton(
                      text: "PDF Export Service",
                      onTap: (){
                      },
                      borderRadius: 15,
                      bgColor: AppColors.inACtiveButtonColor,
                      fontColor: Colors.black,
                    ),
                    30.verticalSpace,
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
