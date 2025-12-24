import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/models/patient_model.dart';
import 'package:patient_app/utils/app_strings.dart';

import '../../../utils/app_colors.dart';

class PatientCardWidget extends StatelessWidget {
  final PatientModel patientModel;
  final VoidCallback onScheduleTap;
  final VoidCallback onAddNoteTap;
  final VoidCallback onFollowUpTap;

  const PatientCardWidget({
    required this.patientModel,
    required this.onScheduleTap,
    required this.onAddNoteTap,
    required this.onFollowUpTap,
    super.key,
  });

  Widget _buildActionButton(String text, Color color, Color textColor, VoidCallback onTap, {bool isOutlined = false}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 50.h, // Adjusted height for better touch target
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isOutlined ? AppColors.lightGrey.withOpacity(0.1) : color,
            borderRadius: BorderRadius.circular(12.r),
            border: isOutlined
                ? Border.all(color: AppColors.lightGrey.withOpacity(0.3), width: 1.w)
                : null,
          ),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFollowUpChip() {
    return InkWell(
      onTap: onFollowUpTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          AppStrings.followUp.tr,
          style: TextStyle(
            color: Colors.white,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {


    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.2))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 13.sp, color: AppColors.primaryColor),
                  8.horizontalSpace,
                  Text(
                    'Last appointment: ${patientModel.lastAppointmentDate}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.darkGrey,
                    ),
                  ),
                ],
              ),
              _buildFollowUpChip(),
            ],
          ),

          Divider(height: 24.h, color: AppColors.lightGrey.withOpacity(0.3)),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Patient Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.asset(
                  patientModel.patientImageUrl,
                  width: 80.w,
                  height: 80.w,
                  fit: BoxFit.cover,
                ),
              ),
              15.horizontalSpace,
              // Details Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patientModel.patientName,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGrey,
                    ),
                  ),
                  8.verticalSpace,
                  // Consultation Type
                  Row(
                    children: [
                      Icon(Icons.call_outlined, size: 16.sp, color: AppColors.primaryColor),
                      4.horizontalSpace,
                      Text(
                        patientModel.consultationType,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.lightGrey,
                        ),
                      ),
                    ],
                  ),
                  4.verticalSpace,
                  // Period (This Week)
                  Row(
                    children: [
                      Text(
                        AppStrings.period.tr,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.darkGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      4.horizontalSpace,
                      Text(
                        patientModel.period,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.lightGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Divider(height: 24.h, color: AppColors.lightGrey.withOpacity(0.3)),
          Row(
            children: [
              _buildActionButton(
                AppStrings.schedule.tr,
                AppColors.lightGrey, Colors.black,
                onScheduleTap,
                isOutlined: true,
              ),
              10.horizontalSpace,
              _buildActionButton(
                AppStrings.addNote.tr,
                AppColors.primaryColor,
                Colors.white,
                onAddNoteTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}