import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../../controllers/doctor_controllers/profile_completion_controller.dart';


class ProfileCompletionLoading extends StatelessWidget {
  const ProfileCompletionLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileCompletionController controller = Get.put(ProfileCompletionController());
    controller.fetchProfileCompletion();

    return Obx(() {
      if (controller.isLoading.value) {
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
                SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                  ),
                ),
              ],
            ),
            4.verticalSpace,
            LinearProgressIndicator(
              value: 0,
              backgroundColor: AppColors.onboardingBackground,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
              minHeight: 6.h,
              borderRadius: BorderRadius.circular(3.h),
            ),
          ],
        );
      }

      if (controller.errorMessage.value.isNotEmpty) {
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
                  "0%",
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
              value: 0,
              backgroundColor: AppColors.onboardingBackground,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
              minHeight: 6.h,
              borderRadius: BorderRadius.circular(3.h),
            ),
          ],
        );
      }

      final int completionPercentage = (controller.completionValue.value * 100).toInt();

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
            value: controller.completionValue.value,
            backgroundColor: AppColors.onboardingBackground,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            minHeight: 6.h,
            borderRadius: BorderRadius.circular(3.h),
          ),
        ],
      );
    });
  }
}