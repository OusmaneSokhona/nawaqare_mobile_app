import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/prescription_controller.dart';
import 'package:patient_app/controllers/profile_controller.dart';
import 'package:patient_app/models/medical_history_model.dart';
import 'package:patient_app/models/vaccination_history_model.dart';
import 'package:patient_app/screens/profile_screens/medical_history.dart';
import 'package:patient_app/utils/app_colors.dart';

import '../../models/prscription_model.dart';

class VaccinationCard extends StatelessWidget {
  Function onTap;
  final VaccinationHistoryModel vaccinationHistoryModel;
  VaccinationCard({required this.vaccinationHistoryModel, super.key,required this.onTap});
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
    final bool showRefillButton = vaccinationHistoryModel.status != PrescriptionStatus.completed;
    final Color primaryColor = _getStatusColor(vaccinationHistoryModel.status);

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
              Column(
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
                  Text(
                    vaccinationHistoryModel.lastUpdated,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF666666),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              _buildStatusChip(vaccinationHistoryModel.status),
            ],
          ),
          Divider(),
          Text(
            "Last Updated ${vaccinationHistoryModel.lastUpdated}",
            style: TextStyle(
              fontSize: 14.sp,
              color:  AppColors.darkGrey,
            ),
          ),
        ],
      ),
    );
  }
}