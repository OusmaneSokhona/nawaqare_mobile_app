import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/widgets/custom_button.dart';

import '../../../utils/app_fonts.dart';


class PastAppointmentWidgets extends StatelessWidget {
  const PastAppointmentWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        15.verticalSpace,
        const DiagnosisHistoryCard(
            notes:
            "Hypertension follow-up. Blood pressure stable, continue medication"),
        15.verticalSpace,
        const PrescriptionHistoryCard(
            medication: "Amoxicillin 500mg",
            dosage: "Morning & Evening – 7 Days",
            daysRemaining: 5),
        15.verticalSpace,
        const MedicalReportCard(title: "Blood Test Report", date: "200/Sep/2025"),
        15.verticalSpace,
        const FollowUpRecommendationCard(
            recommendation: "Schedule a follow-up in 3 months"),
        15.verticalSpace,
        const ReviewCard(
            image: "assets/demo_images/Frame 1000000981.png",
            reviewerName: "Emily Anderson",
            rating: 4,
            reviewText:
            "Dr. Patel is a true professional who genuinely cares about his patients. I highly recommend Dr. Patel to anyone seeking exceptional cardiac care."),
        15.verticalSpace,
        CustomButton(
            borderRadius: 15,
            text: "Book Again",
            onTap: () {}),
        15.verticalSpace,
        CustomButton(
          borderRadius: 15,
          text: "Download Invoice pdf",
          onTap: () {},
          bgColor: AppColors.inACtiveButtonColor,
          fontColor: Colors.black,
        ),
        40.verticalSpace,
      ],
    );
  }
}

class CardHeader extends StatelessWidget {
  final String title;

  const CardHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: Text(title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            fontFamily: AppFonts.jakartaBold,
          )),
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
        const CardHeader(title: "Diagnosis History"),
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
                'Diagnosis/Notes',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                notes,
                style:  TextStyle(
                  fontSize: 13.sp,
                  color: _secondaryColor,
                ),
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
                  child: const Text('Download Consultation Report',
                      style:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
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
        const CardHeader(title: "Prescription History"),
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
                          'Prescriptions',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: _primaryColor,
                          ),
                        ),
                         SizedBox(height: 4),
                        Text(
                          medication,
                          style:  TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: _primaryColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          dosage,
                          style:  TextStyle(
                            fontSize: 13.sp,
                            color: _secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.notifications_none,
                          color: AppColors.primaryColor, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '$daysRemaining- Days\nRemaining',
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
              const Row(
                children: [
                  Icon(Icons.lock, color: AppColors.primaryColor, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Encrypted & compliant with GDPR/HDS',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.lightGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
                      child: const Text('Download PDF',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
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
                      child: const Text('Request Delivery',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
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

class MedicalReportCard extends StatelessWidget {
  final String title;
  final String date;

  const MedicalReportCard({
    required this.title,
    required this.date,
    super.key,
  });

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
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 0,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('View',
                    style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
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
        const CardHeader(title: " Follow-Up Recommendation"),
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
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: _blueColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  elevation: 0,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Follow Up',
                    style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
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
          const CardHeader(title: "Review"),
          5.verticalSpace,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(image),
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