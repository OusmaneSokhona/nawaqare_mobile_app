import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/auth_screens/sign_in_screen.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/widgets/custom_button.dart';

class DataPrivacyConsent extends StatelessWidget {
   DataPrivacyConsent({super.key});
RxBool isChecked = false.obs;
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
          padding:  EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              80.verticalSpace,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Data Privacy &\n Consent",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28.sp,
                    fontFamily: AppFonts.jakartaBold,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              20.verticalSpace,
              Text(
                "Your data is protected under GDPR and CNPD compliance standards, with secure storage and HDS-certified hosting.  We use advanced end-to-end encryption and role-based access controls to ensure that only authorized professionals can view sensitive information.",
                style: TextStyle(
                  color: AppColors.lightGrey,
                  fontSize: 16.sp,
                  fontFamily: AppFonts.jakartaRegular,
                  fontWeight: FontWeight.w400,
                ),
              ),
              15.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding:  EdgeInsets.only(bottom: 9.h),
                    child: Obx(
                      ()=> SizedBox(
                        width: 26.w,
                        child: Checkbox(
                          activeColor: AppColors.primaryColor,
                          value: isChecked.value,
                          onChanged: (bool? value) {
                            isChecked.value = value ?? false;
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "I have read and accept the Terms of Use and Privacy Policy.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontFamily: AppFonts.jakartaRegular,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              40.verticalSpace,
              Align(
                alignment: Alignment.centerLeft,
                child: Text("View full privacy policy",style: TextStyle(fontFamily: AppFonts.jakartaMedium,fontSize: 16.sp,fontWeight:FontWeight.w500,color: AppColors.primaryColor,decoration: TextDecoration.underline,decorationColor: AppColors.primaryColor),),
              ),
              7.verticalSpace,
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Terms of medical data processing",style: TextStyle(fontFamily: AppFonts.jakartaMedium,fontSize: 16.sp,fontWeight:FontWeight.w500,color: AppColors.primaryColor,decoration: TextDecoration.underline,decorationColor: AppColors.primaryColor),),
              ),
              60.verticalSpace,
              CustomButton(borderRadius: 15, text: "Accept & Continue", onTap: (){Get.to(SignInScreen());},fontSize: 18,),
              20.verticalSpace,
              CustomButton(borderRadius: 15, text: "Decline", onTap: (){Get.to(SignInScreen());},fontSize: 18,bgColor: AppColors.inACtiveButtonColor,fontColor: Colors.black,),
            ],
          ),
        ),
      ),
    );
  }
}
