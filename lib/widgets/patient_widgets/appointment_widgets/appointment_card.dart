import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/main.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../../models/appointment_model.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final String title;
  final bool showGreenDot;
  final bool showRating;
  final Function? onTap;
  final String buttonText;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.title,
    this.showGreenDot = false,
    this.showRating = false,
    this.onTap,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    // Data Preparation
    final formattedDate = _formatDate(appointment.date);
    final timeRange = '${_formatTime(appointment.timeslot!.startTime)}-${_formatTime(appointment.timeslot!.endTime)}';
    final consultationTypeIcon = _getConsultationTypeIcon(appointment.consultationType);
    final consultationTypeText = appointment.consultationType.displayName;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              fontSize: isWeb ? 6.sp : 18.sp,
              fontFamily: AppFonts.jakartaMedium,
              fontWeight: isWeb ? FontWeight.w600 : FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
        5.verticalSpace,
        InkWell(
          onTap: () => onTap?.call(),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.6), width: 1),
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
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            appointment.doctor.profileImage ?? '',
                            height: isWeb ? 50 : 90,
                            width: isWeb ? 50 : 90,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: isWeb ? 50 : 90,
                              width: isWeb ? 50 : 90,
                              color: Colors.grey[200],
                              child: Icon(Icons.person, color: Colors.grey[400]),
                            ),
                          ),
                        ),
                        if (showGreenDot)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: _getStatusColor(appointment.status),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            appointment.doctor.fullName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            appointment.doctor.email ?? appointment.doctor.email,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => onTap?.call(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        elevation: 0,
                      ),
                      child: Text(
                        buttonText,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 30, color: Color(0xFFE5E7EB)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildDetailItem("assets/images/calender_icon.png", formattedDate),
                    _buildDetailItem("assets/images/clock_icon.png", timeRange),
                    showRating
                        ? _buildDetailItem("assets/images/star_icon.png", '4.5/5')
                        : _buildDetailItem(consultationTypeIcon, consultationTypeText),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ImageIcon(AssetImage(icon), size: 16, color: AppColors.primaryColor),
        const SizedBox(width: 6),
        SizedBox(
          width: 75.w,
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppFonts.jakartaMedium,
              fontSize: isWeb ? 4.sp : 12.sp,
              color: const Color(0xFF4B5563),
            ),
          ),
        ),
      ],
    );
  }

  // --- Helper Methods ---

  String _getConsultationTypeIcon(ConsultationType type) {
    switch (type) {
      case ConsultationType.remote: return "assets/images/call_icon.png";
      case ConsultationType.homevisit: return "assets/images/home_icon.png";
      case ConsultationType.inperson: return "assets/images/in_person_icon.png";
      default: return "assets/images/call_icon.png";
    }
  }

  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending: return Colors.orange;
      case AppointmentStatus.confirmed: return Colors.green;
      case AppointmentStatus.cancelled: return Colors.red;
      default: return Colors.green;
    }
  }


  String _formatDate(DateTime date) {
    final days = [
      AppStrings.sunday.tr, AppStrings.monday.tr, AppStrings.tuesday.tr,
      AppStrings.wednesday.tr, AppStrings.thursday.tr, AppStrings.friday.tr, AppStrings.saturday.tr
    ];
    // Simple fallback if translation keys don't exist for months
    return '${days[date.weekday % 7]}, ${date.day} June';
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final period = time.hour < 12 ? 'AM' : 'PM';
    return '$hour:${time.minute.toString().padLeft(2, '0')} $period';
  }
}