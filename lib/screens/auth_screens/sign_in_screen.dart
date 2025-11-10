import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/sign_in_controller.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/custom_text_field.dart';

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
          gradient: LinearGradient(colors:[
            AppColors.onboardingBackground,
            Colors.white,
          ],begin: Alignment.topCenter,end: Alignment.bottomCenter),
        ),
        child: Form(
          key: signInController.formKey,
          child: Column(children: [
            100.verticalSpace,
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
            20.verticalSpace,
            CustomTextField(labelText: "Email",controller: signInController.emailController,validator: signInController.emailValidator,hintText: 'Saira@gmail.com',
              prefixIcon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,),
            20.verticalSpace,
            Obx(
              ()=> CustomTextField(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: Icons.lock_outline,
                isPasswordField: true,
                controller: signInController.passwordController,
                isEnabled: signInController.passwordVisibility.value,
                validator: signInController.passwordValidator,
                onTapEye: (){
                  signInController.passwordVisibility.value = !signInController.passwordVisibility.value;
                },
              ),
            ),
            10.verticalSpace,
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20.w),
              child: Align(alignment: Alignment.centerRight,child: Text("Forget Password",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primaryColor,
                  fontFamily: AppFonts.jakartaMedium,),
              ),),
            ),
            40.verticalSpace,
            CustomButton(borderRadius: 15, text: "Sign In", onTap: (){},fontSize: 18),
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
                  // signInController.goToSignUpScreen();
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
            Spacer(),
            Image.asset("assets/images/sign_in_bg.png",height: 180.h,)
          ],),
        ),

      )
    );
  }
}
