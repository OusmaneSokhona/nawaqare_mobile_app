import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/auth_controllers/sign_up_controller.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import '../../widgets/validation_check_list.dart';

class WebSignUpScreen extends StatelessWidget {
  WebSignUpScreen({super.key});

  final SignUpController signInController = Get.put(SignUpController());

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
                  image: AssetImage("assets/images/web_sign_in_image.png"),
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
                      Image.asset(
                        "assets/images/app_icon.png",
                        height: 110.h,
                        width: 45.w,
                        fit: BoxFit.fill,
                      ),
                      20.verticalSpace,
                      Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 7.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      5.verticalSpace,
                      Text(
                        "Create your profile to start manage the system.",
                        style: TextStyle(
                          fontSize: 5.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      10.verticalSpace,
                      CustomTextField(
                        prefixImageIcon: "assets/images/profile_icon.png",
                        height: 50.h,
                        prefixIconColor: AppColors.primaryColor,
                        labelText: "Full Name",
                        hintText: "Enter Name",
                      ),
                      10.verticalSpace,
                      CustomTextField(
                        prefixImageIcon: "assets/images/mail_icon.png",
                        height: 50.h,
                        prefixIconColor: AppColors.primaryColor,
                        labelText: "Email",
                        hintText: "mail@gmail.com",
                      ),
                      10.verticalSpace,
                      Obx(
                            () => CustomTextField(
                          prefixIcon: Icons.lock,
                          height: 50.h,
                          prefixIconColor: AppColors.primaryColor,
                          labelText: "Password",
                          hintText: "Enter Password",
                          isPasswordField: true,
                          isEnabled: !signInController.passwordVisibility.value,
                          onChanged: (value) {
                            signInController.currentPassword.value = value;
                          },
                          onTapEye: signInController.toggleVisibility,
                          onFocusChange: signInController.setPasswordActive,
                          validator: signInController.validatePassword,
                          validationView:
                          signInController.isPasswordActive.value
                              ? Obx(
                                () => ValidationChecklist(
                              rules:
                              signInController.getValidationRules(),
                            ),
                          )
                              : null,
                        ),
                      ),
                      20.verticalSpace,
                      CustomButton(borderRadius: 15,fontSize:6, text: AppStrings.signUp.tr, onTap: (){}),
                    ],
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
