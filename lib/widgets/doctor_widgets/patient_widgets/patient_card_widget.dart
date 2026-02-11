import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/models/patient_model.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:intl/intl.dart';

import '../../../models/patient_model_doctor.dart';

class PatientCardWidget extends StatelessWidget {
  final String patientName;
  final String? patientImageUrl;
  final String email;
  final DateTime? lastAppointmentDate;
  final String? lastConsultationType;
  final int totalAppointments;
  final double totalSpent;
  final String patientId;
  final VoidCallback onScheduleTap;
  final VoidCallback onAddNoteTap;
  final VoidCallback onFollowUpTap;

  const PatientCardWidget({
    Key? key,
    required this.patientName,
    this.patientImageUrl,
    required this.email,
    required this.lastAppointmentDate,
    this.lastConsultationType,
    required this.totalAppointments,
    required this.totalSpent,
    required this.patientId,
    required this.onScheduleTap,
    required this.onAddNoteTap,
    required this.onFollowUpTap,
  }) : super(key: key);

  // Factory constructor from PatientSummary model
  factory PatientCardWidget.fromSummary({
    required PatientSummary patientSummary,
    required VoidCallback onScheduleTap,
    required VoidCallback onAddNoteTap,
    required VoidCallback onFollowUpTap,
  }) {
    return PatientCardWidget(
      patientName: patientSummary.fullName,
      email: patientSummary.email,
      lastAppointmentDate: patientSummary.lastAppointmentDate,
      lastConsultationType: patientSummary.lastConsultationType,
      totalAppointments: patientSummary.totalAppointments,
      totalSpent: patientSummary.totalSpent,
      patientId: patientSummary.patientId,
      onScheduleTap: onScheduleTap,
      onAddNoteTap: onAddNoteTap,
      onFollowUpTap: onFollowUpTap,
    );
  }

  Widget _buildActionButton(String text, Color color, Color textColor, VoidCallback onTap, {bool isOutlined = false}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 50.h,
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

  String _formatDate(DateTime? date) {
    if (date == null) return 'No appointments';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      final format = DateFormat('EEEE, d MMM');
      return format.format(date);
    }
  }

  String _getConsultationTypeText(String? type) {
    if (type == null) return 'N/A';

    switch (type.toLowerCase()) {
      case 'remote':
        return 'Remote Consultation';
      case 'inperson':
        return 'In-Person Consultation';
      case 'homevisit':
        return 'Home Visit';
      case 'video':
        return 'Video Consultation';
      default:
        return type;
    }
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
                    '${AppStrings.lastAppointment.tr}: ${_formatDate(lastAppointmentDate)}',
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
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor.withOpacity(0.1),
                ),
                child: patientImageUrl != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(40.r),
                  child: Image.network(
                    patientImageUrl!,
                    width: 80.w,
                    height: 80.w,
                    fit: BoxFit.cover,
                  ),
                )
                    : Center(
                  child: Icon(
                    Icons.person,
                    size: 30.h,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              15.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patientName,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.lightGrey,
                      ),
                    ),
                    8.verticalSpace,
                    Row(
                      children: [
                        Icon(Icons.medical_services_outlined,
                            size: 16.sp, color: AppColors.primaryColor),
                        4.horizontalSpace,
                        Expanded(
                          child: Text(
                            _getConsultationTypeText(lastConsultationType),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.lightGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    4.verticalSpace,
                    Row(
                      children: [
                        Icon(Icons.event_note_outlined,
                            size: 16.sp, color: AppColors.primaryColor),
                        4.horizontalSpace,
                        Text(
                          '$totalAppointments ${AppStrings.appointments.tr}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.lightGrey,
                          ),
                        ),
                      ],
                    ),
                    4.verticalSpace,
                    Row(
                      children: [
                        Icon(Icons.attach_money_outlined,
                            size: 16.sp, color: AppColors.primaryColor),
                        4.horizontalSpace,
                        Text(
                          '\$$totalSpent',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.lightGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          Divider(height: 24.h, color: AppColors.lightGrey.withOpacity(0.3)),

          Row(
            children: [
              _buildActionButton(
                AppStrings.schedule.tr,
                AppColors.lightGrey,
                Colors.black,
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