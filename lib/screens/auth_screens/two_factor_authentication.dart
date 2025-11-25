import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/auth_screens/verification_screen.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_images.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/verification_via_widget.dart';

import '../../controllers/auth_controllers/sign_up_controller.dart';

class TwoFactorAuthentication extends StatelessWidget {
  TwoFactorAuthentication({super.key});
  SignUpController signUpController=Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.onboardingBackground,AppColors.lightWhite],begin: Alignment.topCenter,end: Alignment.bottomCenter),
        ),
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              80.verticalSpace,
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Two-Factor\n Authentication",textAlign: TextAlign.start,style: TextStyle(
                      color: Colors.black,
                      fontFamily: AppFonts.jakartaBold,
                      fontSize: 29.sp,
                      fontWeight: FontWeight.w700,
                    ),),
                  ),
                ],
              ),
              20.verticalSpace,
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Then Let’s Submit Password Reset.",style: TextStyle(
                  color: AppColors.darkGrey,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),),
              ),
              20.verticalSpace,
              VerificationViaWidget(title: "Verification via Email", subtitle: "Verify code via email.", iconPath: AppImages.mailIcon,onTap: (){
                Get.to(VerificationScreen(authController:signUpController ,title: "A 6-digit Code Has Been Sent To Email",subTitle: "ali@gmail.com",));
              },iconColor: AppColors.darkGrey,),
              25.verticalSpace,
              VerificationViaWidget(title: "Verification via Whatsapp", subtitle: "Verify code via Whatsapp.", iconPath: AppImages.whatsAppIcon,onTap: (){
                Get.to(VerificationScreen(authController: signUpController,title: "A 6-digit Code Has Been Sent To Whatsapp",subTitle: "+33 3 6 12 34 56 78",));
              },),
              70.verticalSpace,
              CustomButton(borderRadius: 15, text: "Back", onTap: (){Get.back();}),
            ],
          ),
        ),
      ),
    );
  }
}
