import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/models/profile_models.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../../controllers/patient_controllers/home_controller.dart';
import '../../../controllers/patient_controllers/profile_controller.dart';
import 'heatlh_space_grid.dart';
import 'info_row.dart';

class PersonalInfo extends StatelessWidget {
  PersonalInfo({super.key});
  final ProfileController controller = Get.put(ProfileController());
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = homeController.currentUser.value;
      final userName = user?.fullName ?? '';
      final userImage = user?.patientData?.profileImage;
      final userEmail = user?.email ?? '';
      final userPhone = user?.phoneNumber ?? '';
      final userCountry = user?.patientData?.country ?? '';
      final userGender = user?.patientData?.gender ?? '';
      final userAddress = user?.patientData?.address ?? '';
      final userDob = user?.patientData?.dob ?? DateTime.now();

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
              userName,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
          ),
          Center(
            child: Text(
              '${AppStrings.lastUpdate.tr}: ${controller.user.value.lastUpdate}',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 88.w),
            child: ElevatedButton(
              onPressed:(){
                controller.editPersonalInfo(user!);
              },
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
                  value: userName,
                ),
                InfoRow(
                  label: AppStrings.dob.tr,
                  value: userDob != null
                      ? '${userDob.day}/${userDob.month}/${userDob.year}'
                      : AppStrings.notAvailable.tr,
                ),
                InfoRow(
                  label: AppStrings.gender.tr,
                  value: userGender.isNotEmpty ? userGender : AppStrings.notAvailable.tr,
                ),
                InfoRow(
                  label: AppStrings.patientId.tr,
                  value: user?.id ?? AppStrings.notAvailable.tr,
                ),
                InfoRow(
                  label: AppStrings.countryOfResidence.tr,
                  value: userCountry.isNotEmpty ? userCountry : AppStrings.notAvailable.tr,
                ),
                InfoRow(
                  label: AppStrings.email.tr,
                  value: userEmail,
                ),
                InfoRow(
                  label: AppStrings.phone.tr,
                  value: userPhone,
                ),
                InfoRow(
                  label: AppStrings.address.tr,
                  value: userAddress.isNotEmpty ? userAddress.replaceAll('\n', ' ') : AppStrings.notAvailable.tr,
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
          SizedBox(height: 10.h),
          HeatlhSpaceGrid(profileController: controller),
          const SizedBox(height: 20),
        ],
      );
    });
  }
}