import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_profile_controller.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/doctor_widgets/appointment_widgets/doctor_past_appoinment_widget.dart';
import 'package:patient_app/widgets/doctor_widgets/profile_widgets/doctor_health_space_grid.dart';
import 'package:patient_app/widgets/doctor_widgets/profile_widgets/profile_completion_loading.dart';
import '../../patient_widgets/profile_widgets/info_row.dart';

class DoctorProfessionalInfo extends StatelessWidget {
  DoctorProfessionalInfo({super.key});
  final DoctorProfileController controller = Get.find();

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
          const SizedBox(height: 10),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.user.value.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                    fontFamily: AppFonts.jakartaBold
                  ),
                ),
                5.horizontalSpace,
                Image.asset("assets/images/verified_tick_icon.png",height: 21.sp,),
              ],
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
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 88.w),
            child: ElevatedButton(
              onPressed: () {
                controller.editProfessionalInfo();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(AppStrings.editProfessionalInfo.tr, style: TextStyle(fontSize: 12.sp)),
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
                CardHeader(
                  title: AppStrings.registrationLicensing.tr,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                ),
                InfoRow(
                  label: AppStrings.nationalIdentityDocument.tr,
                  value: "MA-PK-457621",
                  labelTextSize: 15,
                  valueTextSize: 12,
                ),
                InfoRow(
                  label: AppStrings.dateOfRegistration.tr,
                  value: '15 March 2018',
                ),
                CardHeader(
                  title: AppStrings.practiceInformation.tr,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                ),
                InfoRow(
                  label: AppStrings.medicalSpecialty.tr,
                  value: AppStrings.cardiology.tr,
                ),
                InfoRow(
                  label: AppStrings.placeOfPractice.tr,
                  value: "Allied Hospital, Faisalabad",
                  labelTextSize: 15,
                  valueTextSize: 12,
                ),
                InfoRow(
                  label: AppStrings.experience.tr,
                  value: "7 ${AppStrings.years.tr}",
                ),
                InfoRow(label: AppStrings.year.tr, value: '5'),
                InfoRow(label: AppStrings.nationality.tr, value: AppStrings.pakistani.tr),
                InfoRow(label: AppStrings.country.tr, value: AppStrings.pakistan.tr),
                InfoRow(
                  label: AppStrings.language.tr,
                  value: AppStrings.english.tr,
                  showDivider: false,
                ),
                Text(
                  AppStrings.publicProfileNote.tr,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.darkGrey,
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
      ),
    );
  }
}