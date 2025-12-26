import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';

class ProfileCompletionLoading extends StatelessWidget {
  const ProfileCompletionLoading({super.key});

  @override
  Widget build(BuildContext context) {
    // Ideally, this value comes from a controller, but keeping the 0.4 logic for now
    const double completionValue = 0.4;
     int completionPercentage = (completionValue * 100).toInt();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.profileCompletion.tr,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.darkGrey,
              ),
            ),
            Text(
              "$completionPercentage%",
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
        4.verticalSpace,
        LinearProgressIndicator(
          value: completionValue,
          backgroundColor: AppColors.onboardingBackground,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
          minHeight: 6.h,
          borderRadius: BorderRadius.circular(3.h),
        ),
      ],
    );
  }
}