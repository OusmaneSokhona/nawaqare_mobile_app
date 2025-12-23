import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../../utils/app_fonts.dart';

class NextActionsRow extends StatelessWidget {
  const NextActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            AppStrings.nextActions.tr,
            style: TextStyle(
              fontSize: 18.sp,
              fontFamily: AppFonts.jakartaMedium,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
        5.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: UploadPrescriptionCard()),
              SizedBox(width: 16),
              Expanded(child: PrescriptionDetailCard()),
            ],
          ),
        ),
      ],
    );
  }
}

class UploadPrescriptionCard extends StatelessWidget {
  const UploadPrescriptionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xFFE0EFFF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.description_outlined,
                color: Color(0xFF4C86F7),
                size: 28,
              ),
            ),
            SizedBox(height: 12),
            Text(
              AppStrings.uploadPrescription.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrescriptionDetailCard extends StatelessWidget {
  const PrescriptionDetailCard({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1F2937);
    const Color secondaryColor = Color(0xFF6B7280);

    return Container(
      padding: EdgeInsets.all(14.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.prescription.tr,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          5.verticalSpace,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.radio_button_checked,
                  color: AppColors.primaryColor, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amoxicillin 500mg',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${AppStrings.dosage.tr}: ${AppStrings.morningEvening.tr}',
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.refresh, color: AppColors.primaryColor, size: 18),
              const SizedBox(width: 8),
              Text(
                AppStrings.refill.tr,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 18.sp),
            child: Text(
              'Date: 12 ${AppStrings.june.tr}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: secondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}