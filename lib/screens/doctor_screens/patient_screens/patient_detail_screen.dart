import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/patient_controller.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import 'package:patient_app/widgets/doctor_widgets/patient_widgets/patient_detail_card.dart';
import 'package:patient_app/widgets/doctor_widgets/patient_widgets/patient_filter_bottom_sheet.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/doctor_widgets/patient_widgets/patient_card_widget.dart';
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
