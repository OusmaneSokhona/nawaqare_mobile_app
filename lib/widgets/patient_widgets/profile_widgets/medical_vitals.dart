import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/profile_controller.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'heatlh_space_grid.dart';
import 'info_row.dart';

class MedicalVitalsProfile extends GetView<ProfileController> {
  const MedicalVitalsProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: ClipOval(
              child: Image.asset(
                controller.user.value.profileImageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              '${AppStrings.hello.tr} ${controller.user.value.name.split(' ').first}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
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
                  value: '${controller.medicalVitals.value.heightCm} cm',
                ),
                InfoRow(
                  label: AppStrings.weight.tr,
                  value: '${controller.medicalVitals.value.weightKg} kg',
                ),
                InfoRow(
                  label: AppStrings.bmi.tr,
                  value: controller.medicalVitals.value.bmi.toStringAsFixed(1),
                ),
                InfoRow(
                  label: AppStrings.bloodPressure.tr,
                  value: controller.medicalVitals.value.bloodPressure,
                ),
                InfoRow(
                  label: AppStrings.heartRate.tr,
                  value: '${controller.medicalVitals.value.heartRateBpm} bpm',
                  showDivider: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Text(
            AppStrings.healthSpace.tr,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          HeatlhSpaceGrid(profileController: controller),
        ],
      ),
    );
  }
}