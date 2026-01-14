import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/auth_screens/web_sign_in_screen.dart';
import '../../utils/app_fonts.dart';
import '../utils/app_bindings.dart';

class WebSubmitVerificationDialog extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return  Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Container(
        width: 500.w,
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  Get.offAll(() => WebSignInScreen(), binding: AppBinding());
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(4.r),
                  child: Icon(Icons.close, color: Colors.blue, size: 10.sp),
                ),
              ),
            ),
            Image.asset(
              "assets/images/verification_dialog_image.png", // Replace with your asset
              height: 80.h,
              fit: BoxFit.contain,
            ),
            20.verticalSpace,
            Text(
              "Submit For Verification",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.jakartaBold,
                fontSize: 10.sp,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
            15.verticalSpace,
            Text(
              "“Your verification request has been received. Expected verification time: 48–72 hours. You’ll receive an email confirmation and can track your status in your profile.”",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 6.sp,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            30.verticalSpace,
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 60.r,
                  width: 60.r,
                  child: CircularProgressIndicator(
                    value: 0.7,
                    strokeWidth: 6.r,
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
                Text(
                  "Verifying",
                  style: TextStyle(
                    fontSize: 4.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            10.verticalSpace,
          ],
        ),
      ),
    );
  }
}