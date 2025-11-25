import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/auth_screens/documents_reports.dart';
import '../../controllers/patient_controllers/auth_controllers/sign_up_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
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
                      "Medical Vitals",
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
                      CustomTextField(labelText: "Height", hintText: "165cm"),
                      10.verticalSpace,
                      CustomTextField(labelText: "Weight", hintText: "60kg"),
                      10.verticalSpace,
                      CustomTextField(labelText: "BMI", hintText: "22.0"),
                      10.verticalSpace,
                      CustomTextField(
                        labelText: "Blood Pressure",
                        hintText: "120/80 mmHg",
                      ),
                      10.verticalSpace,
                      CustomTextField(
                        labelText: "Heart Rate",
                        hintText: "72bpm",
                      ),
                    ],
                  ),
                ),
              ),

              20.verticalSpace,
              CustomButton(borderRadius: 15, text: "Continue", onTap: () {
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
