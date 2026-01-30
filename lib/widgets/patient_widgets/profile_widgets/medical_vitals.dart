import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/home_controller.dart';
import 'package:patient_app/controllers/patient_controllers/profile_controller.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'heatlh_space_grid.dart';
import 'info_row.dart';

class MedicalVitalsProfile extends GetView<ProfileController> {
  const MedicalVitalsProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();

    return Obx(() {
      final user = homeController.currentUser.value;
      final userName = user?.fullName ?? '';
      final userImage = user?.patientData?.profileImage;
      final userHeight = user?.patientData?.height ?? '';
      final userWeight = user?.patientData?.weight ?? '';
      final userBmi = user?.patientData?.bmi ?? 0.0;
      final userBloodPressure = user?.patientData?.bloodPressure ?? '';
      final userHeartRate = user?.patientData?.heartRate ?? '';

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: CircleAvatar(
              radius: 50.w,
              backgroundColor: Colors.white,
              backgroundImage: userImage != null && userImage.isNotEmpty
                  ? NetworkImage(userImage)
                  : AssetImage("assets/demo_images/home_demo_image.png") as ImageProvider,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              '${AppStrings.hello.tr} ${userName.isNotEmpty ? userName.split(' ').first : "user"}',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 88.w),
            child: ElevatedButton(
              onPressed: controller.editMedicalVitals,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                AppStrings.editMedicalVitals.tr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                InfoRow(
                  label: AppStrings.height.tr,
                  value: userHeight.isNotEmpty ? '$userHeight cm' : AppStrings.notAvailable.tr,
                ),
                InfoRow(
                  label: AppStrings.weight.tr,
                  value: userWeight.isNotEmpty ? '$userWeight kg' : AppStrings.notAvailable.tr,
                ),
                InfoRow(
                  label: AppStrings.bmi.tr,
                  value: userBmi > 0 ? userBmi.toStringAsFixed(1) : AppStrings.notAvailable.tr,
                ),
                InfoRow(
                  label: AppStrings.bloodPressure.tr,
                  value: userBloodPressure.isNotEmpty ? userBloodPressure : AppStrings.notAvailable.tr,
                ),
                InfoRow(
                  label: AppStrings.heartRate.tr,
                  value: userHeartRate.isNotEmpty ? '$userHeartRate bpm' : AppStrings.notAvailable.tr,
                  showDivider: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Text(
            AppStrings.healthSpace.tr,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          HeatlhSpaceGrid(profileController: controller),
        ],
      );
    });
  }
}