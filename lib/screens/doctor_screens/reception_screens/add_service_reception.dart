import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/service_and_pricing_controller.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/patient_widgets/video_call_widgets/setting%20widgets.dart';

class AddServiceReception extends StatelessWidget {
  AddServiceReception({super.key});
  final ServiceAndPricingController controller = Get.find();

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
                      "assets/images/back_icon.png",
                      height: 22.h,
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    AppStrings.addService.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              5.verticalSpace,
              CustomTextField(
                labelText: AppStrings.serviceNameLabel.tr,
                hintText: AppStrings.serviceNameHint.tr,
              ),
              10.verticalSpace,
              Obx(() => CustomDropdown(
                  label: AppStrings.days.tr,
                  options: controller.daysList,
                  currentValue: controller.selectedDay.value,
                  onChanged: (val) {
                    if (val != null) controller.selectedDay.value = val;
                  }
              )),
              10.verticalSpace,
              Obx(() => CustomDropdown(
                  label: AppStrings.mode.tr,
                  options: controller.modeList,
                  currentValue: controller.selectedMode.value,
                  onChanged: (val) {
                    if (val != null) controller.selectedMode.value = val;
                  }
              )),
              10.verticalSpace,
              CustomTextField(
                labelText: AppStrings.location.tr,
                hintText: AppStrings.locationHint.tr,
              ),
              30.verticalSpace,
              CustomButton(
                borderRadius: 15,
                text: AppStrings.addService.tr,
                onTap: () {},
              ),
              15.verticalSpace,
              CustomButton(
                borderRadius: 15,
                text: AppStrings.cancel.tr,
                onTap: () {
                  Get.back();
                },
                bgColor: AppColors.inACtiveButtonColor,
                fontColor: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}