import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_prescription_controller.dart';
import 'package:patient_app/utils/app_colors.dart';

import '../../../models/prscription_model.dart';

class DoctorPrescriptionCard extends StatelessWidget {
  Function onTap;
  final PrescriptionModel prescription;
  final bool isActive;
  DoctorPrescriptionCard({required this.prescription, super.key,this.isActive=true,required this.onTap});
  DoctorPrescriptionController controller=Get.find();
  Color _getStatusColor(PrescriptionStatus status) {
    switch (status) {
      case PrescriptionStatus.active:
        return AppColors.primaryColor;
      case PrescriptionStatus.expirySoon:
        return AppColors.orange;
      case PrescriptionStatus.expired:
        return AppColors.red;
      case PrescriptionStatus.completed:
        return AppColors.green;
    }
  }

  Widget _buildStatusChip(PrescriptionStatus status) {
    String text;
    switch (status) {
      case PrescriptionStatus.active:
        text = 'Active';
        break;
      case PrescriptionStatus.expirySoon:
        text = 'Expiry Soon';
        break;
      case PrescriptionStatus.expired:
        text = 'Expired';
        break;
      case PrescriptionStatus.completed:
        text = 'Completed';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionChip(String text, Color color, VoidCallback onTap,Color textColor) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 40.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool showRefillButton = prescription.status != PrescriptionStatus.completed&&isActive;
    final Color primaryColor = _getStatusColor(prescription.status);

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
              CircleAvatar(
                radius: 20.r,
                backgroundImage: AssetImage(prescription.doctorImageUrl),
              ),
              15.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prescription.doctorName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14.sp,
                        color: AppColors.primaryColor,
                      ),
                      5.horizontalSpace,
                      Text(
                        "Elite Ortho Clinic, USA",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              _buildStatusChip(prescription.status),
            ],
          ),
          8.verticalSpace,
          Divider(
            thickness: 1,
            height: 1,
            color: AppColors.lightGrey.withOpacity(0.2),
          ),
          8.verticalSpace,
          Text(
            prescription.medicationName,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF333333),
            ),
          ),
          4.verticalSpace,
          Text(
            prescription.dosageInstruction,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF666666),
            ),
          ),
          8.verticalSpace,
          Text(
            prescription.dateInfo,
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF999999),
            ),
          ),
          16.verticalSpace,
          Row(
            children: [
              if (showRefillButton)
                _buildActionChip(
                    'Modify',
                    const Color(0xFFE0E0E0),
                        () => controller.modify(),Colors.black
                ),
              if (showRefillButton) 10.horizontalSpace,
              _buildActionChip(
                  'View Detail',
                  AppColors.primaryColor,
                      () {onTap();},Colors.white
              ),
            ],
          ),
        ],
      ),
    );
  }
}