import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/auth_controllers/forget_password_contorller.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import '../../widgets/validation_check_list.dart';

class WebResetPasswordScreen extends StatelessWidget {
  WebResetPasswordScreen({super.key});

  final ForgetPasswordController resetController = Get.put(ForgetPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/reset_password_image.png"),
                ),
              ),
              height: 1.sh,
              width: 0.45.sw,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 75.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to Nawacare",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    10.verticalSpace,
                    Text(
                      "Your central workspace to oversee\nusers, operations, and platform activity.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 6.sp, color: Colors.white),
                    ),
                    Spacer(),
                    Text(
                      "Smart Platform Management",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    10.verticalSpace,
                    Text(
                      "Monitor consultations, payments, and\nperformance in one place.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 6.sp, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 1.sh,
              width: 0.45.sw,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 85.h),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      90.verticalSpace,
                      Text(
                        AppStrings.resetPassword.tr,
                        style: TextStyle(
                          fontSize: 7.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      5.verticalSpace,
                      Text(
                        "Set a new password to secure your account",
                        style: TextStyle(
                          fontSize: 5.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      10.verticalSpace,
                      Obx(
                            () => CustomTextField(
                          prefixIcon: Icons.lock,
                          height: 50.h,
                              hintText: AppStrings.enterPasswordHint.tr,
                          prefixIconColor: AppColors.primaryColor,
                              isPasswordField: true,
                              controller: resetController.newPassword,
                              isEnabled: resetController.newPasswordVisibility.value,
                              onFocusChange: resetController.setPasswordActive,
                              validator: resetController.validatePassword,
                              onChanged: (value) => resetController.currentPassword.value = value,
                              validationView: resetController.isPasswordActive.value
                                  ? Obx(
                                    () => ValidationChecklist(
                                  rules: resetController.getValidationRules(),
                                ),
                              )
                                  : null,
                              onTapEye: (){
                                resetController.newPasswordVisibility.value = !resetController.newPasswordVisibility.value;
                              },
                        ),
                      ),
                      10.verticalSpace,
                      Obx(
                            () => CustomTextField(
                          prefixIcon: Icons.lock,
                          height: 50.h,
                          prefixIconColor: AppColors.primaryColor,
                              labelText: AppStrings.confirmPassword.tr,
                              hintText: AppStrings.enterPasswordHint.tr,
                              isPasswordField: true,
                              controller: resetController.confrimNewPassword,
                              isEnabled: resetController.confirmNewPasswordVisibility.value,
                              validator: resetController.validateConfirmPassword,
                              onTapEye: (){
                                resetController.confirmNewPasswordVisibility.value = !resetController.confirmNewPasswordVisibility.value;
                              },
                        ),
                      ),
                      60.verticalSpace,
                      CustomButton(borderRadius: 15,fontSize:6, text: AppStrings.resetPassword.tr, onTap: (){}),
                      20.verticalSpace,],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
