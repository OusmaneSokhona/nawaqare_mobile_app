import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_images.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/verification_dialog.dart';
import 'package:patient_app/widgets/verification_via_widget.dart';
import '../../controllers/auth_controllers/sign_up_controller.dart';

class TwoFactorDialog extends StatelessWidget {
  final bool onlyEmail;
  TwoFactorDialog({super.key, this.onlyEmail = true});

  final SignUpController signUpController = Get.find();

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppStrings.twoFactorAuth.tr,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: AppFonts.jakartaBold,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            10.verticalSpace,
            Text(
              AppStrings.twoFactorSub.tr,
              style: TextStyle(
                color: AppColors.darkGrey,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            20.verticalSpace,
            onlyEmail
                ? VerificationViaWidget(
              title: AppStrings.verifyViaEmail.tr,
              subtitle: AppStrings.verifyEmailSub.tr,
              iconPath: AppImages.mailIcon,
              onTap: () {
                Get.back();
                signUpController.sendEmailOtp();
                signUpController.startTimer();
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => VerificationDialog(
                    authController: signUpController,
                    title: AppStrings.emailCodeSent.tr,
                    subTitle: signUpController.emailController.text,
                  ),
                );
              },
              iconColor: AppColors.darkGrey,
            )
                : VerificationViaWidget(
              title: AppStrings.verifyViaWhatsapp.tr,
              subtitle: AppStrings.phoneNumber.tr,
              iconPath: AppImages.whatsAppIcon,
              onTap: () {
                Get.back();
                signUpController.sendPhoneOtp();
                signUpController.startTimer();
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => VerificationDialog(
                    authController: signUpController,
                    title: AppStrings.whatsappCodeSent.tr,
                    isEmail: false,
                    subTitle: signUpController.phoneNumberController.text,
                  ),
                );
              },
            ),
            25.verticalSpace,
            CustomButton(
              borderRadius: 15,
              text: AppStrings.back.tr,
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }
}