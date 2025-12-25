import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/models/vaccination_history_model.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';

import '../../../models/prscription_model.dart';

class VaccinationCard extends StatelessWidget {
  final Function onTap;
  final VaccinationHistoryModel vaccinationHistoryModel;

  const VaccinationCard({
    required this.vaccinationHistoryModel,
    super.key,
    required this.onTap
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case "Active":
        return AppColors.primaryColor;
      case "Pending":
        return AppColors.orange;
      case "Expired":
        return AppColors.red;
      case "Completed":
        return AppColors.green;
      default:
        return Colors.grey;
    }
  }

  String _getLocalizedStatus(String status) {
    switch (status) {
      case "Active":
        return AppStrings.active.tr;
      case "Pending":
        return AppStrings.pending.tr;
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vaccinationHistoryModel.vaccineName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    Text(
                      vaccinationHistoryModel.testName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
              10.horizontalSpace,
              _buildStatusChip(vaccinationHistoryModel.status),
            ],
          ),
          const Divider(),
          Text(
            "${AppStrings.lastUpdatedLabel.tr} ${vaccinationHistoryModel.lastUpdated}",
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.darkGrey,
            ),
          ),
        ],
      ),
    );
  }
}