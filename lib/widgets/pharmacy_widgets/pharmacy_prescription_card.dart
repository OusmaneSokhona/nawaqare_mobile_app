import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient_app/models/pharmacy_prescription_model.dart';
import 'package:patient_app/widgets/custom_button.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';

class PharmacyPrescriptionCard extends StatelessWidget {
  final PharmacyPrescriptionModel prescription;
  final VoidCallback onTap;

  PharmacyPrescriptionCard({
    required this.prescription,
    required this.onTap,
    super.key,
  });

  Color getStatusColor(String status) {
    switch (status) {
      case "Approved":
        return AppColors.primaryColor;
      case "Pending":
        return AppColors.orange;
      case "Ready to Ship":
        return AppColors.secondryColor;
      case "Delivered":
        return AppColors.green;
      default:
        return AppColors.lightGrey;
    }
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
            offset: Offset(0, 3),
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
                "Prescription ID ${prescription.id}",
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
            "Patient id:${prescription.patientId}",
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
          Row(
            children: [
              if (prescription.hasQr) ...[
                _buildTag("QR", Colors.blue.shade100, Colors.blue),
                10.horizontalSpace,
              ],
              if (prescription.hasDoc) ...[
                _buildTag("Doc", AppColors.orange.withOpacity(0.2), AppColors.orange),
                10.horizontalSpace,
              ],

            ],
          ),
        5.verticalSpace,
        Divider(color: AppColors.lightGrey.withOpacity(0.3),),
        5.verticalSpace,
        CustomButton(borderRadius: 15, text: "View Detail", onTap: onTap),
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