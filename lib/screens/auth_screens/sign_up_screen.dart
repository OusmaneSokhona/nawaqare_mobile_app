import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/auth_controllers/sign_up_controller.dart';
import 'package:patient_app/screens/auth_screens/two_factor_authentication.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/custom_radio_tile.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import 'package:patient_app/widgets/progress_stepper.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../widgets/validation_check_list.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  SignUpController signUpController = Get.put(SignUpController());

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
                      "Sign Up",
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
                  child: Form(
                    key: signUpController.formKey,
                    child: Column(
                      children: [
                        5.verticalSpace,
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Create your secure medical account",
                            style: TextStyle(
                              color: AppColors.darkGrey,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        5.verticalSpace,

                        Obx(
                          () => CustomRadioTile(
                            text: "You are a doctor",
                            isSelected: signUpController.isDoctor.value,
                            onTap: () {
                              signUpController.isDoctor.value =
                                  !signUpController.isDoctor.value;
                            },
                          ),
                        ),
                        5.verticalSpace,
                        Obx(
                          () => CustomRadioTile(
                            text: "You are a patient",
                            isSelected: !signUpController.isDoctor.value,
                            onTap: () {
                              signUpController.isDoctor.value =
                                  !signUpController.isDoctor.value;
                            },
                          ),
                        ),
                        15.verticalSpace,
                        ProgressStepper(currentStep: 1, totalSteps: 4),
                        15.verticalSpace,
                        CustomTextField(
                          labelText: "Full Name",
                          prefixIcon: Icons.person_outline_outlined,
                          hintText: "Saira Tahir",
                          controller: signUpController.nameController,
                          validator: signUpController.signInController.nameValidator,
                        ),
                        10.verticalSpace,
                        CustomTextField(
                          labelText: "Email",
                          controller: signUpController.emailController,
                          hintText: 'Saira@gmail.com',
                          prefixIcon: Icons.mail_outline,
                          keyboardType: TextInputType.emailAddress,
                          validator: signUpController.signInController.emailValidator,
                        ),
                        10.verticalSpace,
                        CustomTextField(
                          labelText: "Phone Number",
                          hintText: "+33 3 6 12 34 56 78",
                          prefixIcon: Icons.phone,
                          controller: signUpController.phoneNumberController,
                          validator:
                              signUpController.signInController.phoneNumberValidator,
                        ),
                        10.verticalSpace,
                        Obx(
                          () => CustomTextField(
                            labelText: 'Password',
                            hintText: '********',
                            controller: signUpController.passwordController,
                            prefixIcon: Icons.lock,
                            isPasswordField: true,
                            isEnabled: !signUpController.passwordVisibility.value,
                            onChanged: (value) {
                              signUpController.currentPassword.value = value;
                            },
                            onTapEye: signUpController.toggleVisibility,
                            onFocusChange: signUpController.setPasswordActive,
                            validator: signUpController.validatePassword,
                            validationView:
                                signUpController.isPasswordActive.value
                                    ? Obx(
                                      () => ValidationChecklist(
                                        rules: signUpController.getValidationRules(),
                                      ),
                                    )
                                    : null,
                          ),
                        ),
                        40.verticalSpace,
                        CustomButton(
                          borderRadius: 15,
                          text: "Continue",
                          onTap: () {
                            if (signUpController.formKey.currentState!.validate()) {
                              if (signUpController.isPasswordValid()) {
                                Get.to(TwoFactorAuthentication());
                                print("Validation passed!");
                              } else {
                                signUpController.markPasswordInteracted();
                                FocusScope.of(context).unfocus();
                                print("Password validation failed.");
                              }
                            } else {
                              signUpController.markPasswordInteracted();
                              print("Form validation failed.");
                            }
                          },
                        ),
                        20.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: TextStyle(
                                color: AppColors.darkGrey,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            5.horizontalSpace,
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Text(
                                "Sign in",
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.primaryColor,
                                  fontFamily: AppFonts.jakartaMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                        40.verticalSpace,
                      ],
                    ),
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
