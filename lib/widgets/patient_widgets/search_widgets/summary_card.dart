import 'package:flutter/material.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/widgets/patient_widgets/search_widgets/summary_item.dart';

class AppointmentSummaryCard extends StatelessWidget {
  const AppointmentSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the primary color from the image for the price/fee values.
     final primaryBlue = AppColors.primaryColor;

    // Define the style for the regular text labels.
    final labelStyle = TextStyle(color: Colors.grey.shade800, fontSize: 16);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Appointment Type
        const SummaryItem(
          label: 'Appointment Type',
          value: 'Follow-Up',
          valueColor: Colors.grey,
        ),

        // Divider after Appointment Type
        Divider(color: Colors.grey.shade300, height: 1),

        // 2. Date
        const SummaryItem(
          label: 'Date',
          value: 'Oct 9, 2025',
          valueColor: Colors.grey,
        ),

        // Divider after Date
        Divider(color: Colors.grey.shade300, height: 1),

        // 3. Time
        const SummaryItem(
          label: 'Time',
          value: '3:00 PM',
          valueColor: Colors.grey,
        ),
        const SizedBox(height: 10),
        Divider(color: Colors.grey.shade300, height: 10, thickness: 1.5),
        const SizedBox(height: 10),
        SummaryItem(
          label: 'Consultation Fee',
          value: '\$156',
          valueColor: primaryBlue,
          valueWeight: FontWeight.w600,
          subtitle: 'Consultation fee for 1 hour',
        ),
        Divider(color: Colors.grey.shade300, height: 1),
        SummaryItem(
          label: 'Total Fee',
          value: '\$158',
          valueColor: primaryBlue,
          valueWeight: FontWeight.bold,
          isTotal: true, // Use this flag to apply bold/larger font size
        ),
      ],
    );
  }
}