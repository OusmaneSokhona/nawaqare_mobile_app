import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controllers/forget_password_contorller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/validation_check_list.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/app_images.dart';

class UpdatePassword extends StatelessWidget {
  UpdatePassword({super.key});
  final ForgetPasswordController controller = Get.put(ForgetPasswordController());

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
          key: controller.formKeyUpdate,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SingleChildScrollView(
              child: Column(children: [
                80.verticalSpace,
                Row(
                  children: [
                    InkWell(
                        onTap: (){
                          Get.back();
                        },
                        child: Image.asset(AppImages.backIcon, height: 32.h, width: 32.w,)),
                    7.horizontalSpace,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppStrings.updatePassword.tr,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: AppFonts.jakartaBold,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                20.verticalSpace,
                Obx(
                      ()=> CustomTextField(
                    labelText: AppStrings.oldPassword.tr,
                    hintText: AppStrings.enterPasswordHint.tr,
                    prefixIcon: Icons.lock_outline,
                    isPasswordField: true,
                    isEnabled: controller.confirmNewPasswordVisibility.value,
                    validator: controller.validateConfirmPassword,
                    onTapEye: (){
                      controller.confirmNewPasswordVisibility.value = !controller.confirmNewPasswordVisibility.value;
                    },
                  ),
                ),
                20.verticalSpace,
                Obx(
                      ()=> CustomTextField(
                    labelText: AppStrings.newPassword.tr,
                    hintText: AppStrings.enterPasswordHint.tr,
                    prefixIcon: Icons.lock_outline,
                    isPasswordField: true,
                    controller: controller.newPassword,
                    isEnabled: controller.newPasswordVisibility.value,
                    onFocusChange: controller.setPasswordActive,
                    validator: controller.validatePassword,
                    onChanged: (value) => controller.currentPassword.value = value,
                    validationView: controller.isPasswordActive.value
                        ? Obx(
                          () => ValidationChecklist(
                        rules: controller.getValidationRules(),
                      ),
                    )
                        : null,
                    onTapEye: (){
                      controller.newPasswordVisibility.value = !controller.newPasswordVisibility.value;
                    },
                  ),
                ),
                20.verticalSpace,
                Obx(
                      ()=> CustomTextField(
                    labelText: AppStrings.confirmPassword.tr,
                    hintText: AppStrings.enterPasswordHint.tr,
                    prefixIcon: Icons.lock_outline,
                    isPasswordField: true,
                    controller: controller.confrimNewPassword,
                    isEnabled: controller.confirmNewPasswordVisibility.value,
                    validator: controller.validateConfirmPassword,
                    onTapEye: (){
                      controller.confirmNewPasswordVisibility.value = !controller.confirmNewPasswordVisibility.value;
                    },
                  ),
                ),
                10.verticalSpace,
                40.verticalSpace,
                CustomButton(
                    borderRadius: 15,
                    text: AppStrings.update.tr,
                    onTap: (){
                      if (controller.formKeyForget.currentState!.validate()) {
                        print("Validation passed!");
                      } else {
                        print("Validation failed.");
                      }
                    },
                    fontSize: 18
                ),
                10.verticalSpace,
                CustomButton(
                  borderRadius: 15,
                  text: AppStrings.cancel.tr,
                  onTap: (){Get.back();},
                  bgColor: AppColors.inACtiveButtonColor,
                  fontColor: Colors.black,
                ),
              ],),
            ),
          ),
        ),
      ),
    );
  }
}