import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import 'package:patient_app/widgets/web_forget_password_dialog.dart';
import '../../controllers/auth_controllers/sign_in_controller.dart';
import '../../utils/app_fonts.dart';
import '../../widgets/validation_check_list.dart';

class WebSignInScreen extends StatelessWidget {
  WebSignInScreen({super.key});

  final SignInController signInController = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: AppColors.webBgColor,
      body: Center(
        child: Container(
          margin: isDesktop ? EdgeInsets.all(20.r) : EdgeInsets.zero,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            children: [
              if (isDesktop)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      bottomLeft: Radius.circular(20.r),
                    ),
                    image: const DecorationImage(
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
                        const Spacer(),
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
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 40.w : 20.w,
                    vertical: 35.h,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: isDesktop ? 0.4.sw : 1.sw),
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                        child: Form(
                          key: signInController.formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: isDesktop ? Alignment.centerLeft : Alignment.center,
                                  child: Image.asset(
                                    "assets/images/app_icon.png",
                                    height: 80.h,
                                    width: isDesktop ? 40.w : 100.w,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                20.verticalSpace,
                                Text(
                                  "Sign In",
                                  style: TextStyle(
                                    fontSize: 8.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                5.verticalSpace,
                                Text(
                                  "Access Your Secure Account.",
                                  style: TextStyle(
                                    fontSize: 5.sp,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                25.verticalSpace,
                                CustomTextField(
                                  maxLength: 30,
                                  prefixImageIcon: "assets/images/mail_icon.png",
                                  height: 50.h,
                                  prefixIconColor: AppColors.primaryColor,
                                  labelText: "Email",
                                  hintText: "mail@gmail.com",
                                  controller: signInController.emailController,

                                  validator: signInController.emailValidator,
                                ),
                                15.verticalSpace,
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
                                    validationView: signInController.isPasswordActive.value
                                        ? Obx(
                                          () => ValidationChecklist(
                                        rules: signInController.getValidationRules(),
                                      ),
                                    )
                                        : null,
                                  ),
                                ),
                                5.verticalSpace,
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    onTap: () {
                                      Get.dialog(WebForgotPasswordDialog(),barrierDismissible: false);
                                    },
                                    child: Text(
                                      "Forget Password",
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 5.sp,
                                        decoration: TextDecoration.underline,
                                        decorationColor: AppColors.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                                40.verticalSpace,
                                Center(
                                  child: CustomButton(
                                    borderRadius: 15,
                                    fontSize: 8,
                                    text: AppStrings.signIn.tr,
                                    onTap: () {
                                      signInController.webSignInTap();
                                    },
                                  ),
                                ),
                                20.verticalSpace,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppStrings.dontHaveAccount.tr,
                                      style: TextStyle(
                                        color: AppColors.darkGrey,
                                        fontSize: 6.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    5.horizontalSpace,
                                    InkWell(
                                      onTap: () => signInController.goToSignUpScreenWeb(),
                                      child: Text(
                                        AppStrings.signUp.tr,
                                        style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontSize: 6.sp,
                                          fontWeight: FontWeight.w700,
                                          decoration: TextDecoration.underline,
                                          decorationColor: AppColors.primaryColor,
                                          fontFamily: AppFonts.jakartaMedium,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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