import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/auth_controllers/sign_up_controller.dart';
import 'package:patient_app/widgets/custom_button.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../../widgets/custom_text_field.dart';

class EditMedicalVitals extends GetView<SignUpController> {
  EditMedicalVitals({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.onboardingBackground,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    AppStrings.medicalVitals.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              20.verticalSpace,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      15.verticalSpace,
                     CustomTextField(
                        labelText: AppStrings.height.tr,
                        hintText: "165cm",
                        controller: controller.heightController,
                        onChanged: (value) {
                          controller.calculateAndUpdateBMI(
                            value,
                            controller.weightController.text,
                          );
                        },
                      ),
                      10.verticalSpace,
                       CustomTextField(
                        labelText: AppStrings.weight.tr,
                        hintText: "60kg",
                        controller: controller.weightController,
                        onChanged: (value) {
                          controller.calculateAndUpdateBMI(
                            controller.heightController.text,
                            value,
                          );
                        },
                      ),
                      10.verticalSpace,
                      Obx(() {
                        RxString bmiCategory = controller.getBMICategory().obs;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              labelText: AppStrings.bmi.tr,
                              hintText: "22.0",
                              controller: controller.bmiController,
                              isEnabled: false,
                            ),
                            if (bmiCategory.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(top: 4.h, left: 12.w),
                                child: Text(
                                  bmiCategory.value,
                                  style: TextStyle(
                                    color: _getBMICategoryColor(bmiCategory.value),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        );
                      }),
                      10.verticalSpace,
                      CustomTextField(
                        labelText: AppStrings.bloodPressure.tr,
                        hintText: "120/80 mmHg",
                        controller: controller.bloodPressureController,
                      ),
                      10.verticalSpace,
                      CustomTextField(
                        labelText: AppStrings.heartRate.tr,
                        hintText: "72bpm",
                        controller: controller.heartRateController,
                      ),
                      30.verticalSpace,
                      Obx(() => controller.isLoading.value?CircularProgressIndicator(color: AppColors.primaryColor,):CustomButton(
                        borderRadius: 15,
                        text: AppStrings.submit.tr,
                        onTap: () {
                          controller.editMedicalVitals();
                        },
                      )),
                      10.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.cancel.tr,
                        onTap: () {
                          Get.back();
                        },
                        bgColor: AppColors.inACtiveButtonColor,
                        fontColor: Colors.black,
                      ),
                      40.verticalSpace,
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

  Color _getBMICategoryColor(String category) {
    switch (category) {
      case 'Underweight':
        return Colors.orange;
      case 'Normal':
        return Colors.green;
      case 'Overweight':
        return Colors.orange.shade700;
      case 'Obese':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}