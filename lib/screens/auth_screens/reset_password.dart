import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controllers/forget_password_contorller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_strings.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/validation_check_list.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({super.key});
  final ForgetPasswordController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            AppColors.onboardingBackground,
            AppColors.lightWhite,
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Form(
          key: authController.formKeyForget,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SingleChildScrollView(
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
                          )),
                      7.horizontalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 0.7.sw,
                          child: Text(
                            AppStrings.resetPassword.tr,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: AppFonts.jakartaBold,
                              fontSize: 23.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppStrings.resetPasswordSub.tr,
                      style: TextStyle(
                        color: AppColors.darkGrey,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  20.verticalSpace,
                  Obx(
                        () => CustomTextField(
                      labelText: AppStrings.newPassword.tr,
                      hintText: AppStrings.enterPasswordHint.tr,
                      prefixIcon: Icons.lock_outline,
                      isPasswordField: true,
                      controller: authController.newPassword,
                      isEnabled: authController.newPasswordVisibility.value,
                      onFocusChange: authController.setPasswordActive,
                      validator: authController.validatePassword,
                      onChanged: (value) => authController.currentPassword.value = value,
                      validationView: authController.isPasswordActive.value
                          ? Obx(
                            () => ValidationChecklist(
                          rules: authController.getValidationRules(),
                        ),
                      )
                          : null,
                      onTapEye: () {
                        authController.newPasswordVisibility.value = !authController.newPasswordVisibility.value;
                      },
                    ),
                  ),
                  20.verticalSpace,
                  Obx(
                        () => CustomTextField(
                      labelText: AppStrings.confirmPassword.tr,
                      hintText: AppStrings.enterPasswordHint.tr,
                      prefixIcon: Icons.lock_outline,
                      isPasswordField: true,
                      controller: authController.confrimNewPassword,
                      isEnabled: authController.confirmNewPasswordVisibility.value,
                      validator: authController.validateConfirmPassword,
                      onTapEye: () {
                        authController.confirmNewPasswordVisibility.value = !authController.confirmNewPasswordVisibility.value;
                      },
                    ),
                  ),
                  10.verticalSpace,
                  40.verticalSpace,
                  Obx(() => authController.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : CustomButton(
                      borderRadius: 15,
                      text: AppStrings.resetPassword.tr,
                      onTap: () async {
                        if (authController.formKeyForget.currentState!.validate()) {
                          bool success = await authController.resetPassword();
                          if (success) {
                            authController.moveToSignInScreen();
                          }
                        }
                      },
                      fontSize: 18)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}