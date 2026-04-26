import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patient_app/models/doctor_prescription_model.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_button.dart';

class DoctorPrescriptionDetailScreen extends StatelessWidget {
  final DoctorPrescriptionModel prescriptionModel;

  DoctorPrescriptionDetailScreen({super.key, required this.prescriptionModel});

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
        return AppStrings.activeStatus.tr;
      case PrescriptionStatus.expirySoon:
        return AppStrings.expirySoonStatus.tr;
      case PrescriptionStatus.expired:
        return AppStrings.expiredStatus.tr;
      case PrescriptionStatus.completed:
        return AppStrings.completedStatus.tr;
    }
  }

  Widget _buildStatusChip(PrescriptionStatus status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getConsultationTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'homevisit':
        return '🏠';
      case 'remote':
        return '📹';
      case 'inperson':
        return '🏥';
      default:
        return '💊';
    }
  }

  String _getPatientName() {
    if (prescriptionModel.patientName != null && prescriptionModel.patientName!.isNotEmpty) {
      return prescriptionModel.patientName!;
    }
    return prescriptionModel.patientInfo?.fullName ?? 'Unknown Patient';
  }

  String _getProfileImage() {
    return prescriptionModel.patientInfo?.profileImage ?? '';
  }

  String _getValidUntilText() {
    if (prescriptionModel.validUntil != null) {
      return _formatDate(prescriptionModel.validUntil!);
    }
    return 'No expiry date';
  }

  String _getVisitAddress() {
    return prescriptionModel.appointmentInfo?.visitAddress ?? '';
  }

  String _getConsultationType() {
    return prescriptionModel.appointmentInfo?.consultationType ?? 'Not specified';
  }

  String _getAppointmentDate() {
    if (prescriptionModel.appointmentInfo?.date != null) {
      return _formatDate(prescriptionModel.appointmentInfo!.date!);
    }
    return 'Date not specified';
  }

  String _getRefillDate(MedicationInfo medication) {
    if (medication.refillDate != null) {
      return _formatDate(medication.refillDate!);
    }
    return 'Not specified';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.onboardingBackground, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              70.verticalSpace,
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Image.asset(
                      AppImages.backIcon,
                      height: 33.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    AppStrings.prescriptionDetail.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              20.verticalSpace,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: 1.sw,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(12.sp),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30.r,
                                  backgroundImage: _getProfileImage().isNotEmpty
                                      ? NetworkImage(_getProfileImage())
                                      : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                                  onBackgroundImageError: (_, __) {},
                                ),
                                10.horizontalSpace,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _getPatientName(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18.sp,
                                          fontFamily: AppFonts.jakartaBold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      5.verticalSpace,
                                      Row(
                                        children: [
                                          Text(
                                            _getConsultationTypeIcon(_getConsultationType()),
                                            style: TextStyle(fontSize: 14.sp),
                                          ),
                                          5.horizontalSpace,
                                          Expanded(
                                            child: Text(
                                              "${_getConsultationType()} • ${_getAppointmentDate()}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12.sp,
                                                fontFamily: AppFonts.jakartaMedium,
                                                color: AppColors.lightGrey,
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
                                _buildStatusChip(prescriptionModel.status),
                              ],
                            ),
                            if (_getVisitAddress().isNotEmpty) ...[
                              8.verticalSpace,
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 16.sp,
                                    color: AppColors.primaryColor,
                                  ),
                                  5.horizontalSpace,
                                  Expanded(
                                    child: Text(
                                      _getVisitAddress(),
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      20.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.prescriptionInfo.tr,
                          style: TextStyle(
                            fontFamily: AppFonts.jakartaBold,
                            fontSize: 18.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.prescriptionIdLabel.tr,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                5.verticalSpace,
                                Text(
                                  prescriptionModel.prescriptionNumber,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.sp,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.dateOfIssue.tr,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                5.verticalSpace,
                                Text(
                                  _formatDate(prescriptionModel.issueDate),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.sp,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.validUntil.tr,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                5.verticalSpace,
                                Text(
                                  _getValidUntilText(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.sp,
                                    color: prescriptionModel.status == PrescriptionStatus.expired
                                        ? AppColors.red
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      15.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.diagnosis.tr,
                          style: TextStyle(
                            fontFamily: AppFonts.jakartaBold,
                            fontSize: 18.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      Container(
                        width: 1.sw,
                        padding: EdgeInsets.all(16.sp),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.lightGrey.withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          prescriptionModel.diagnosis.isNotEmpty
                              ? prescriptionModel.diagnosis
                              : 'No diagnosis provided',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      15.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.notes.tr,
                          style: TextStyle(
                            fontFamily: AppFonts.jakartaBold,
                            fontSize: 18.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      Card(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  prescriptionModel.notes.isNotEmpty
                                      ? prescriptionModel.notes
                                      : 'No additional notes',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              Image.asset(
                                "assets/images/edit_icon.png",
                                height: 20.h,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                      ),
                      15.verticalSpace,
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${AppStrings.prescriptionDoctor.tr}s",
                              style: TextStyle(
                                fontFamily: AppFonts.jakartaBold,
                                fontSize: 18.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Image.asset(
                            "assets/images/chat_icon.png",
                            height: 25.sp,
                            color: AppColors.primaryColor,
                          ),
                        ],
                      ),
                      10.verticalSpace,
                      ...prescriptionModel.medications.map((medication) => Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.grey[200]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    medication.name,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                if (medication.duration.isNotEmpty && medication.duration != 'Not specified')
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Text(
                                      medication.duration,
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            8.verticalSpace,
                            if (medication.dosage.isNotEmpty || medication.frequency.isNotEmpty)
                              Row(
                                children: [
                                  Text(
                                    "${AppStrings.dosageInstruction.tr}: ",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${medication.dosage.isNotEmpty ? medication.dosage : ''}${medication.dosage.isNotEmpty && medication.frequency.isNotEmpty ? ', ' : ''}${medication.frequency.isNotEmpty ? medication.frequency : ''}',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            4.verticalSpace,
                            if (medication.instructions.isNotEmpty && medication.instructions != 'As directed')
                              Padding(
                                padding: EdgeInsets.only(top: 4.h),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      size: 14.sp,
                                      color: AppColors.primaryColor,
                                    ),
                                    4.horizontalSpace,
                                    Expanded(
                                      child: Text(
                                        medication.instructions,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey[600],
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            8.verticalSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 14.sp,
                                      color: AppColors.orange,
                                    ),
                                    4.horizontalSpace,
                                    Text(
                                      'Refill: ${_getRefillDate(medication)}',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                if (medication.specialInstruction.isNotEmpty)
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: AppColors.orange.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Text(
                                      'Special',
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: AppColors.orange,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      )),
                      15.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.electronicSign.tr,
                          style: TextStyle(
                            fontFamily: AppFonts.jakartaBold,
                            fontSize: 19.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Dr. Sarah',
                          style: GoogleFonts.notoSans(
                            textStyle: TextStyle(
                              fontSize: 27.sp,
                              color: Colors.black54,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.digitalNoteLabel.tr,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            8.horizontalSpace,
                            Expanded(
                              child: Text(
                                AppStrings.digitalNoteSub.tr,
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      30.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.sendToPatient.tr,
                        onTap: () {},
                      ),
                      15.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.downloadPdf.tr,
                        onTap: () {},
                        bgColor: AppColors.inACtiveButtonColor,
                        fontColor: Colors.black,
                      ),
                      40.verticalSpace,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}