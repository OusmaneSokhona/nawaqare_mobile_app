import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/auth_screens/verification_screen.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_images.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import 'package:patient_app/widgets/verification_via_widget.dart';
import '../../controllers/auth_controllers/forget_password_contorller.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});
  final ForgetPasswordController forgetPasswordController = Get.put(ForgetPasswordController());

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
                    onTap: () => Get.back(),
                    child: Image.asset("assets/images/back_icon.png", height: 32.h, width: 32.w),
                  ),
                  7.horizontalSpace,
                  Text(
                    AppStrings.forgotPassword.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: AppFonts.jakartaBold,
                      fontSize: 27.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      20.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.forgotPasswordSub.tr,
                          style: TextStyle(color: AppColors.darkGrey, fontSize: 16.sp),
                        ),
                      ),
                      20.verticalSpace,
                      VerificationViaWidget(
                        title: AppStrings.verifyEmail.tr,
                        subtitle: AppStrings.verifyEmailSub.tr,
                        iconPath: AppImages.mailIcon,
                        onTap: () => _showInputDialog(isEmail: true),
                        iconColor: AppColors.darkGrey,
                      ),
                      25.verticalSpace,
                      VerificationViaWidget(
                        title: AppStrings.verifyWhatsapp.tr,
                        subtitle: AppStrings.verifyWhatsappSub.tr,
                        iconPath: AppImages.whatsAppIcon,
                        onTap: () => _showInputDialog(isEmail: false),
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

  void _showInputDialog({required bool isEmail}) {
    Get.dialog(
      Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.r)),
            width: 0.9.sw,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    isEmail ? AppStrings.verifyEmail.tr : AppStrings.verifyWhatsapp.tr,
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                  ),
                ),
                15.verticalSpace,
                CustomTextField(
                  maxLength: 30,
                  controller: isEmail
                      ? forgetPasswordController.emailController
                      : forgetPasswordController.phoneController,
                  hintText: isEmail ? "asd@gmail.com" : "+123456789",
                  keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.phone,
                ),
                20.verticalSpace,
                Obx(() => forgetPasswordController.isLoading.value
                    ? const CircularProgressIndicator()
                    : CustomButton(
                  onTap: () async {
                    String identifier = isEmail
                        ? forgetPasswordController.emailController.text
                        : forgetPasswordController.phoneController.text;

                    bool success = await forgetPasswordController.sendResetOtp(isEmail: isEmail);

                    if (success) {
                      forgetPasswordController.clearAllFields();
                      Get.to(() => VerificationScreen(
                        authController: forgetPasswordController,
                        title: isEmail ? AppStrings.verifyEmail.tr : AppStrings.verifyWhatsapp.tr,
                        isEmail: isEmail,
                        subTitle: identifier,
                      ));
                    }
                  },
                  text: "Send OTP",
                  borderRadius: 15,
                )),
                10.verticalSpace,
                CustomButton(
                  borderRadius: 15,
                  text: "Cancel",
                  onTap: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}