import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/auth_screens/sign_in_screen.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';

class SubmitForVerificationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/images/verification_dialog_image.png",
                  height: 110.h,
                ),
                SizedBox(height: 20.0),
                Text(
                  'Submit For Verification',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    fontFamily: AppFonts.jakartaBold,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  '“Your verification request has been received. Expected verification time: 48–72 hours. You’ll receive an an email confirmation and can track your status in your profile.”',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15.0, color: Color(0xFF757575)),
                ),
                SizedBox(height: 30.0),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 90,
                        height: 90,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryColor,
                          ),
                          strokeWidth: 5.0,
                          backgroundColor: AppColors.onboardingBackground,
                        ),
                      ),
                      Text(
                        'Verifying',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 15,
            right: 15,
            child: InkWell(
              onTap: () {
                Get.offAll(SignInScreen());
              },
              child: Container(
                height: 30.h,
                width: 30.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor,
                ),
                alignment: Alignment.center,
                child: Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
