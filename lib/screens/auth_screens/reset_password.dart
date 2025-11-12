import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/forget_password_contorller.dart';
import 'package:patient_app/screens/auth_screens/sign_in_screen.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/validation_check_list.dart';

class ResetPassword extends StatelessWidget {
   ResetPassword({super.key});
  ForgetPasswordController authController=Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors:[
            AppColors.onboardingBackground,
            AppColors.lightWhite,
          ],begin: Alignment.topCenter,end: Alignment.bottomCenter),
        ),
        child: Form(
          key: authController.formKeyForget,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(children: [
              80.verticalSpace,
              Row(
                children: [
                  InkWell(
                      onTap: (){
                        Get.back();
                      },
                      child: Image.asset("assets/images/back_icon.png",height: 32.h,width: 32.w,)),
                  7.horizontalSpace,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Reset Password",style: TextStyle(
                      color: Colors.black,
                      fontFamily: AppFonts.jakartaBold,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w700,
                    ),),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Access Your Secure Medical Account",style: TextStyle(
                  color: AppColors.darkGrey,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),),
              ),
              20.verticalSpace,
              Obx(
                    ()=> CustomTextField(
                  labelText: 'New Password',
                  hintText: 'Enter your password',
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
                  onTapEye: (){
                    authController.newPasswordVisibility.value = !authController.newPasswordVisibility.value;
                  },
                ),
              ),
              20.verticalSpace,
              Obx(
                    ()=> CustomTextField(
                  labelText: 'Confirm Password',
                  hintText: 'Enter your password',
                  prefixIcon: Icons.lock_outline,
                  isPasswordField: true,
                  controller: authController.confrimNewPassword,
                  isEnabled: authController.confirmNewPasswordVisibility.value,
                  validator: authController.validateConfirmPassword, // Use the new method
                  onTapEye: (){
                    authController.confirmNewPasswordVisibility.value = !authController.confirmNewPasswordVisibility.value;
                  },
                ),
              ),
              10.verticalSpace,
              40.verticalSpace,
              CustomButton(borderRadius: 15, text: "Reset Password", onTap: (){
                if (authController.formKeyForget.currentState!.validate()) {
                  Get.offAll(SignInScreen());
                  print("Validation passed!");
                } else {
                  print("Validation failed.");
                }
              },fontSize: 18),
            ],),
          ),
        ),

      ),
    );
  }
}
