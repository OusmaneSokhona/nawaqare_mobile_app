import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_profile_controller.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import 'package:patient_app/widgets/patient_widgets/video_call_widgets/setting%20widgets.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_button.dart';

class EditExistingService extends StatelessWidget {
  final DoctorProfileController controller = Get.find();
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
                    AppStrings.editExistingService.tr,
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
                      CustomTextField(
                        labelText: AppStrings.serviceName.tr,
                        hintText: "MA-PK-457621",
                      ),
                      10.verticalSpace,
                      CustomTextField(
                        labelText: AppStrings.defaultDuration.tr,
                        hintText: "15 min",
                      ),
                      10.verticalSpace,
                      CustomTextField(
                        labelText: AppStrings.fee.tr,
                        hintText: "\$590",
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
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.description.tr,
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
                          onTapOutside: (_) {
                            FocusManager.instance.primaryFocus!.unfocus();
                          },
                          decoration: InputDecoration(
                            hintText: AppStrings.aboutMeHint.tr,
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                          ),
                        ),
                      ),
                      20.verticalSpace,
                      CustomButton(
                        text: AppStrings.update.tr,
                        onTap: () {
                          Get.back();
                        },
                        borderRadius: 15,
                      ),
                      10.verticalSpace,
                      CustomButton(
                        text: AppStrings.cancel.tr,
                        onTap: () {
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