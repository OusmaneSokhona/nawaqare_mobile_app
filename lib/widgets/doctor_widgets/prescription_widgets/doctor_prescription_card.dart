import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_prescription_controller.dart';
import 'package:patient_app/models/doctor_prescription_model.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';

class DoctorPrescriptionCard extends StatelessWidget {
  final Function onTap;
  final DoctorPrescriptionModel prescription;
  final bool isActive;

  DoctorPrescriptionCard({
    required this.prescription,
    super.key,
    this.isActive = true,
    required this.onTap,
  });

  final DoctorPrescriptionController controller = Get.find();

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

  String _getStatusText(PrescriptionStatus status) {
    switch (status) {
      case PrescriptionStatus.active:
        return AppStrings.active.tr;
      case PrescriptionStatus.expirySoon:
        return AppStrings.expirySoon.tr;
      case PrescriptionStatus.expired:
        return AppStrings.expired.tr;
      case PrescriptionStatus.completed:
        return AppStrings.completed.tr;
    }
  }

  Widget _buildStatusChip(PrescriptionStatus status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        _getStatusText(status),
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionChip(String text, Color color, VoidCallback onTap, Color textColor) {
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getMedicationNames() {
    if (prescription.medications.isEmpty) return 'No medications';
    return prescription.medications.map((med) => med.name).join(', ');
  }

  String _getPatientName() {
    if (prescription.patientName != null && prescription.patientName!.isNotEmpty) {
      return prescription.patientName!;
    }
    return prescription.patientInfo?.fullName ?? 'Unknown Patient';
  }

  String _getProfileImage() {
    return prescription.patientInfo?.profileImage ?? '';
  }

  String _getValidUntilText() {
    if (prescription.validUntil != null) {
      return 'Valid until: ${_formatDate(prescription.validUntil!)}';
    }
    return 'No expiry date';
  }

  String _getFirstMedicationDosage() {
    if (prescription.medications.isNotEmpty) {
      final med = prescription.medications.first;
      if (med.dosage.isNotEmpty && med.frequency.isNotEmpty) {
        return '${med.dosage} - ${med.frequency}';
      } else if (med.dosage.isNotEmpty) {
        return med.dosage;
      } else if (med.frequency.isNotEmpty) {
        return med.frequency;
      }
    }
    return 'As prescribed';
  }

  @override
  Widget build(BuildContext context) {
    final bool showModifyButton = prescription.status != PrescriptionStatus.completed && isActive;

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
                backgroundImage: _getProfileImage().isNotEmpty
                    ? NetworkImage(_getProfileImage())
                    : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                onBackgroundImageError: (_, __) {},
              ),
              15.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getPatientName(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF333333),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.medical_services_outlined,
                          size: 14.sp,
                          color: AppColors.primaryColor,
                        ),
                        5.horizontalSpace,
                        Expanded(
                          child: Text(
                            prescription.diagnosis.isNotEmpty
                                ? prescription.diagnosis
                                : 'No diagnosis',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: const Color(0xFF666666),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
            _getMedicationNames(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF333333),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          4.verticalSpace,
          if (prescription.medications.isNotEmpty)
            Text(
              _getFirstMedicationDosage(),
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF666666),
              ),
            ),
          8.verticalSpace,
          Text(
            _getValidUntilText(),
            style: TextStyle(
              fontSize: 12.sp,
              color: prescription.status == PrescriptionStatus.expired
                  ? AppColors.red
                  : const Color(0xFF999999),
            ),
          ),
          16.verticalSpace,
          Row(
            children: [
              if (showModifyButton)
                _buildActionChip(
                    AppStrings.modify.tr,
                    const Color(0xFFE0E0E0),
                        () {
                      // Handle modify
                    },
                    Colors.black
                ),
              if (showModifyButton) 10.horizontalSpace,
              _buildActionChip(
                  AppStrings.viewDetail.tr,
                  AppColors.primaryColor,
                      () { onTap(); },
                  Colors.white
              ),
            ],
          ),
        ],
      ),
    );
  }
}