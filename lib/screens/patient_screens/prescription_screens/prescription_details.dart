import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/prscription_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../../widgets/custom_button.dart';
import 'order_summary.dart';

class PrescriptionDetails extends StatelessWidget {
  final PrescriptionModel prescriptionModel;

  PrescriptionDetails({super.key, required this.prescriptionModel});

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

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return 'N/A';
    try {
      DateTime date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString.split('T')[0];
    }
  }

  int _calculateDaysLeft(String validUntil) {
    try {
      DateTime validDate = DateTime.parse(validUntil);
      DateTime now = DateTime.now();
      return validDate.difference(now).inDays;
    } catch (e) {
      return 0;
    }
  }

  Widget _buildMedicationCard(Map<String, dynamic> medication) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            medication['name'] ?? 'Medication',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          4.verticalSpace,
          Row(
            children: [
              Icon(Icons.medication, size: 14.sp, color: AppColors.primaryColor),
              4.horizontalSpace,
              Text(
                '${medication['dosage'] ?? ''} - ${medication['frequency'] ?? ''}',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          4.verticalSpace,
          Text(
            'Duration: ${medication['duration'] ?? ''}',
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String validUntil = prescriptionModel.dateInfo.replaceAll('Valid until ', '');
    int daysLeft = _calculateDaysLeft(validUntil);
    String issueDate = prescriptionModel.appointmentData?['date'] != null
        ? _formatDate(prescriptionModel.appointmentData!['date'])
        : 'N/A';

    String clinicName = prescriptionModel.appointmentData?['consultationType'] == 'homevisit'
        ? 'Home Visit'
        : 'Elite Ortho Clinic, USA';

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
                    AppStrings.prescriptionDetails.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 21.sp,
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
                        child: Row(
                          children: [
                            Image.asset(
                              prescriptionModel.doctorImageUrl,
                              height: 60.h,
                              width: 60.w,
                              fit: BoxFit.cover,
                            ),
                            10.horizontalSpace,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    prescriptionModel.doctorName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.sp,
                                      fontFamily: AppFonts.jakartaBold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  4.verticalSpace,
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        size: 14.sp,
                                        color: AppColors.primaryColor,
                                      ),
                                      4.horizontalSpace,
                                      Expanded(
                                        child: Text(
                                          clinicName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11.sp,
                                            fontFamily: AppFonts.jakartaBold,
                                            color: AppColors.lightGrey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  4.verticalSpace,
                                  Text(
                                    prescriptionModel.specialization,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11.sp,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            5.horizontalSpace,
                            _buildStatusChip(prescriptionModel.status),
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
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 33.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.dateOfIssue.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              AppStrings.validUntil.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      5.verticalSpace,
                      Padding(
                        padding: EdgeInsets.only(right: 33.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              issueDate,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                color: AppColors.lightGrey,
                              ),
                            ),
                            Text(
                              validUntil,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                color: AppColors.lightGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      5.verticalSpace,
                      if (daysLeft > 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.eligibleTill.tr,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            5.horizontalSpace,
                            Text(
                              daysLeft <= 30
                                  ? 'Next $daysLeft days'
                                  : '${(daysLeft / 30).ceil()} months',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: AppColors.lightGrey,
                              ),
                            ),
                          ],
                        ),
                      15.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.diagnosisHistory.tr,
                          style: TextStyle(
                            fontFamily: AppFonts.jakartaBold,
                            fontSize: 18.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Card(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.diagnosis.tr,
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              4.verticalSpace,
                              Text(
                                prescriptionModel.diagnosis ?? 'No diagnosis provided',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black87,
                                ),
                              ),
                              if (prescriptionModel.appointmentData?['soap'] != null) ...[
                                16.verticalSpace,
                                if (prescriptionModel.appointmentData!['soap']['assessment'] != null)
                                  _buildSoapSection(
                                      'Assessment',
                                      prescriptionModel.appointmentData!['soap']['assessment']
                                  ),
                                if (prescriptionModel.appointmentData!['soap']['plan'] != null)
                                  _buildSoapSection(
                                      'Plan',
                                      prescriptionModel.appointmentData!['soap']['plan']
                                  ),
                              ],
                              16.verticalSpace,
                              Text(
                                AppStrings.notes.tr,
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              8.verticalSpace,
                              Text(
                                prescriptionModel.notes ?? 'No additional notes',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.prescriptionHistory.tr,
                          style: TextStyle(
                            fontFamily: AppFonts.jakartaBold,
                            fontSize: 18.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Card(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppStrings.prescriptions.tr,
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '#${prescriptionModel.prescriptionNumber ?? 'N/A'}',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              if (prescriptionModel.medications != null && prescriptionModel.medications!.isNotEmpty)
                                ...prescriptionModel.medications!.map((med) => _buildMedicationCard(med))
                              else
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20.sp),
                                    child: Text(
                                      'No medications listed',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.lock,
                                    size: 18,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      AppStrings.encryptionNote.tr,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.electronicSign.tr,
                          style: TextStyle(
                            fontFamily: AppFonts.jakartaBold,
                            fontSize: 18.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Dr. ${prescriptionModel.doctorName.replaceAll('Dr. ', '')}',
                          style: GoogleFonts.dancingScript(
                            textStyle: const TextStyle(
                              fontSize: 40,
                              fontStyle: FontStyle.italic,
                              color: Colors.black87,
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
                              '${AppStrings.note.tr}: ',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                AppStrings.digitalSignNote.tr,
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      30.verticalSpace,
                      if (prescriptionModel.status != PrescriptionStatus.expired &&
                          prescriptionModel.status != PrescriptionStatus.completed)
                        CustomButton(
                          borderRadius: 15,
                          text: AppStrings.getMedicine.tr,
                          onTap: () {
                            Get.to(() => OrderSummaryScreen());
                          },
                        ),
                      if (prescriptionModel.status != PrescriptionStatus.expired &&
                          prescriptionModel.status != PrescriptionStatus.completed)
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
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSoapSection(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          2.verticalSpace,
          Text(
            content,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}