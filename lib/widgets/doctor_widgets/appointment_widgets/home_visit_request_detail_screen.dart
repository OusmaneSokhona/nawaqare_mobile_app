import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_strings.dart';

import '../../../models/doctor_appointment_model.dart';

class HomeVisitRequestDetailScreen extends StatelessWidget {
  final DoctorAppointment appointment;
  HomeVisitRequestDetailScreen({super.key,required this.appointment});

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Not scheduled';
    return DateFormat('EEEE, MMMM d, yyyy - h:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.homeVisitRequestDetail.tr,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        10.verticalSpace,
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(AppStrings.patientName.tr, appointment.patientId.fullName),
              const Divider(height: 32),
              _buildInfoRow(AppStrings.address.tr, appointment.visitAddress ?? "Not available"),
              const Divider(height: 32),
              _buildInfoRow(
                AppStrings.requestedTimeslot.tr,
                appointment.timeslot != null
                    ? _formatDateTime(appointment.timeslot!.startTime)
                    : "Not scheduled",
              ),
              if (appointment.timeslot != null) ...[
                const SizedBox(height: 8),
                _buildInfoRow(
                  "End Time",
                  _formatDateTime(appointment.timeslot!.endTime),
                ),
              ],
              const SizedBox(height: 24),
              Text(
                AppStrings.patientNote.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: AppFonts.jakartaMedium,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                appointment.notes ?? "No notes provided",
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: AppFonts.jakartaMedium,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.jakartaMedium,
            color: Colors.grey,
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontFamily: AppFonts.jakartaMedium,
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}