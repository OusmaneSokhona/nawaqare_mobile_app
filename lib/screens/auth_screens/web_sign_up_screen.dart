import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/auth_controllers/sign_up_controller.dart';
import 'package:patient_app/screens/auth_screens/web_demographic_screen.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import '../../utils/app_fonts.dart';
import '../../widgets/progress_stepper.dart';
import '../../widgets/validation_check_list.dart';

class WebSignUpScreen extends StatelessWidget {
  WebSignUpScreen({super.key});

  final SignUpController signUpController = Get.put(SignUpController());

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
                          "Your central workspace to manage patients, appointments, and care.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 6.sp, color: Colors.white),
                        ),
                        const Spacer(),
                        Text(
                          "Efficient Care, Simplified",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        10.verticalSpace,
                        Text(
                          "Manage consultations, prescriptions, and follow-ups with ease.",
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
                        child: SingleChildScrollView(
                          child: Form(
                            key: signUpController.formKey,
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
                                  "Create Account",
                                  style: TextStyle(
                                    fontSize: 8.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                5.verticalSpace,
                                Text(
                                  "Create Your Verified Medical Profile To Start Offering Consultations",
                                  style: TextStyle(
                                    color: AppColors.darkGrey,
                                    fontSize: 5.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                15.verticalSpace,
                                Obx(
                                      () => ProgressStepper(
                                    currentStep: 1,
                                    totalSteps: signUpController.type.value == "patient" ? 4 : 5,
                                  ),
                                ),
                                15.verticalSpace,
                                CustomTextField(
                                  height: 50.h,
                                  labelText: AppStrings.fullName.tr,
                                  prefixIcon: Icons.person_outline_outlined,
                                  hintText: "Saira Tahir",
                                  controller: signUpController.nameController,
                                  validator: signUpController.signInController.nameValidator,
                                ),
                                10.verticalSpace,
                                CustomTextField(
                                  height: 50.h,
                                  labelText: AppStrings.email.tr,
                                  controller: signUpController.emailController,
                                  hintText: 'Saira@gmail.com',
                                  prefixIcon: Icons.mail_outline,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: signUpController.signInController.emailValidator,
                                ),
                                10.verticalSpace,
                                CustomTextField(
                                  height: 50.h,
                                  labelText: AppStrings.phoneNumber.tr,
                                  hintText: "+33 3 6 12 34 56 78",
                                  prefixIcon: Icons.phone,
                                  keyboardType: TextInputType.phone,
                                  controller: signUpController.phoneNumberController,
                                  validator: signUpController.signInController.phoneNumberValidator,
                                ),
                                10.verticalSpace,
                                Obx(
                                      () => CustomTextField(
                                    height: 50.h,
                                    labelText: AppStrings.password.tr,
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
                                    validationView: signUpController.isPasswordActive.value &&
                                        signUpController.hasPasswordInteracted.value
                                        ? Obx(
                                          () => ValidationChecklist(
                                        rules: signUpController.getValidationRules(),
                                      ),
                                    )
                                        : null,
                                  ),
                                ),
                                15.verticalSpace,
                                Obx(
                                      () => signUpController.type.value == "doctor"
                                      ? InkWell(
                                    onTap: () {
                                      signUpController.isRegisteredProfessional.value =
                                      !signUpController.isRegisteredProfessional.value;
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          signUpController.isRegisteredProfessional.value
                                              ? Icons.check_box
                                              : Icons.check_box_outline_blank,
                                          color: signUpController.isRegisteredProfessional.value
                                              ? AppColors.primaryColor
                                              : Colors.grey.shade400,
                                          size: 6.sp,
                                        ),
                                        5.horizontalSpace,
                                        Expanded(
                                          child: Text(
                                            "I am a registered medical professional",
                                            style: TextStyle(
                                              fontSize: 5.sp,
                                              fontFamily: AppFonts.jakartaRegular,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                      : const SizedBox(),
                                ),
                                30.verticalSpace,
                                Center(
                                  child: CustomButton(
                                    borderRadius: 15,
                                    fontSize: 8,
                                    text: AppStrings.continueText.tr,
                                    onTap: () {
                                      if (signUpController.formKey.currentState!.validate()) {
                                        Get.to(WebDemographicScreen());
                                      } else {
                                        signUpController.markPasswordInteracted();
                                      }
                                    },
                                  ),
                                ),
                                20.verticalSpace,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppStrings.alreadyHaveAccount.tr,
                                      style: TextStyle(
                                        color: AppColors.darkGrey,
                                        fontSize: 6.sp,
                                        fontWeight: FontWeight.w500,
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