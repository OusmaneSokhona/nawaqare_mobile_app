import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/auth_controller.dart';
import 'package:patient_app/controllers/forget_password_contorller.dart';
import 'package:patient_app/screens/auth_screens/reset_password.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_images.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/verification_code_widget.dart';

import '../../utils/app_colors.dart';

class VerificationScreen extends StatelessWidget {
  final String title;
  final String subTitle;
  ForgetPasswordController authController;
   VerificationScreen({super.key,required this.title, required this.subTitle,required this.authController});

  @override
  Widget build(BuildContext context) {
    authController.startTimer();
    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.onboardingBackground,AppColors.lightWhite],begin: Alignment.topCenter,end: Alignment.bottomCenter),
        ),
     child: Padding(
       padding: EdgeInsets.symmetric(horizontal: 20.w),
       child: Column(
        children: [
          80.verticalSpace,
          Row(
            children: [
              InkWell(
                  onTap: (){
                    authController.clearAllFields();
                    Get.back();
                  },
                  child: Image.asset("assets/images/back_icon.png",height: 32.h,width: 32.w,)),
              7.horizontalSpace,
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Verification",style: TextStyle(
                  color: Colors.black,
                  fontFamily: AppFonts.jakartaBold,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                ),),
              ),
            ],
          ),
          10.verticalSpace,
          Align(
            alignment: Alignment.centerLeft,
            child: Text(title,style: TextStyle(
              color: AppColors.darkGrey,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),),
          ),
          3.verticalSpace,
          Align(
            alignment: Alignment.centerLeft,
            child: Text(subTitle,style: TextStyle(
              color: Colors.black,
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
            ),),
          ),
          20.verticalSpace,
          VerificationCodeWidget(controller: authController,),
          20.verticalSpace,
          Obx(
            ()=> Text(
              authController.isTimerActive.value
                  ? '${authController.formatTime(authController.timerCount.value)}'
                  : 'You can request a new code now.',
              style: TextStyle(
                color: authController.isTimerActive.value ? Colors.black : Colors.red,
                fontSize: authController.isTimerActive.value ? 24.sp : 15.sp,
                fontWeight: FontWeight.w700,
                fontFamily: AppFonts.jakartaBold,
              ),
            ),
          ),
          5.verticalSpace,
          Obx(
              ()=> !authController.isTimerActive.value?SizedBox.shrink():
            Text("Code expires in 01:00",
            style: TextStyle(
                color: AppColors.red,
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          60.verticalSpace,
          CustomButton(borderRadius: 15, text: "Confirms", onTap: (){
            if(authController.isCodeComplete.value){
            authController.timer?.cancel();
            Get.to(ResetPassword());}
          }),
          20.verticalSpace,
          InkWell(
            onTap: (){
              authController.startTimer();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               Image.asset(AppImages.whatsAppGreenIcon,height: 27.sp,),
                Text("Re-send To Whatsapp",
                  style: TextStyle(
                    color:AppColors.darkGrey,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.darkGrey,
                    fontFamily: AppFonts.jakartaMedium,
                  ),
                )
              ],
            ),
          )
        ],
       ),
     ),
      ),
    );
  }
}
