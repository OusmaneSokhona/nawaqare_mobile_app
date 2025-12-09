import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_appoinment_controller.dart';
import 'package:patient_app/screens/doctor_screens/appointment_screens/add_report_screen.dart';
import 'package:patient_app/screens/doctor_screens/appointment_screens/edit_notes_screen.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/widgets/doctor_widgets/appointment_widgets/delete_report_dialog.dart';
import '../../../utils/app_fonts.dart';

class DoctorPastAppoinmentWidget extends StatelessWidget {
   DoctorPastAppoinmentWidget({super.key});
DoctorAppointmentController doctorAppointmentController=Get.find<DoctorAppointmentController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        15.verticalSpace,
        Align(
          alignment: AlignmentDirectional.topStart,
          child: Text(
            "Symptoms History",
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
                "Patient Symptoms",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.jakartaBold,
                ),
              ),
              10.verticalSpace,
              Text(
                "Patient reports persistent headaches, mild nausea, and dizziness. Symptoms occur mostly in the morning. No prior medication taken@sep/2023",
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              ),
            ],
          ),
        ),
        10.verticalSpace,
        Align(
          alignment: AlignmentDirectional.topStart,
          child: Text(
            "Covered by patient’s prepaid plan",
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
                "Plan: Silver 4-Consultation Plan",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.jakartaBold,
                ),
              ),
              10.verticalSpace,
              Text(
                "Remaining credits:2 consultations",
                style: TextStyle(color: AppColors.darkGrey, fontSize: 14.sp),
              ),
              10.verticalSpace,
              Text(
                "Expires: 14 Feb 2026",
                style: TextStyle(color: AppColors.lightGrey, fontSize: 14.sp),
              ),
              10.verticalSpace,
              Text(
                "Plan_status: \"OK\"",
                style: TextStyle(color: AppColors.lightGrey, fontSize: 14.sp),
              ),
            ],
          ),
        ),
        15.verticalSpace,
        const CardHeader(title: "Clinical Summary"),
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
              ()=> DiagnosisHistoryCard(
                  diagnosis: "Migraine without aura",
                  icd: "ICD-10",
                  notes:doctorAppointmentController.notesText.value,
                               ),
               ),
              15.verticalSpace,
              const PrescriptionHistoryCard(
                medication: "Amoxicillin 500mg",
                dosage: "Morning & Evening – 7 Days",
                daysRemaining: 0,
              ),
            ],
          ),
        ),

        15.verticalSpace,
        const MedicalReportCard(
          title: "Blood Test Report",
          date: "200/Sep/2025",
        ),
        15.verticalSpace,
        const FollowUpRecommendationCard(
          recommendation: "Choose option for future action:",
          options: [
            "Schedule Follow-up",
            "Close Consultation",
            "Refer Patient",
          ],
        ),
        15.verticalSpace,
        const ReviewCard(
          image: "assets/demo_images/Frame 1000000981.png",
          reviewerName: "Emily Anderson",
          rating: 5,
          reviewText:
              "Dr. Patel is a true professional who genuinely cares about his patients. I highly recommend Dr. Patel to anyone seeking exceptional cardiac care.",
        ),
        15.verticalSpace,
        // Removed Custom Buttons for "Book Again" and "Download Invoice pdf" as they are not explicitly shown
        40.verticalSpace,
      ],
    );
  }
}

class CardHeader extends StatelessWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;

  const CardHeader({required this.title, super.key, this.fontSize = 18, this.fontWeight = FontWeight.w700,this.color=Colors.black});

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
              // Diagnosis Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Diagnosis',
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
              // Diagnosis Notes Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Diagnosis Notes',
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

  const PrescriptionHistoryCard({
    required this.medication,
    required this.dosage,
    required this.daysRemaining,
    super.key,
  });

  static const Color _primaryColor = Color(0xFF1F2937);
  static const Color _secondaryColor = Color(0xFF6B7280);
  static const Color _blueColor = AppColors.primaryColor;
  static const Color _buttonBgColor = Color(0xFFE5E7EB);

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
          Text(
            "Prescriptions",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontFamily: AppFonts.jakartaBold,
              fontSize: 16.sp,
            ),
          ),
          // Prescription Details
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
          SizedBox(height: 8.h),
          Row(
            children: [
              const Icon(Icons.lock, color: _secondaryColor, size: 16),
              SizedBox(width: 4.w),
              Text(
                'Encrypted & compliant with GDRP/HDS',
                style: TextStyle(fontSize: 12.sp, color: _secondaryColor),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Buttons
          Row(
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
                    'Download PDF',
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
                    'Refill', // Corrected text to "Refill"
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
        const CardHeader(title: "Medical Reports"),
        5.verticalSpace,
        Container(
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.lightGrey.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: AppColors.lightGrey.withOpacity(0.1),
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
                    InkWell(onTap: (){Get.dialog(DeleteReportDialog());},child: Icon(Icons.delete_outline, color: AppColors.red)),
                  ],
                ),
              ),
              12.verticalSpace,
              Row(
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
                        'Add Report',
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
                        'Download Report', // Corrected text to "Refill"
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
        ),
      ],
    );
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

  static const Color _primaryColor = Color(0xFF1F2937);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CardHeader(title: "Next Step"),
        10.verticalSpace,
        // Removed the Container wrapper here as the image shows the content without a full card background
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
            // Checkbox list
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
                        // Visuals adjusted to match image (simple checkbox)
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
          const CardHeader(title: "Review"),
          10.verticalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    // In a real app, this should handle null image or proper asset loading
                    // For the provided image context, we assume an asset.
                    backgroundImage: AssetImage(image),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Patient review about consultation',
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
