import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/widgets/custom_button.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';

class TemplateDetailsScreen extends StatelessWidget {
  const TemplateDetailsScreen({super.key});

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
                    "Template Detail",
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
                      _buildPrescriptionHeader(
                        'Hypertension Basic Set',
                        'Amoxicillin 500mg capsule',
                      ),

                      SizedBox(height: 5.h),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Dosage",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 19.sp,
                            fontFamily: AppFonts.jakartaBold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      _buildDosageCard('1 capsule every 8 hours'),

                      SizedBox(height: 5.h),

                      _buildDetailsSection(
                        form: 'Tablet',
                        route: 'Oral',
                        quantity: '15 Tblets',
                        refill: '12 June',
                        category: 'Cardiology',
                      ),
                      7.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Special Instructions",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 19.sp,
                            fontFamily: AppFonts.jakartaBold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Hypertension follow-up. Blood pressure stable, continue medication",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                      30.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: "Apply Template",
                        onTap: () {},
                      ),
                      10.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: "Cancel",
                        onTap: () {},
                        bgColor: AppColors.inACtiveButtonColor,
                        fontColor: Colors.black,
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

  Widget _buildPrescriptionHeader(String title, String medication) {
    return Container(
      width: 1.sw,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            medication,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildDosageCard(String dosageInstruction) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(
            dosageInstruction,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection({
    required String form,
    required String route,
    required String quantity,
    required String refill,
    required String category,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Foam', form),
        _buildDetailRow('Route of Administration', route),
        _buildDetailRow('Quantity to Dispense', quantity),
        _buildDetailRow('Refill', refill),
        _buildDetailRow('Category', category),
      ],
    );
  }
}
