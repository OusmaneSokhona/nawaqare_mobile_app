import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/sign_in_controller.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/custom_text_field.dart';

import '../../widgets/validation_check_list.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});
  SignInController signInController = Get.put(SignInController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: 1.sh,
          width: 1.sw,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/sign_in_bg.png")),
            gradient: LinearGradient(colors:[
              AppColors.onboardingBackground,
              Colors.white,
            ],begin: Alignment.topCenter,end: Alignment.bottomCenter),
          ),
          child: Form(
            key: signInController.formKey,
            child: SingleChildScrollView(
              child: Column(children: [
                80.verticalSpace,
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 20.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Sign In",style: TextStyle(
                      color: Colors.black,
                      fontSize: 32.sp,fontFamily: AppFonts.jakartaBold,
                      fontWeight: FontWeight.w700,
                    ),),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text("Access Your Secure Medical Account",style: TextStyle(
                      color: AppColors.darkGrey,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),),
                  ),
                ),
                40.verticalSpace,
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal:20.w),
                  child: CustomTextField(
                    labelText: "Email",
                    controller: signInController.emailController,
                    hintText: 'Saira@gmail.com',
                    prefixIcon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                    validator: signInController.emailValidator,
                  ),
                ),
                20.verticalSpace,
                Obx(
                      () => Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 20.w),
                    child: CustomTextField(
                      labelText: 'Password',
                      hintText: '********',
                      controller: signInController.passwordController,
                      prefixIcon: Icons.lock,
                      isPasswordField: true,
                      isEnabled: !signInController.passwordVisibility.value,
                      onChanged: (value) {
                        signInController.currentPassword.value = value;
                      },
                      onTapEye: signInController.toggleVisibility,
                      onFocusChange: signInController.setPasswordActive,
                      validator: signInController.validatePassword,
                      validationView: signInController.isPasswordActive.value
                          ? Obx(
                            () => ValidationChecklist(
                          rules: signInController.getValidationRules(),
                        ),
                      )
                          : null,
                    ),
                  ),
                ),
                10.verticalSpace,
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 20.w),
                  child: Align(alignment: Alignment.centerRight,child: InkWell(
                    onTap: (){
                      signInController.goToForgotPasswordScreen();
                    },
                    child: Text("Forget Password",
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primaryColor,
                        fontFamily: AppFonts.jakartaMedium,),
                    ),
                  ),),
                ),
                40.verticalSpace,

                CustomButton(borderRadius: 15, text: "Sign In", onTap: (){
                  if (signInController.formKey.currentState!.validate()) {
                    if (signInController.isPasswordValid()) {
                      print("Validation passed!");
                    } else {
                      signInController.markPasswordInteracted();
                      FocusScope.of(context).unfocus();
                      print("Password validation failed.");
                    }
                  } else {
                    signInController.markPasswordInteracted();
                    print("Form validation failed.");
                  }
                },fontSize: 18),
                20.verticalSpace,
                Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                  Text("Don't have an account?",style: TextStyle(
                    color: AppColors.darkGrey,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),),
                  5.horizontalSpace,
                  InkWell(
                    onTap: (){
                      signInController.goToSignUpScreen();
                    },
                    child: Text("Sign Up",style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primaryColor,
                      fontFamily: AppFonts.jakartaMedium,
                    ),),
                  ),
                ],),
              ],),
            ),
          ),

        )
    );
  }
}