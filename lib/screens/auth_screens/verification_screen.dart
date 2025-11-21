import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/auth_controllers/sign_in_controller.dart';
import 'package:patient_app/controllers/auth_controllers/forget_password_contorller.dart';
import 'package:patient_app/screens/auth_screens/complete_profile.dart';
import 'package:patient_app/screens/auth_screens/reset_password.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_images.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/verification_code_widget.dart';

import '../../controllers/auth_controllers/sign_up_controller.dart';
import '../../utils/app_colors.dart';

class VerificationScreen extends StatelessWidget {
  final String title;
  final String subTitle;
  final GetxController authController;

  const VerificationScreen({
    super.key,
    required this.title,
    required this.subTitle,
    required this.authController,
  });

  void _startTimer() {
    if (authController is ForgetPasswordController) {
      (authController as ForgetPasswordController).startTimer();
    } else if (authController is SignUpController) {
      (authController as SignUpController).startTimer();
    }
  }

  void _clearAllFields() {
    if (authController is ForgetPasswordController) {
      (authController as ForgetPasswordController).clearAllFields();
    } else if (authController is SignUpController) {
      (authController as SignUpController).clearAllFields();
    }
  }

  void _confirmAction() {
    final dynamic verifiedController = authController;
    verifiedController.timer?.cancel();
    final isCodeComplete = verifiedController.isCodeComplete?.value ?? false;

    if (isCodeComplete) {

      if (verifiedController.timer != null) {
        verifiedController.timer?.cancel();
      }

      if (authController is ForgetPasswordController) {
        Get.off(() =>  ResetPassword());
      } else if (authController is SignUpController) {
       Get.to(CompleteProfile());
      }
    } else {
      Get.snackbar(
        "Incomplete Code",
        "Please enter the complete 6-digit verification code.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _startTimer();

    final dynamic verifiedController = authController;

    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.onboardingBackground, AppColors.lightWhite],
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
                      _clearAllFields();
                      Get.back();
                    },
                    child: Image.asset(
                      AppImages.backIcon, // Assuming AppImages.backIcon points to "assets/images/back_icon.png"
                      height: 32.h,
                      width: 32.w,
                    ),
                  ),
                  7.horizontalSpace,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Verification",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: AppFonts.jakartaBold,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          title,
                          style: TextStyle(
                            color: AppColors.darkGrey,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      3.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          subTitle,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      20.verticalSpace,
                      VerificationCodeWidget(controller: authController),
                      20.verticalSpace,
                      Obx(
                            () => Text(
                          verifiedController.isTimerActive.value
                              ? verifiedController.formatTime(
                            verifiedController.timerCount.value,
                          )
                              : 'You can request a new code now.',
                          style: TextStyle(
                            color:
                            verifiedController.isTimerActive.value
                                ? Colors.black
                                : Colors.red,
                            fontSize:
                            verifiedController.isTimerActive.value ? 24.sp : 15.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: AppFonts.jakartaBold,
                          ),
                        ),
                      ),
                      5.verticalSpace,
                      Obx(
                            () =>
                        !verifiedController.isTimerActive.value
                            ? const SizedBox.shrink()
                            : Text(
                          "Code expires soon.",
                          style: TextStyle(
                            color: AppColors.red,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      60.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: "Confirm",
                        onTap: _confirmAction,
                      ),
                      20.verticalSpace,
                      InkWell(
                        onTap:  _startTimer, // Disable resend if timer is active
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(AppImages.whatsAppGreenIcon, height: 27.sp),
                            Text(
                              "Re-send To Whatsapp",
                              style: TextStyle(
                                color: AppColors.darkGrey,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.darkGrey,
                                fontFamily: AppFonts.jakartaMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
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