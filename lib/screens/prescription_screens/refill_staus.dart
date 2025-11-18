import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/prescription_controller.dart';
import 'package:patient_app/screens/prescription_screens/order_summary.dart';
import 'package:patient_app/widgets/custom_button.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_images.dart';
import '../../widgets/prescription_widgets/refill_indicator.dart';

class RefillStaus extends StatelessWidget {
  RefillStaus({super.key});

  PrescriptionController prescriptionController = Get.find();

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
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    "Refill Status",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              20.verticalSpace,
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Prescriptions',
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Amoxicillin 500mg',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '1 tablet, twice daily after meals',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.darkGrey,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Dr. Camille Dupont',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.lightGrey,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        height: 30.h,
                        width: 80.w,padding: EdgeInsets.all(5.r),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: AppColors.green,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Approved",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp
                          ),
                        ),
                      ),
                    ),
                    10.horizontalSpace,
                  ],
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Note',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Text(
                prescriptionController.noteController.text.isNotEmpty
                    ? prescriptionController.noteController.text
                    : "No notes Available",
                style: TextStyle(color: AppColors.lightGrey,fontSize: 15.sp,fontWeight: FontWeight.w500,),
              ),
              60.verticalSpace,
              CustomButton(
                borderRadius: 15,
                text: "Order Medicine",
                onTap: () {
                  Get.to(OrderSummaryScreen());
                },
              ),
              20.verticalSpace,
              CustomButton(
                borderRadius: 15,
                text: "Cancel",
                onTap: () {
                  Get.back();
                },
                bgColor: AppColors.inACtiveButtonColor,
                fontColor: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
