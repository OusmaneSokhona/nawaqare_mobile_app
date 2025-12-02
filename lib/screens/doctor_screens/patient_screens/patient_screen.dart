import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/patient_controller.dart';
import 'package:patient_app/models/patient_model.dart';
import 'package:patient_app/screens/doctor_screens/patient_screens/patient_detail_screen.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import 'package:patient_app/widgets/doctor_widgets/patient_widgets/patient_filter_bottom_sheet.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/doctor_widgets/patient_widgets/patient_card_widget.dart';

class PatientScreen extends StatelessWidget {
   PatientScreen({super.key});
   PatientController patientController = Get.put(PatientController());
   List<PatientModel> samplePatients = [
    PatientModel(
      patientName: 'Mr. Alex Martin',
      patientImageUrl: 'assets/demo_images/patient_1.png', // Placeholder image path
      lastAppointmentDate: 'Sunday, 12 June',
      consultationType: 'Remote Consultation',
      period: 'This Week',
    ),
    PatientModel(
      patientName: 'Ms. Sarah Johnson',
      patientImageUrl: 'assets/demo_images/patient_2.png', // Placeholder image path
      lastAppointmentDate: 'Monday, 13 June',
      consultationType: 'In-Person Consultation',
      period: 'This Month',
    ),
    PatientModel(
      patientName: 'Mr. David Lee',
      patientImageUrl: 'assets/demo_images/patient_3.png', // Placeholder image path
      lastAppointmentDate: 'Wednesday, 15 June',
      consultationType: 'Remote Consultation',
      period: 'This Week',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.onboardingBackground, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              70.verticalSpace,
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Image.asset(
                      AppImages.backIcon,
                      height: 33.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    "All Patients",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      10.verticalSpace,
                      Text(
                        "Manage patient profiles, medical history access.",
                        style: TextStyle(
                          color: AppColors.lightGrey,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppFonts.jakartaRegular,
                        ),
                      ),
                      20.verticalSpace,
                      CustomTextField(
                        prefixIcon: Icons.search,
                        hintText: "Search by patient name,Id...",
                        prefixIconColor: AppColors.darkGrey,
                        suffixIcon: Icons.filter_list,
                        suffixIconColor: AppColors.darkGrey,
                        onSuffixIconTap: (){
                          Get.bottomSheet(backgroundColor: Colors.white,PatientFilterBottomSheet(initialStatus: "acitve", onApply: (){}, onReset: (){}));
                        },
                      ),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Most Recent Appointment",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 19.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ListView.builder(padding: EdgeInsets.zero,itemBuilder: (context,index){
                        return PatientCardWidget(patientModel: samplePatients[index],onAddNoteTap: (){},onFollowUpTap: (){},onScheduleTap: (){
                          Get.to(PatientDetailScreen());
                        },);
                      },itemCount: samplePatients.length,shrinkWrap: true,physics: const NeverScrollableScrollPhysics(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
