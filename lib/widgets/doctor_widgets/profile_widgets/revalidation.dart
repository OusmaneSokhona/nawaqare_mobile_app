import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_home_controller.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_profile_controller.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/doctor_widgets/profile_widgets/doctor_health_space_grid.dart';
import 'package:patient_app/widgets/doctor_widgets/profile_widgets/submit_revalidation_dialog.dart';

class Revalidation extends StatelessWidget {
  Revalidation({super.key});
  final DoctorProfileController controller = Get.find();
  final DoctorHomeController homeController = Get.find<DoctorHomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final doctor = homeController.currentUser.value;
      final doctorImage = doctor?.profileImage;
      final doctorTitle = 'Dr. ${doctor?.fullName ?? ''}';

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: CircleAvatar(
              radius: 50.h,
              backgroundColor: Colors.white,
              backgroundImage: doctorImage != null && doctorImage.isNotEmpty
                  ? NetworkImage(doctorImage)
                  : const AssetImage("assets/demo_images/home_demo_image.png")
              as ImageProvider,
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  doctorTitle,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2937),
                    fontFamily: AppFonts.jakartaBold,
                  ),
                ),
                5.horizontalSpace,
                Image.asset("assets/images/verified_tick_icon.png", height: 21.sp),
              ],
            ),
          ),
          Center(
            child: Text(
              '${AppStrings.lastUpdate.tr}: 12/Sep/2025',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade500),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 70.w,
                  height: 70.h,
                  child: CircularProgressIndicator(
                    value: 0.7,
                    strokeWidth: 8,
                    backgroundColor: AppColors.red.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.red),
                  ),
                ),
                Text(
                  '30 ${AppStrings.days.tr}',
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
          8.verticalSpace,
          Center(
            child: Text(
              '${AppStrings.verificationExpiresIn.tr} 30 ${AppStrings.days.tr}',
              style: TextStyle(fontSize: 12.sp, color: AppColors.darkGrey),
            ),
          ),
          10.verticalSpace,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.yellow.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(color: AppColors.yellow.withOpacity(0.2), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset("assets/images/alert_icon.png", height: 45.h),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    '${AppStrings.revalidationWarning.tr} 30 ${AppStrings.days.tr}. ${AppStrings.pleaseRevalidate.tr}',
                    style: TextStyle(fontSize: 13.sp, color: const Color(0xFF333333), fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          20.verticalSpace,
          CustomButton(
            borderRadius: 15,
            text: AppStrings.revalidateData.tr,
            onTap: () {
              Get.dialog(const SubmitRevalidationDialog());
            },
            height: 45.h,
          ),
          10.verticalSpace,
          Text(
            AppStrings.actions.tr,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
          ),
          SizedBox(height: 10.h),
          DoctorHealthSpaceGrid(profileController: controller),
          const SizedBox(height: 20),
        ],
      );
    });
  }
}