import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/patient_widgets/search_widgets/summary_item.dart';

class AppointmentSummaryCard extends StatelessWidget {
  final String appointmentType;
  final String date;
  final String time;
  final double consultationFee;
  final double totalFee;

  const AppointmentSummaryCard({
    super.key,
    required this.appointmentType,
    required this.date,
    required this.time,
    required this.consultationFee,
    required this.totalFee,
  });

  @override
  Widget build(BuildContext context) {
    final primaryBlue = AppColors.primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Appointment Type
        SummaryItem(
          label: AppStrings.appointmentType.tr,
          value: appointmentType,
          valueColor: Colors.grey,
        ),

        Divider(color: Colors.grey.shade300, height: 1),

        // 2. Date
        SummaryItem(
          label: AppStrings.dateLabel.tr,
          value: _formatDate(date),
          valueColor: Colors.grey,
        ),

        Divider(color: Colors.grey.shade300, height: 1),

        // 3. Time
        SummaryItem(
          label: AppStrings.timeLabel.tr,
          value: _formatTime(time),
          valueColor: Colors.grey,
        ),

        const SizedBox(height: 10),
        Divider(color: Colors.grey.shade300, height: 10, thickness: 1.5),
        const SizedBox(height: 10),

        // 4. Consultation Fee
        SummaryItem(
          label: AppStrings.consultationFee.tr,
          value: '\$${consultationFee.toStringAsFixed(2)}',
          valueColor: primaryBlue,
          valueWeight: FontWeight.w600,
          subtitle: AppStrings.consultationDurationNote.tr,
        ),

        Divider(color: Colors.grey.shade300, height: 1),

        // 5. Total Fee
        SummaryItem(
          label: AppStrings.totalFee.tr,
          value: '\$${totalFee.toStringAsFixed(2)}',
          valueColor: primaryBlue,
          valueWeight: FontWeight.bold,
          isTotal: true,
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final monthNames = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${monthNames[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return dateString; // Return original if parsing fails
    }
  }

  String _formatTime(String time) {
    try {
      if (time.contains(':')) {
        final parts = time.split(':');
        final hour = int.parse(parts[0]);
        final minute = parts[1];
        final period = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour % 12 == 0 ? 12 : hour % 12;
        return '$displayHour:$minute $period';
      }
      return time;
    } catch (e) {
      return time;
    }
  }
}