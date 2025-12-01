import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_profile_controller.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/widgets/doctor_widgets/appointment_widgets/doctor_past_appoinment_widget.dart';
import 'package:patient_app/widgets/doctor_widgets/profile_widgets/doctor_health_space_grid.dart';
import 'package:patient_app/widgets/doctor_widgets/profile_widgets/profile_completion_loading.dart';
import '../../patient_widgets/profile_widgets/info_row.dart';



class DoctorProfessionalInfo extends StatelessWidget{
  DoctorProfessionalInfo({super.key});
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
              onPressed: (){
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
              child:  Text('Edit Professional Info', style: TextStyle(fontSize: 12.sp)),
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
                CardHeader(title: "Registration & Licensing",fontSize: 17.sp,fontWeight: FontWeight.w500,),
                InfoRow(label: 'National Identity Document', value: "MA-PK-457621",labelTextSize: 15,valueTextSize: 12,),
                const InfoRow(label: 'Date of Registration', value: '15 March 2018'),
                CardHeader(title: "Practice Information",fontSize: 17.sp,fontWeight: FontWeight.w500,),
                InfoRow(label: 'Medical Specialty', value: "Cardiology"),
                InfoRow(label: 'Place of Practice', value: "Allied Hospital, Faisalabad",labelTextSize: 15,valueTextSize: 12,),
                InfoRow(label: 'Experience', value: "7 Year",),
                const InfoRow(label: 'Year', value: '5'),
                InfoRow(label: 'Nationality', value: "Pakistani"),
                InfoRow(label: 'Country', value: "Pakistan"),
                InfoRow(label: 'Language', value: "English",showDivider: false,),
                Text("Note: These details appear on your public profile.", style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.darkGrey,
                ),),

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