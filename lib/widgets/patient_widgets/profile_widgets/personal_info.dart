import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_strings.dart';

import '../../../controllers/patient_controllers/profile_controller.dart';
import 'heatlh_space_grid.dart';
import 'info_row.dart';

class PersonalInfo extends StatelessWidget {
  PersonalInfo({super.key});
  final ProfileController controller = Get.put(ProfileController());

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
                width: 100.w,
                height: 100.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              controller.user.value.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
          Center(
            child: Text(
              '${AppStrings.lastUpdate.tr}: ${controller.user.value.lastUpdate}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 88.w),
            child: ElevatedButton(
              onPressed: controller.editPersonalInfo,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                AppStrings.editPersonalInfo.tr,
                style: TextStyle(fontSize: 11.sp),
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
                    label: AppStrings.fullName.tr,
                    value: controller.user.value.name),
                InfoRow(
                    label: AppStrings.dob.tr,
                    value: '02/Sep/2025'), // Consider making this dynamic in your model
                InfoRow(
                    label: AppStrings.gender.tr,
                    value: AppStrings.male.tr),
                InfoRow(
                    label: AppStrings.patientId.tr,
                    value: controller.user.value.patientId),
                InfoRow(
                    label: AppStrings.countryOfResidence.tr,
                    value: controller.user.value.country),
                InfoRow(
                    label: AppStrings.email.tr,
                    value: controller.user.value.email),
                InfoRow(
                    label: AppStrings.phone.tr,
                    value: controller.user.value.phone),
                InfoRow(
                  label: AppStrings.address.tr,
                  value: controller.user.value.address.replaceAll('\n', ' '),
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
          SizedBox(height: 10.h),
          HeatlhSpaceGrid(profileController: controller),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}