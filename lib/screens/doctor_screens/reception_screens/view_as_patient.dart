import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/models/appointment_model.dart';
import 'package:patient_app/screens/doctor_screens/reception_screens/services_and_pricing.dart';
import 'package:patient_app/widgets/doctor_widgets/reception_widgets/view_as_patient_card.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';

class ViewAsPatient extends StatelessWidget {
  const ViewAsPatient({super.key});

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
                      "assets/images/back_icon.png",
                      height: 22.h,
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    "View as Patient",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              Text(
                "This Is A Preview Of The Patient’s Booking View",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGrey,
                ),
              ),
              10.verticalSpace,
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return ViewAsPatientCard(
                      appointmentModel: AppointmentModel(
                        name: "Mr. Alex Martin",
                        specialty: "specialty",
                        consultationType: "Remote Consultation",
                        rating: 2,
                        fee: 2,
                        date: "Sunday,12 June",
                        time: "11:00-12:00 AM",
                        status: "status",
                        imageUrl: "assets/demo_images/patient_1.png",
                      ),
                      onTap: () {
                        Get.to(ServicesAndPricing());
                      },
                    );
                  },
                ),
              ),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
