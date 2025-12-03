import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/patient_controller.dart';
import 'package:patient_app/widgets/doctor_widgets/patient_widgets/medical_record_widgets.dart';
import 'package:patient_app/widgets/doctor_widgets/patient_widgets/notes_widget.dart';
import 'package:patient_app/widgets/doctor_widgets/patient_widgets/patient_detail_card.dart';
import 'package:patient_app/widgets/doctor_widgets/patient_widgets/report_widget.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/patient_widgets/search_widgets/rating_widget.dart';

class PatientDetailScreen extends StatelessWidget {
  PatientDetailScreen({super.key});

  PatientController patientController = Get.find();

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
                    "Patient Details",
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
                      20.verticalSpace,
                      PatientDetailCard(),
                      10.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RatingWidget(
                            icon: Icons.person_outline_outlined,
                            iconCircleColor: AppColors.primaryColor,
                            metricText: "12",
                            labelText: "Total Consultations",
                            width: 100,
                          ),
                          RatingWidget(
                            icon: Icons.ac_unit,
                            iconCircleColor: AppColors.green,
                            metricText: "10+",
                            labelText: "Last Prescriptions",
                            width: 100,
                          ),
                          RatingWidget(
                            icon: Icons.chat,
                            iconCircleColor: AppColors.orange,
                            metricText: "12/sep/2023",
                            labelText: "Next Follow-up",
                            width: 100,
                          ),
                        ],
                      ),
                      10.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(
                            ()=> InkWell(
                              onTap: (){
                                patientController.selectedCategory.value="Overview";
                              },
                              child: Column(
                                children: [
                                  Text(
                                    "Overview",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color:patientController.selectedCategory.value=="Overview"?AppColors.primaryColor:AppColors.lightGrey,
                                    ),
                                  ),
                                  3.verticalSpace,
                                  Container(
                                    height: 3.h,
                                    width: 75.w,
                                    decoration: BoxDecoration(
                                      color: patientController.selectedCategory.value=="Overview"?AppColors.primaryColor:Colors.transparent,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Obx(
                            ()=> InkWell(
                              onTap: (){
                                patientController.selectedCategory.value="Reports";
                              },
                              child: Column(
                                children: [
                                  Text(
                                    "Reports",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color:patientController.selectedCategory.value=="Reports"?AppColors.primaryColor:AppColors.lightGrey,
                                    ),
                                  ),
                                  3.verticalSpace,
                                  Container(
                                    height: 3.h,
                                    width: 75.w,
                                    decoration: BoxDecoration(
                                      color: patientController.selectedCategory.value=="Reports"?AppColors.primaryColor:Colors.transparent,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Obx(
                            ()=> InkWell(
                              onTap: (){
                                patientController.selectedCategory.value="Notes";
                              },
                              child: Column(
                                children: [
                                  Text(
                                    "Notes",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color:patientController.selectedCategory.value=="Notes"?AppColors.primaryColor:AppColors.lightGrey,
                                    ),
                                  ),
                                  3.verticalSpace,
                                  Container(
                                    height: 3.h,
                                    width: 75.w,
                                    decoration: BoxDecoration(
                                      color: patientController.selectedCategory.value=="Notes"?AppColors.primaryColor:Colors.transparent,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      10.verticalSpace,
                      Obx(
                          ()=> patientController.selectedCategory.value=="Overview"?
                        MedicalRecordWidgets():patientController.selectedCategory.value=="Reports"?ReportWidget():NotesWidget(),
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
