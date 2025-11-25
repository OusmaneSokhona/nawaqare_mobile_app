import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/widgets/success_dialog.dart';

import '../../controllers/patient_controllers/auth_controllers/sign_up_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/progress_stepper.dart';

class DocumentsReports extends StatelessWidget {
  DocumentsReports({super.key});

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
                      "Documents & Reports",
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

                  20.verticalSpace,
                  ProgressStepper(currentStep:4, totalSteps: 4),
                  15.verticalSpace,
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Upload Document/Test Report',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  3.verticalSpace,
                  InkWell(
                    onTap: signUpController.pickFile,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.05),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Obx(
                            () => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 40,
                              color: Colors.blue.shade700,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              signUpController.selectedFileName.value == 'No file selected' || signUpController.selectedFileName.value == 'File selection cancelled'
                                  ? 'Upload PDF/JPEG'
                                  : signUpController.selectedFileName.value!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue.shade700,
                              ),
                            ),
                            if (signUpController.selectedFileName.value != 'No file selected' && signUpController.selectedFileName.value != 'File selection cancelled')
                              const Text(
                                'Tap to select a new file',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              40.verticalSpace,
              CustomButton(borderRadius: 15, text: "Submit", onTap: () async {
                Get.dialog(SuccessDialog());
                await Future.delayed(Duration(seconds: 3),(){
                  signUpController.moveToSignInScreen();
                });
              }),
              20.verticalSpace,
              CustomButton(borderRadius: 15, text: "Skip", onTap: () {
                signUpController.moveToSignInScreen();
              },bgColor: AppColors.inACtiveButtonColor,fontColor: Colors.black,),
              50.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
