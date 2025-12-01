import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient_app/utils/app_colors.dart';

class ProfileCompletionLoading extends StatelessWidget {
  const ProfileCompletionLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Profile Completion",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGrey,
                )),
            Text("40%",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                )),
          ],
        ),
        4.verticalSpace,
        LinearProgressIndicator(
          value: 0.4,
          backgroundColor: AppColors.onboardingBackground,
          valueColor:
              AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
          minHeight: 6.h,
          borderRadius: BorderRadius.circular(3.h),
        ),
      ],
    );
  }
}
