import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/models/medical_history_model.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';

import '../../../models/prscription_model.dart';

class CurrentMedicineCard extends StatelessWidget {
  final Function onTap;
  final MedicalHistoryModel medicalHistoryModel;

  CurrentMedicineCard({required this.medicalHistoryModel, super.key, required this.onTap});

  Color _getStatusColor(String status) {
    if (status == "Active") return AppColors.primaryColor;
    if (status == "In Progress") return AppColors.orange;
    if (status == "Expired") return AppColors.red;
    if (status == "Completed") return AppColors.green;
    return Colors.grey;
  }

  String _getLocalizedStatus(String status) {
    switch (status) {
      case "Active":
        return AppStrings.active.tr;
      case "In Progress":
        return AppStrings.inProgress.tr;
      case "Expired":
        return AppStrings.expired.tr;
      case "Completed":
        return AppStrings.completed.tr;
      default:
        return status;
    }
  }

  Widget _buildStatusChip(String status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        _getLocalizedStatus(status),
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(medicalHistoryModel.doctor.image, height: 70.h),
              15.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicalHistoryModel.doctor.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  Text(
                    medicalHistoryModel.doctor.specialty,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF666666),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              _buildStatusChip(medicalHistoryModel.doctor.status),
            ],
          ),
          5.verticalSpace,
          const Divider(),
          5.verticalSpace,
          Text(
            medicalHistoryModel.medicationName,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF333333),
            ),
          ),
          4.verticalSpace,
          Text(
            medicalHistoryModel.dosage,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF666666),
            ),
          ),
          8.verticalSpace,
          if (medicalHistoryModel.refillLimitDate != null)
            Text(
              '${AppStrings.refillsLeft.tr}: ${medicalHistoryModel.refillLimitDate}',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.lightGrey.withOpacity(0.8),
              ),
            ),
          Text(
            medicalHistoryModel.lastUpdated,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.darkGrey,
            ),
          ),
          16.verticalSpace,
        ],
      ),
    );
  }
}