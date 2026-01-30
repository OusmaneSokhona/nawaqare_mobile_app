import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_images.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/verification_code_widget.dart';
import '../../controllers/auth_controllers/sign_up_controller.dart';
import '../../utils/app_colors.dart';

class VerificationDialog extends StatelessWidget {
  final String title;
  final String subTitle;
  final SignUpController authController;
  final bool isEmail;

  const VerificationDialog({
    super.key,
    required this.title,
    required this.subTitle,
    required this.authController,
    this.isEmail = true,
  });



  void _clearAllFields() {
    authController.clearAllFields();
  }

  void _confirmAction() {
    final isCodeComplete = authController.isCodeComplete?.value ?? false;

    if (isCodeComplete) {
      if(isEmail){
        authController.verifyEmailOtp();
        authController.timer?.cancel();
        _clearAllFields();
        Get.back();
      }else{
        authController.verifyPhoneOtp();
        authController.timer?.cancel();
        _clearAllFields();
        Get.back();
      }
    } else {
      Get.snackbar(
        AppStrings.incompleteCode.tr,
        AppStrings.incompleteCodeMsg.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: LinearGradient(
            colors: [AppColors.onboardingBackground, AppColors.lightWhite],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      _clearAllFields();
                      authController.timer?.cancel();
                      Get.back();
                    },
                    child: Image.asset(AppImages.backIcon, height: 24.h, width: 24.w),
                  ),
                  10.horizontalSpace,
                  Text(
                    AppStrings.verification.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: AppFonts.jakartaBold,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              15.verticalSpace,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: TextStyle(color: AppColors.darkGrey, fontSize: 14.sp),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  subTitle,
                  style: TextStyle(color: Colors.black, fontSize: 15.sp, fontWeight: FontWeight.bold),
                ),
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
                  fontSize: authController.isTimerActive.value ? 20.sp : 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              )),
              Obx(() => authController.isTimerActive.value
                  ? Text(AppStrings.codeExpiresSoon.tr, style: TextStyle(color: AppColors.red, fontSize: 12.sp))
                  : const SizedBox.shrink()),
              30.verticalSpace,
              Obx(
                ()=>authController.isLoading.value?CircularProgressIndicator(color: AppColors.primaryColor,): CustomButton(
                  borderRadius: 15,
                  text: AppStrings.confirm.tr,
                  onTap: _confirmAction,
                ),
              ),
              15.verticalSpace,
              Obx(
                  ()=>authController.isTimerActive.value?SizedBox(): InkWell(
                  onTap: (){
                    if(isEmail){
                      authController.sendEmailOtp();
                      authController.startTimer();
                    }else{
                      authController.sendPhoneOtp();
                      authController.startTimer();
                    }
                   },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(isEmail?AppImages.mailIcon:AppImages.whatsAppGreenIcon, height: 20.sp),
                      5.horizontalSpace,
                      Text(
                        isEmail?AppStrings.resendToEmail.tr:AppStrings.resendToWhatsapp.tr,
                        style: TextStyle(
                          color: AppColors.darkGrey,
                          fontSize: 14.sp,
                          decoration: TextDecoration.underline,
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