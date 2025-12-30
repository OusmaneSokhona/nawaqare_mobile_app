import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/auth_screens/basic_info_screen.dart';
import 'package:patient_app/screens/auth_screens/demographic_info.dart';
import 'package:patient_app/screens/auth_screens/two_factor_authentication.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/custom_radio_tile.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import 'package:patient_app/widgets/progress_stepper.dart';
import '../../controllers/auth_controllers/sign_up_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_strings.dart';
import '../../widgets/validation_check_list.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final SignUpController signUpController = Get.put(SignUpController());

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
                      AppStrings.signUp.tr,
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
                            AppStrings.createAccountSub.tr,
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
                            text: AppStrings.iAmDoctor.tr,
                            isSelected: signUpController.type.value == "doctor",
                            onTap: () {
                              signUpController.type.value = "doctor";
                            },
                          ),
                        ),
                        5.verticalSpace,
                        Obx(
                          () => CustomRadioTile(
                            text: AppStrings.iAmPatient.tr,
                            isSelected:
                                signUpController.type.value == "patient",
                            onTap: () {
                              signUpController.type.value = "patient";
                            },
                          ),
                        ),
                        5.verticalSpace,
                        Obx(
                          () => CustomRadioTile(
                            text: AppStrings.iAmPharmacist.tr,
                            isSelected:
                                signUpController.type.value == "pharmacist",
                            onTap: () {
                              signUpController.type.value = "pharmacist";
                            },
                          ),
                        ),
                        15.verticalSpace,
                        Obx(
                          () => ProgressStepper(
                            currentStep: 1,
                            totalSteps:
                                signUpController.type.value == "patient"
                                    ? 4
                                    : 5,
                          ),
                        ),
                        15.verticalSpace,
                        CustomTextField(
                          labelText: AppStrings.fullName.tr,
                          prefixIcon: Icons.person_outline_outlined,
                          hintText: "Saira Tahir",
                          controller: signUpController.nameController,
                          validator:
                              signUpController.signInController.nameValidator,
                        ),
                        10.verticalSpace,
                        CustomTextField(
                          labelText: AppStrings.email.tr,
                          controller: signUpController.emailController,
                          hintText: 'Saira@gmail.com',
                          prefixIcon: Icons.mail_outline,
                          keyboardType: TextInputType.emailAddress,
                          validator:
                              signUpController.signInController.emailValidator,
                        ),
                        10.verticalSpace,
                        CustomTextField(
                          labelText: AppStrings.phoneNumber.tr,
                          hintText: "+33 3 6 12 34 56 78",
                          prefixIcon: Icons.phone,
                          controller: signUpController.phoneNumberController,
                          validator:
                              signUpController
                                  .signInController
                                  .phoneNumberValidator,
                        ),
                        10.verticalSpace,
                        Obx(
                          () => CustomTextField(
                            labelText: AppStrings.password.tr,
                            hintText: '********',
                            controller: signUpController.passwordController,
                            prefixIcon: Icons.lock,
                            isPasswordField: true,
                            isEnabled:
                                !signUpController.passwordVisibility.value,
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
                                        rules:
                                            signUpController
                                                .getValidationRules(),
                                      ),
                                    )
                                    : null,
                          ),
                        ),
                        20.verticalSpace,
                        Obx(
                            ()=>signUpController.type.value=="doctor"?InkWell(
                            onTap: (){
                              signUpController.isRegisteredProfessional.value=!signUpController.isRegisteredProfessional.value;
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  signUpController.isRegisteredProfessional.value? Icons.check_box : Icons.check_box_outline_blank,
                                  color: signUpController.isRegisteredProfessional.value ? AppColors.primaryColor: Colors.grey.shade400,
                                  size: 20.sp,
                                ),
                                2.horizontalSpace,
                                Expanded(
                                  child: Text(
                                    "I am a registered medical professional",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontFamily: AppFonts.jakartaRegular,
                                      color:  Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ):SizedBox(),
                        ),
                        20.verticalSpace,
                        CustomButton(
                          borderRadius: 15,
                          text: AppStrings.continueText.tr,
                          onTap: () {
                            if (signUpController.formKey.currentState!
                                .validate()) {
                              if (signUpController.isPasswordValid()) {
                                if (signUpController.type.value == "doctor") {
                                  Get.to(DemographicInfo());
                                } else if (signUpController.type.value ==
                                    "pharmacist") {
                                  Get.to(BasicInfoScreen());
                                } else {
                                  Get.to(TwoFactorAuthentication());
                                }
                              } else {
                                signUpController.markPasswordInteracted();
                                FocusScope.of(context).unfocus();
                              }
                            } else {
                              signUpController.markPasswordInteracted();
                            }
                          },
                        ),
                        20.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.alreadyHaveAccount.tr,
                              style: TextStyle(
                                color: AppColors.darkGrey,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppFonts.jakartaMedium,
                              ),
                            ),
                            5.horizontalSpace,
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Text(
                                AppStrings.signIn.tr,
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
