import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/models/pharmacy_prescription_model.dart';
import 'package:patient_app/widgets/custom_button.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_strings.dart';

class PharmacyPrescriptionCard extends StatelessWidget {
  final PharmacyPrescriptionModel prescription;
  final VoidCallback onTap;

  const PharmacyPrescriptionCard({
    required this.prescription,
    required this.onTap,
    super.key,
  });

  // Helper to map backend status to localized display and color
  Color getStatusColor(String status) {
    if (status == AppStrings.statusApproved.tr) return AppColors.primaryColor;
    if (status == AppStrings.statusPending.tr) return AppColors.orange;
    if (status == AppStrings.statusReadyToShip.tr) return AppColors.secondryColor;
    if (status == AppStrings.statusDelivered.tr) return AppColors.green;
    return AppColors.lightGrey;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(15.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${AppStrings.prescriptionId.tr} ${prescription.id}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppFonts.jakartaBold,
                ),
              ),
              Text(
                prescription.date,
                style: TextStyle(
                  color: AppColors.darkGrey,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppFonts.jakartaMedium,
                ),
              ),
            ],
          ),
          5.verticalSpace,
          Text(
            "${AppStrings.patientId.tr}: ${prescription.patientId}",
            style: TextStyle(
              color: AppColors.darkGrey,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.jakartaMedium,
            ),
          ),
          5.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                prescription.doctorName,
                style: TextStyle(
                  color: AppColors.darkGrey,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppFonts.jakartaMedium,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: getStatusColor(prescription.status),
                  borderRadius: BorderRadius.circular(8.sp),
                ),
                child: Text(
                  prescription.status,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.jakartaBold,
                  ),
                ),
              ),
            ],
          ),
          10.verticalSpace, // Added a bit more breathing room
          Row(
            children: [
              if (prescription.hasQr) ...[
                _buildTag(AppStrings.tagQr.tr, Colors.blue.shade100, Colors.blue),
                10.horizontalSpace,
              ],
              if (prescription.hasDoc) ...[
                _buildTag(AppStrings.tagDoc.tr, AppColors.orange.withOpacity(0.2), AppColors.orange),
                10.horizontalSpace,
              ],
            ],
          ),
          10.verticalSpace,
          Divider(color: AppColors.lightGrey.withOpacity(0.3)),
          5.verticalSpace,
          CustomButton(
            borderRadius: 15,
            text: AppStrings.viewDetail.tr,
            onTap: onTap,
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color backgroundColor, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6.sp),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          fontFamily: AppFonts.jakartaBold,
        ),
      ),
    );
  }
}