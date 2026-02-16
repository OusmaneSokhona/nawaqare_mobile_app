import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/appointment_controllers/appointment_controller.dart';
import 'package:patient_app/main.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/widgets/custom_button.dart';
import '../../../models/appointment_model.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_strings.dart';

class PastAppointmentWidgets extends StatelessWidget {
  final Appointment appointment;
  final AppointmentController appointmentController = Get.find<AppointmentController>();

  PastAppointmentWidgets({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Column(
        children: [
          if (appointmentController.selectedTab.value == "Diagnosis") ...[
            15.verticalSpace,
            DiagnosisHistoryCard(
              notes: appointment.notes ?? "No diagnosis notes available",
            ),
          ],
          if (appointmentController.selectedTab.value == "Ordonnance") ...[
            15.verticalSpace,
            if (appointment.prescriptionId != null)
              ...appointment.prescriptionId!.medications.map((medication) =>
                  PrescriptionHistoryCard(
                    medication: medication.name,
                    dosage: "${medication.dosage} - ${medication.frequency}",
                    daysRemaining: _calculateDaysRemaining(appointment.prescriptionId!.validUntil),
                  )
              ).toList()
            else
              PrescriptionHistoryCard(
                medication: "No prescription available",
                dosage: "",
                daysRemaining: 0,
              ),
          ],
          if (appointmentController.selectedTab.value == "Medical Report") ...[
            15.verticalSpace,
            MedicalReportCard(
              title: "Medical Report - ${appointment.formattedDate}",
              date: appointment.formattedDate,
            ),
          ],
          15.verticalSpace,
          FollowUpRecommendationCard(
            recommendation: appointment.notes ?? "Schedule a follow-up as recommended by Dr. ${appointment.doctor.fullName}",
          ),
          if (appointmentController.selectedTab.value == "Reviews") ...[
            15.verticalSpace,
            ReviewCard(
              image: appointment.doctor.profileImage ?? "assets/demo_images/Frame 1000000981.png",
              reviewerName: appointment.doctor.fullName,
              rating: 4.5,
              reviewText: "Consultation completed on ${appointment.formattedDate}. ${appointment.notes ?? 'No additional notes.'}",
            ),
          ],
          15.verticalSpace,
          CustomButton(
            borderRadius: 15,
            text: AppStrings.bookAgain.tr,
            onTap: () {
              // Navigate to book again with same doctor
            },
          ),
          15.verticalSpace,
          CustomButton(
            borderRadius: 15,
            text: AppStrings.downloadInvoicePdf.tr,
            onTap: () {
              // Download invoice PDF
            },
            bgColor: AppColors.inACtiveButtonColor,
            fontColor: Colors.black,
          ),
          40.verticalSpace,
        ],
      ),
    );
  }

  int _calculateDaysRemaining(DateTime validUntil) {
    final difference = validUntil.difference(DateTime.now());
    return difference.inDays > 0 ? difference.inDays : 0;
  }
}

class CardHeader extends StatelessWidget {
  final String title;

  const CardHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: isWeb ? 6.sp : 17.sp,
          fontWeight: FontWeight.w700,
          fontFamily: AppFonts.jakartaBold,
        ),
      ),
    );
  }
}

class DiagnosisHistoryCard extends StatelessWidget {
  final String notes;

  const DiagnosisHistoryCard({required this.notes, super.key});

  static const Color _primaryColor = Color(0xFF1F2937);
  static const Color _secondaryColor = Color(0xFF6B7280);
  static const Color _buttonBgColor = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardHeader(title: AppStrings.diagnosisHistory.tr),
        5.verticalSpace,
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.diagnosisNotesLabel.tr,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                notes,
                style: TextStyle(fontSize: 13.sp, color: _secondaryColor),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
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
                    AppStrings.downloadConsultationReport.tr,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
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

  const PrescriptionHistoryCard({
    required this.medication,
    required this.dosage,
    required this.daysRemaining,
    super.key,
  });

  static const Color _primaryColor = Color(0xFF1F2937);
  static const Color _secondaryColor = Color(0xFF6B7280);
  static const Color _blueColor = Color(0xFF4C86F7);
  static const Color _buttonBgColor = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardHeader(title: AppStrings.prescriptionHistory.tr),
        5.verticalSpace,
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.prescriptionsLabel.tr,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: _primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          medication,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: _primaryColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        if (dosage.isNotEmpty)
                          Text(
                            dosage,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: _secondaryColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (daysRemaining > 0)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.notifications_none,
                          color: AppColors.primaryColor,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$daysRemaining ${AppStrings.daysRemainingLabel.tr}',
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.lightGrey,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.lock,
                    color: AppColors.primaryColor,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    AppStrings.gdprComplianceNote.tr,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.lightGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
             dosage.isNotEmpty?Row(
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
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
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
                        AppStrings.requestDelivery.tr,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ):SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}

class MedicalReportCard extends StatelessWidget {
  final String title;
  final String date;

  const MedicalReportCard({required this.title, required this.date, super.key});

  static const Color _primaryColor = Color(0xFF1F2937);
  static const Color _secondaryColor = Color(0xFF6B7280);
  static const Color _blueColor = Color(0xFF4C86F7);
  static const Color _iconBgColor = Color(0xFFE0EFFF);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardHeader(title: AppStrings.medicalReports.tr),
        5.verticalSpace,
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.lightGrey.withOpacity(0.2)),
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
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _primaryColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 14,
                        color: _secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: _blueColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  elevation: 0,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  AppStrings.view.tr,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FollowUpRecommendationCard extends StatelessWidget {
  final String recommendation;

  const FollowUpRecommendationCard({required this.recommendation, super.key});

  static const Color _primaryColor = Color(0xFF1F2937);
  static const Color _blueColor = Color(0xFF4C86F7);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardHeader(title: AppStrings.followUpRecommendation.tr),
        5.verticalSpace,
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  recommendation,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  // Navigate to book follow-up
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _blueColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  elevation: 0,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  AppStrings.followUpBtn.tr,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
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
  static const Color _starColor = AppColors.orange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeader(title: AppStrings.review.tr),
          5.verticalSpace,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: image.startsWith('assets')
                    ? AssetImage(image) as ImageProvider
                    : NetworkImage(image),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reviewerName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 4),
                        ...List.generate(5, (index) {
                          return Icon(
                            index < rating.floor()
                                ? Icons.star
                                : Icons.star_border,
                            color: _starColor,
                            size: 18,
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            reviewText,
            style: const TextStyle(
              fontSize: 16,
              height: 1.4,
              color: _primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}