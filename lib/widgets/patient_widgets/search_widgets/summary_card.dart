import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/patient_widgets/search_widgets/summary_item.dart';

class AppointmentSummaryCard extends StatelessWidget {
  const AppointmentSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryBlue = AppColors.primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Appointment Type
        SummaryItem(
          label: AppStrings.appointmentType.tr,
          value: AppStrings.followUp.tr,
          valueColor: Colors.grey,
        ),

        Divider(color: Colors.grey.shade300, height: 1),

        // 2. Date
        SummaryItem(
          label: AppStrings.dateLabel.tr,
          value: 'Oct 9, 2025', // Typically this would come from a controller
          valueColor: Colors.grey,
        ),

        Divider(color: Colors.grey.shade300, height: 1),

        // 3. Time
        SummaryItem(
          label: AppStrings.timeLabel.tr,
          value: '3:00 PM', // Typically this would come from a controller
          valueColor: Colors.grey,
        ),

        const SizedBox(height: 10),
        Divider(color: Colors.grey.shade300, height: 10, thickness: 1.5),
        const SizedBox(height: 10),

        // 4. Consultation Fee
        SummaryItem(
          label: AppStrings.consultationFee.tr,
          value: '\$156',
          valueColor: primaryBlue,
          valueWeight: FontWeight.w600,
          subtitle: AppStrings.consultationDurationNote.tr,
        ),

        Divider(color: Colors.grey.shade300, height: 1),

        // 5. Total Fee
        SummaryItem(
          label: AppStrings.totalFee.tr,
          value: '\$158',
          valueColor: primaryBlue,
          valueWeight: FontWeight.bold,
          isTotal: true,
        ),
      ],
    );
  }
}