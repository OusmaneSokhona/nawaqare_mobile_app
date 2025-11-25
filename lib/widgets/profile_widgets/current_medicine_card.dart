import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient_app/models/medical_history_model.dart';
import 'package:patient_app/utils/app_colors.dart';

import '../../models/prscription_model.dart';

class CurrentMedicineCard extends StatelessWidget {
  Function onTap;
  final MedicalHistoryModel medicalHistoryModel;
  CurrentMedicineCard({required this.medicalHistoryModel, super.key,required this.onTap});
  Color _getStatusColor(String status) {
    switch (status) {
      case "Active":
        return AppColors.primaryColor;
      case "In Progress":
        return AppColors.orange;
      case "Expired":
        return AppColors.red;
      case "Completed":
        return AppColors.green;
    }
    return Colors.grey;
  }

  Widget _buildStatusChip(String status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status,
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
    final bool showRefillButton = medicalHistoryModel.doctor.status != PrescriptionStatus.completed;
    final Color primaryColor = _getStatusColor(medicalHistoryModel.doctor.status);

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
              Image.asset(medicalHistoryModel.doctor.image,height: 70.h,),
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
          Divider(),
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
              'Refills left: ${medicalHistoryModel.refillLimitDate}',
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
              color:  AppColors.darkGrey,
            ),
          ),
          16.verticalSpace,
        ],
      ),
    );
  }
}