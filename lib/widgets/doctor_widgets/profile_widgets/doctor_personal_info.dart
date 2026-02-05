import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_home_controller.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_profile_controller.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/doctor_widgets/appointment_widgets/doctor_past_appoinment_widget.dart';
import 'package:patient_app/widgets/doctor_widgets/profile_widgets/doctor_health_space_grid.dart';
import 'package:patient_app/widgets/doctor_widgets/profile_widgets/profile_completion_loading.dart';
import 'package:patient_app/widgets/doctor_widgets/profile_widgets/profile_switch.dart';
import '../../patient_widgets/profile_widgets/info_row.dart';

class DoctorPersonalInfo extends StatelessWidget {
  DoctorPersonalInfo({super.key});
  final DoctorProfileController controller = Get.find();
  final DoctorHomeController homeController = Get.find<DoctorHomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final doctor = homeController.currentUser.value;
      final doctorImage = doctor?.profileImage;
      final doctorName = doctor?.fullName ?? 'Alex Martin';
      final doctorTitle = 'Dr. ${doctor?.fullName ?? 'Daniel Lee'}';
      final doctorEmail = doctor?.email ?? 'abc@gmail.com';
      final doctorPhone = doctor?.phoneNumber ?? '+1 234 567 890';
      final doctorAddress = doctor?.clinicAddress ?? '32 Example St';
      final doctorExperience = doctor?.experience?.toString() ?? '7';
      final doctorSpecialization = doctor?.medicalSpecialty ?? 'Cardiology';
      final doctorCountry = doctor?.country ?? 'Pakistan';

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
                    fontFamily: AppFonts.jakartaBold,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2937),
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
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          const SizedBox(height: 10),
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
              child: Text(AppStrings.editPersonalInfo.tr, style: TextStyle(fontSize: 14.sp)),
            ),
          ),
          5.verticalSpace,
          const ProfileCompletionLoading(),
          15.verticalSpace,
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
                CardHeader(title: AppStrings.identity.tr, fontSize: 18.sp, fontWeight: FontWeight.w500),
                InfoRow(label: AppStrings.fullName.tr, value: doctorName),
                InfoRow(label: AppStrings.dob.tr, value: '02/Sep/2025'),
                CardHeader(title: AppStrings.contact.tr, fontSize: 18.sp, fontWeight: FontWeight.w500),
                InfoRow(label: AppStrings.email.tr, value: doctorEmail),
                InfoRow(label: AppStrings.phone.tr, value: doctorPhone),
                InfoRow(label: AppStrings.address.tr, value: doctorAddress.replaceAll('\n', ' ')),
                CardHeader(title: AppStrings.demographics.tr, fontSize: 18.sp, fontWeight: FontWeight.w500),
                InfoRow(label: AppStrings.gender.tr, value: AppStrings.male.tr),
                InfoRow(label: AppStrings.nationality.tr, value: "Islam"),
                InfoRow(label: AppStrings.idNumber.tr, value: "31101-5678-9876"),
                CardHeader(title: AppStrings.profileDisplay.tr, fontSize: 17.sp, fontWeight: FontWeight.w500),
                ProfileSwitch(title: AppStrings.male.tr, isEnabled: true),
                ProfileSwitch(title: AppStrings.female.tr),
                ProfileSwitch(title: AppStrings.publicProfile.tr, isEnabled: true),
                CardHeader(title: AppStrings.aboutMe.tr, fontSize: 17.sp, fontWeight: FontWeight.w500),
                Text(
                  "Dr. David Patel, a dedicated cardiologist, brings a wealth of experience to Golden Gate Cardiology Center in Golden Gate, CA.",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.lightGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Text(
            AppStrings.actions.tr,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 10.h),
          DoctorHealthSpaceGrid(profileController: controller),
          const SizedBox(height: 20),
        ],
      );
    });
  }
}