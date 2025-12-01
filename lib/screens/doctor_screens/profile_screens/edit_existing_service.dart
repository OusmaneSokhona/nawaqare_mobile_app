import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_profile_controller.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import 'package:patient_app/widgets/patient_widgets/video_call_widgets/setting%20widgets.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_button.dart';

class EditExistingService extends StatelessWidget {
  DoctorProfileController   controller=Get.find();
   EditExistingService({super.key});

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
          child: Column(
            children: [
              70.verticalSpace,
              Row(
                children: [
                  InkWell(
                    onTap: () {
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
                    "Edit Existing Service",
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
                    children: [
                      20.verticalSpace,
                      CustomTextField(labelText: "Service Name",hintText: "MA-PK-457621",),
                      10.verticalSpace,
                      CustomTextField(labelText: "Default Duration",hintText: "15 mint",),
                      10.verticalSpace,
                      CustomTextField(labelText: "Fee",hintText: "\$590",),
                      10.verticalSpace,
                      CustomDropdown(label: "Mode", options: controller.mode, currentValue: controller.selectedMode.value, onChanged: (_){}),
                      10.verticalSpace,
                      CustomDropdown(label: "Status", options: controller.serviceTypeList, currentValue: controller.selectedServiceType.value, onChanged: (_){}),
                     10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ),
                      3.verticalSpace,
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300, width: 1),
                        ),
                        child: TextField(
                          maxLines: 3,
                          onTapOutside: (_){
                            FocusManager.instance.primaryFocus!.unfocus();
                          },
                          decoration: InputDecoration(
                            hintText: 'Write something about you',
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                            border: InputBorder.none,
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          ),
                        ),
                      ),
                      20.verticalSpace,
                      CustomButton(
                        text: "Update",
                        onTap: (){
                          Get.back();
                        },
                        borderRadius: 15,
                      ),
                      10.verticalSpace,
                      CustomButton(
                        text: "Cancel",
                        onTap: (){
                          Get.back();
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
            ],
          ),
        ),
      ),
    );
  }
}
