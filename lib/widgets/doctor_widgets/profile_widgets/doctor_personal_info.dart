import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_profile_controller.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/widgets/doctor_widgets/appointment_widgets/doctor_past_appoinment_widget.dart';
import 'package:patient_app/widgets/doctor_widgets/profile_widgets/doctor_health_space_grid.dart';
import 'package:patient_app/widgets/doctor_widgets/profile_widgets/profile_completion_loading.dart';
import 'package:patient_app/widgets/doctor_widgets/profile_widgets/profile_switch.dart';
import '../../patient_widgets/profile_widgets/info_row.dart';



class DoctorPersonalInfo extends StatelessWidget{
  DoctorPersonalInfo({super.key});
  DoctorProfileController controller=Get.find();
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
              'Last update: ${controller.user.value.lastUpdate}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 88.w),
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
              child:  Text('Edit Personal Info', style: TextStyle(fontSize: 14.sp)),
            ),
          ),
          5.verticalSpace,
          ProfileCompletionLoading(),
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
                CardHeader(title: "Identity",fontSize: 18.sp,fontWeight: FontWeight.w500,),
                InfoRow(label: 'Full Name', value: controller.user.value.name),
                const InfoRow(label: 'Date of birth', value: '02/Sep/2025'),
                CardHeader(title: "Contact",fontSize: 18.sp,fontWeight: FontWeight.w500,),
                InfoRow(label: 'Email', value: controller.user.value.email),
                InfoRow(label: 'Phone', value: controller.user.value.phone),
                InfoRow(label: 'Address', value: controller.user.value.address.replaceAll('\n', ' '),),
                CardHeader(title: "Demographics",fontSize: 18.sp,fontWeight: FontWeight.w500,),
                const InfoRow(label: 'Gender', value: 'Male'),
                InfoRow(label: 'Nationality', value: "Islam"),
                InfoRow(label: 'ID Number', value: "31101-5678-9876"),
                CardHeader(title: "Profile Display",fontSize: 17.sp,fontWeight: FontWeight.w500,),
                ProfileSwitch(title: "Male",isEnabled: true,),
                ProfileSwitch(title: "Female"),
                ProfileSwitch(title: "Public Profile",isEnabled: true,),
                CardHeader(title: "About Me",fontSize: 17.sp,fontWeight: FontWeight.w500,),
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
          const Text(
            'Actions',
            style: TextStyle(
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