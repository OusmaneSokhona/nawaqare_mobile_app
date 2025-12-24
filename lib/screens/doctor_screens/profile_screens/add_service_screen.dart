import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_profile_controller.dart';
import 'package:patient_app/utils/app_strings.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/patient_widgets/video_call_widgets/setting widgets.dart';

class AddServiceScreen extends StatelessWidget {
  final DoctorProfileController controller = Get.find<DoctorProfileController>();

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
                  AppStrings.addServices.tr,
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
                    Text(
                      AppStrings.addServicesSubtitle.tr,
                      style: TextStyle(
                        color: AppColors.lightGrey,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppFonts.jakartaRegular,
                      ),
                    ),
                    20.verticalSpace,
                    CustomTextField(
                      labelText: AppStrings.serviceName.tr,
                      hintText: "General Consultation",
                    ),
                    10.verticalSpace,
                    CustomTextField(
                      labelText: AppStrings.defaultDuration.tr,
                      hintText: "15 min",
                    ),
                    10.verticalSpace,
                    CustomTextField(
                      labelText: AppStrings.fee.tr,
                      hintText: "\$50",
                    ),
                    10.verticalSpace,
                    Obx(() => CustomDropdown(
                      label: AppStrings.mode.tr,
                      options: controller.mode,
                      currentValue: controller.selectedMode.value,
                      onChanged: (val) {
                        if (val != null) controller.selectedMode.value = val;
                      },
                    )),
                    10.verticalSpace,
                    Obx(() => CustomDropdown(
                      label: AppStrings.status.tr,
                      options: controller.serviceTypeList,
                      currentValue: controller.selectedServiceType.value,
                      onChanged: (val) {
                        if (val != null) controller.selectedServiceType.value = val;
                      },
                    )),
                    30.verticalSpace,
                    CustomButton(
                      text: AppStrings.addAndSave.tr,
                      onTap: () {
                        Get.back();
                      },
                      borderRadius: 15,
                    ),
                    10.verticalSpace,
                    CustomButton(
                      text: AppStrings.pdfExportService.tr,
                      onTap: () {},
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