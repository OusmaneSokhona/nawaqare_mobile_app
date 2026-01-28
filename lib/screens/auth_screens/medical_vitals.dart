import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/auth_screens/documents_reports.dart';
import '../../controllers/auth_controllers/sign_up_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_strings.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/progress_stepper.dart';

class MedicalVitals extends StatelessWidget {
  MedicalVitals({super.key});

  SignUpController signUpController = Get.find();

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
              80.verticalSpace,
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Image.asset(
                      "assets/images/back_icon.png",
                      height: 32.h,
                      width: 32.w,
                    ),
                  ),
                  7.horizontalSpace,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppStrings.medicalVitals.tr,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: AppFonts.jakartaBold,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      20.verticalSpace,
                      ProgressStepper(currentStep: 3, totalSteps: 4),
                      15.verticalSpace,
                      CustomTextField(labelText: AppStrings.height.tr, hintText: "165cm",controller: signUpController.heightController,),
                      10.verticalSpace,
                      CustomTextField(labelText: AppStrings.weight.tr, hintText: "60kg",controller: signUpController.weightController,),
                      10.verticalSpace,
                      CustomTextField(labelText: AppStrings.bmi.tr, hintText: "22.0",controller: signUpController.bmiController,),
                      10.verticalSpace,
                      CustomTextField(
                        labelText: AppStrings.bloodPressure.tr,
                        hintText: "120/80 mmHg",
                        controller: signUpController.bloodPressureController,
                      ),
                      10.verticalSpace,
                      CustomTextField(
                        labelText: AppStrings.heartRate.tr,
                        hintText: "72bpm",
                        controller: signUpController.heartRateController,
                      ),
                    ],
                  ),
                ),
              ),

              20.verticalSpace,
              CustomButton(borderRadius: 15, text: AppStrings.continueText.tr, onTap: () {
                if(signUpController.heightController.text.isEmpty||
                    signUpController.weightController.text.isEmpty||
                    signUpController.bmiController.text.isEmpty||
                    signUpController.bloodPressureController.text.isEmpty||
                    signUpController.heartRateController.text.isEmpty){
                  Get.snackbar(AppStrings.warning.tr,AppStrings.pleaseFillAllFields.tr,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.red,
                      colorText: Colors.white);
                  return;
                }
                Get.to(DocumentsReports());
              }),
              50.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}