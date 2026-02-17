import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_appoinment_controller.dart';
import 'package:patient_app/screens/doctor_screens/appointment_screens/add_report_screen.dart';
import 'package:patient_app/screens/doctor_screens/appointment_screens/edit_notes_screen.dart';
import 'package:patient_app/screens/document_view_screen.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/widgets/doctor_widgets/appointment_widgets/delete_report_dialog.dart';
import '../../../models/doctor_appointment_model.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_strings.dart';

class DoctorPastAppoinmentWidget extends StatelessWidget {
  final DoctorAppointment appointmentModel;
  DoctorPastAppoinmentWidget({super.key,required this.appointmentModel});

  DoctorAppointmentController doctorAppointmentController =
  Get.find<DoctorAppointmentController>();

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        15.verticalSpace,
        Align(
          alignment: AlignmentDirectional.topStart,
          child: Text(
            AppStrings.symptomsHistory.tr,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              fontFamily: AppFonts.jakartaBold,
            ),
          ),
        ),
        10.verticalSpace,
        Container(
          width: 1.sw,
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.lightGrey.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.patientSymptoms.tr,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.jakartaBold,
                ),
              ),
              10.verticalSpace,
              Text(
                appointmentModel.notes ?? AppStrings.symptomsPlaceholder.tr,
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              ),
            ],
          ),
        ),
        10.verticalSpace,
        Align(
          alignment: AlignmentDirectional.topStart,
          child: Text(
            AppStrings.coveredByPlan.tr,
            style: TextStyle(
              color: Colors.black,
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              fontFamily: AppFonts.jakartaBold,
            ),
          ),
        ),
        10.verticalSpace,
        Container(
          width: 1.sw,
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.lightGrey.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${AppStrings.plan.tr}: Silver 4-Consultation Plan",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.jakartaBold,
                ),
              ),
              10.verticalSpace,
              Text(
                "${AppStrings.remainingCredits.tr}: 2 consultations",
                style: TextStyle(color: AppColors.darkGrey, fontSize: 14.sp),
              ),
              10.verticalSpace,
              Text(
                "${AppStrings.expires.tr}: 14 Feb 2026",
                style: TextStyle(color: AppColors.lightGrey, fontSize: 14.sp),
              ),
              10.verticalSpace,
              Text(
                "${AppStrings.planStatus.tr}: \"OK\"",
                style: TextStyle(color: AppColors.lightGrey, fontSize: 14.sp),
              ),
            ],
          ),
        ),
        15.verticalSpace,
        CardHeader(title: AppStrings.clinicalSummary.tr),
        10.verticalSpace,
        Container(
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.lightGrey.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(15.sp),
          ),
          child: Column(
            children: [
              Obx(
                    () => DiagnosisHistoryCard(
                  diagnosis: appointmentModel.prescriptionId?.diagnosis ?? "No diagnosis",
                  icd: "ICD-10",
                  notes: doctorAppointmentController.notesText.value.isEmpty
                      ? (appointmentModel.prescriptionId?.notes ?? "No notes available")
                      : doctorAppointmentController.notesText.value,
                ),
              ),
              15.verticalSpace,
              if (appointmentModel.prescriptionId != null)
                ...appointmentModel.prescriptionId!.medications.map((medication) =>
                    PrescriptionHistoryCard(
                      medication: medication.name,
                      dosage: "${medication.dosage} - ${medication.frequency} - ${medication.duration}",
                      daysRemaining: _calculateDaysRemaining(appointmentModel.prescriptionId!.validUntil),
                      prescriptionNumber: appointmentModel.prescriptionId!.prescriptionNumber,
                      issueDate: appointmentModel.prescriptionId!.issueDate,
                      validUntil: appointmentModel.prescriptionId!.validUntil,
                    ),
                ).toList()
              else
                const PrescriptionHistoryCard(
                  medication: "No prescription available",
                  dosage: "",
                  daysRemaining: 0,
                  prescriptionNumber: "",
                ),
            ],
          ),
        ),
        15.verticalSpace,
          MedicalReportCard(
            title: appointmentModel.patientId.reports!,

            onlyView: false,
          ),
        15.verticalSpace,
        FollowUpRecommendationCard(
          recommendation: AppStrings.chooseOptionFutureAction.tr,
          options: [
            AppStrings.scheduleFollowUp.tr,
            AppStrings.closeConsultation.tr,
            AppStrings.referPatient.tr,
          ],
        ),
        15.verticalSpace,
        ReviewCard(
          image: "assets/demo_images/Frame 1000000981.png",
          reviewerName: "Emily Anderson",
          rating: 5,
          reviewText:
          "Dr. Patel is a true professional who genuinely cares about his patients. I highly recommend Dr. Patel to anyone seeking exceptional cardiac care.",
        ),
        15.verticalSpace,
        40.verticalSpace,
      ],
    );
  }

  int _calculateDaysRemaining(DateTime validUntil) {
    final now = DateTime.now();
    final difference = validUntil.difference(now).inDays;
    return difference > 0 ? difference : 0;
  }
}

class CardHeader extends StatelessWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;

  const CardHeader({
    required this.title,
    super.key,
    this.fontSize = 18,
    this.fontWeight = FontWeight.w700,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: fontSize.sp,
          fontWeight: fontWeight,
          fontFamily: AppFonts.jakartaBold,
        ),
      ),
    );
  }
}

class DiagnosisHistoryCard extends StatelessWidget {
  final String notes;
  final String diagnosis;
  final String icd;

  const DiagnosisHistoryCard({
    required this.notes,
    required this.diagnosis,
    required this.icd,
    super.key,
  });

  static const Color _primaryColor = Color(0xFF1F2937);
  static const Color _secondaryColor = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.lightGrey.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.diagnosis.tr,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: AppFonts.jakartaBold,
                      color: _primaryColor,
                    ),
                  ),
                  const Icon(
                    Icons.description,
                    size: 16,
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    diagnosis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.lightGrey,
                    ),
                  ),
                  Text(
                    'ID: ($icd)',
                    style: TextStyle(fontSize: 14.sp, color: _secondaryColor),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.diagnosisNotes.tr,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: _primaryColor,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(EditNotesScreen());
                    },
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              Text(
                notes,
                style: TextStyle(fontSize: 14.sp, color: _secondaryColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PrescriptionHistoryCard extends StatelessWidget {
  final String medication;
  final String dosage;
  final int daysRemaining;
  final String? prescriptionNumber;
  final DateTime? issueDate;
  final DateTime? validUntil;

  const PrescriptionHistoryCard({
    required this.medication,
    required this.dosage,
    required this.daysRemaining,
    this.prescriptionNumber,
    this.issueDate,
    this.validUntil,
    super.key,
  });

  static const Color _primaryColor = Color(0xFF1F2937);
  static const Color _secondaryColor = Color(0xFF6B7280);
  static const Color _blueColor = AppColors.primaryColor;
  static const Color _buttonBgColor = Color(0xFFE5E7EB);

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.prescriptions.tr,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: AppFonts.jakartaBold,
                  fontSize: 16.sp,
                ),
              ),
              if (prescriptionNumber != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _blueColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    prescriptionNumber!,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: _blueColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    5.verticalSpace,
                    Text(
                      medication,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: _primaryColor,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      dosage,
                      style: TextStyle(fontSize: 14.sp, color: _secondaryColor),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.description, size: 16, color: _secondaryColor),
            ],
          ),
          if (issueDate != null && validUntil != null) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 12.sp, color: _secondaryColor),
                SizedBox(width: 4.w),
                Text(
                  "Issued: ${_formatDate(issueDate)}",
                  style: TextStyle(fontSize: 11.sp, color: _secondaryColor),
                ),
                SizedBox(width: 12.w),
                Icon(Icons.event_available, size: 12.sp, color: _secondaryColor),
                SizedBox(width: 4.w),
                Text(
                  "Valid until: ${_formatDate(validUntil)}",
                  style: TextStyle(fontSize: 11.sp, color: _secondaryColor),
                ),
              ],
            ),
          ],
          SizedBox(height: 8.h),
          Row(
            children: [
              const Icon(Icons.lock, color: _secondaryColor, size: 16),
              SizedBox(width: 4.w),
              Text(
                AppStrings.encryptedCompliant.tr,
                style: TextStyle(fontSize: 12.sp, color: _secondaryColor),
              ),
            ],
          ),
          if (daysRemaining > 0) ...[
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: daysRemaining > 5 ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                "$daysRemaining days remaining",
                style: TextStyle(
                  fontSize: 11.sp,
                  color: daysRemaining > 5 ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          SizedBox(height: 16.h),
          if (prescriptionNumber!.isNotEmpty) Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _buttonBgColor,
                    foregroundColor: _primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  child: Text(
                    AppStrings.downloadPdf.tr,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _blueColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  child: Text(
                    AppStrings.refill.tr,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MedicalReportCard extends StatelessWidget {
  final List<String> title;
  final bool onlyView;

  const MedicalReportCard({
    required this.title,
    super.key,
    required this.onlyView,
  });

  static const Color _primaryColor = Color(0xFF1F2937);
  static const Color _secondaryColor = Color(0xFF6B7280);
  static const Color _blueColor = Color(0xFF4C86F7);
  static const Color _iconBgColor = Color(0xFFE0EFFF);

  @override
  Widget build(BuildContext context) {
    return (title.isNotEmpty&&title!=null)?Column(
      children: [
        CardHeader(title: AppStrings.medicalReports.tr),
        5.verticalSpace,
        SizedBox(height: title.length<2?onlyView?100.h:200.h:200.h,child: ListView.builder(padding: EdgeInsets.zero,itemCount: title.length,itemBuilder: (context,index){
          return Container(
            padding: EdgeInsets.all(onlyView?0.sp:10.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: onlyView?Colors.transparent:AppColors.lightGrey.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: AppColors.lightGrey.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.circular(13.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _iconBgColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Icon(
                          Icons.description_outlined,
                          color: _blueColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title[index],
                              maxLines: 3,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onlyView
                          ? InkWell(

                        onTap: (){
                          Get.to(DocumentViewerScreen(documentUrl: title[index], fileName: title[index]));
                        },
                            child: Container(
                                                    padding: EdgeInsets.symmetric(
                            horizontal: 12.sp,
                            vertical: 4.sp,
                                                    ),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(9.sp),
                                                    ),
                                                    child: Text(
                            AppStrings.view.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontFamily: AppFonts.jakartaMedium,
                              fontWeight: FontWeight.w500,
                            ),
                                                    ),
                                                  ),
                          )
                          : InkWell(
                        onTap: () {
                          Get.dialog(DeleteReportDialog());
                        },
                        child: Icon(
                          Icons.delete_outline,
                          color: AppColors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                onlyView?0.verticalSpace:12.verticalSpace,
                onlyView?SizedBox():Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(AddReportScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.inACtiveButtonColor,
                          foregroundColor: _primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                        child: Text(
                          AppStrings.addReport.tr,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                        child: Text(
                          AppStrings.downloadReport.tr,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),),

      ],
    ):SizedBox();
  }
}

class FollowUpRecommendationCard extends StatelessWidget {
  final String recommendation;
  final List<String> options;

  const FollowUpRecommendationCard({
    required this.recommendation,
    required this.options,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CardHeader(title: AppStrings.nextStep.tr),
        10.verticalSpace,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recommendation,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.lightGrey,
              ),
            ),
            10.verticalSpace,
            ...options.map(
                  (option) => Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: Checkbox(
                        activeColor: AppColors.primaryColor,
                        value: false,
                        onChanged: (bool? newValue) {},
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      option,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.lightGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String reviewerName;
  final double rating;
  final String reviewText;
  final String image;

  const ReviewCard({
    required this.reviewerName,
    required this.rating,
    required this.reviewText,
    required this.image,
    super.key,
  });

  static const Color _primaryColor = Color(0xFF1F2937);
  static const Color _starColor = Color(0xFFF59E0B);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeader(title: AppStrings.review.tr),
          10.verticalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundImage: AssetImage(image),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.patientReviewConsultation.tr,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          reviewerName,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: _primaryColor,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Text(
                              rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: _starColor,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            ...List.generate(5, (index) {
                              return Icon(
                                index < rating.floor()
                                    ? Icons.star
                                    : Icons.star_border,
                                color: _starColor,
                                size: 18.sp,
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                reviewText,
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 1.4,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}