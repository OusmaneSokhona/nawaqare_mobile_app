import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/auth_screens/reset_password.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_images.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/verification_code_widget.dart';
import '../../controllers/auth_controllers/forget_password_contorller.dart';
import '../../utils/app_colors.dart';

class VerificationScreen extends StatelessWidget {
  final String title;
  final String subTitle;
  final bool isEmail;
  final ForgetPasswordController authController;

  const VerificationScreen({
    super.key,
    required this.title,
    required this.subTitle,
    this.isEmail=true,
    required this.authController,
  });

  void _confirmAction() async {
    if (authController.isCodeComplete.value) {
      bool isVerified = await authController.verifyResetOtp();
      if (isVerified) {
        authController.timer?.cancel();
        Get.off(() => ResetPassword());
      }
    } else {
      Get.snackbar(
        AppStrings.incompleteCode.tr,
        AppStrings.incompleteCodeMsg.tr,
        backgroundColor: Colors.red.shade100,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      authController.clearAllFields();
                      Get.back();
                    },
                    child: Image.asset(AppImages.backIcon, height: 32.h, width: 32.w),
                  ),
                  7.horizontalSpace,
                  Text(
                    AppStrings.verification.tr,
                    style: TextStyle(fontFamily: AppFonts.jakartaBold, fontSize: 32.sp, fontWeight: FontWeight.w700),
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
                        child: Text(title, style: TextStyle(color: AppColors.darkGrey, fontSize: 16.sp)),
                      ),
                      3.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(subTitle, style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w700)),
                      ),
                      20.verticalSpace,
                      VerificationCodeWidget(controller: authController),
                      20.verticalSpace,
                      Obx(() => Text(
                        authController.isTimerActive.value
                            ? authController.formatTime(authController.timerCount.value)
                            : AppStrings.requestNewCode.tr,
                        style: TextStyle(
                          color: authController.isTimerActive.value ? Colors.black : Colors.red,
                          fontSize: authController.isTimerActive.value?24.sp:17.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
                      60.verticalSpace,
                      Obx(() => authController.isLoading.value
                          ? const CircularProgressIndicator()
                          : CustomButton(
                        borderRadius: 15,
                        text: AppStrings.confirm.tr,
                        onTap: _confirmAction,
                      )),
                      20.verticalSpace,
                      Obx(
                          ()=> authController.isTimerActive.value?SizedBox():InkWell(
                          onTap: () async {
                            print("isEmail: $isEmail");
                            if (!authController.isTimerActive.value) {

                              isEmail?await authController.sendResetOtp():await authController.sendResetOtp(isEmail: false);
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(isEmail?AppImages.mailIcon:AppImages.whatsAppGreenIcon, height: 27.sp),
                              5.horizontalSpace,
                              Obx(() => Text(
                                isEmail?AppStrings.resendToEmail:AppStrings.resendToWhatsapp.tr,
                                style: TextStyle(
                                  color: authController.isTimerActive.value ? Colors.grey : AppColors.darkGrey,
                                  fontSize: 17.sp,
                                  decoration: TextDecoration.underline,
                                ),
                              )),
                            ],
                          ),
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