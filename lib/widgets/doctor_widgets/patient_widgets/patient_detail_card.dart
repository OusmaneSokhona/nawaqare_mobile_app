import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:patient_app/screens/doctor_screens/patient_screens/add_notes_screen.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../../models/patient_model_doctor.dart';

class PatientDetailCard extends StatelessWidget {
  final PatientSummary patientSummary;
  const PatientDetailCard({super.key, required this.patientSummary});

  @override
  Widget build(BuildContext context) {
    String gender = patientSummary.fullName.contains('Mrs.') ||
        patientSummary.fullName.contains('Ms.') ?
    AppStrings.female.tr : AppStrings.male.tr;

    String patientIdDisplay = patientSummary.patientId.length > 8 ?
    '#${patientSummary.patientId.substring(0, 8)}' :
    '#${patientSummary.patientId}';

    String formattedDateTime = '';
    if (patientSummary.lastAppointmentDate != null) {
      formattedDateTime = DateFormat('EEEE, MMM d - h:mm a').format(patientSummary.lastAppointmentDate!);
    } else {
      formattedDateTime = 'No appointments yet';
    }

    return Container(
      width: 1.sw,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    formattedDateTime,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF5A6674),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF9E4C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  elevation: 0,
                ),
                child: Text(AppStrings.followUp.tr, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const Divider(height: 14, thickness: 1, color: Color(0xFFF1F1F1)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: patientSummary.imageUrl != null && patientSummary.imageUrl!.isNotEmpty
                    ? Image.network(
                  patientSummary.imageUrl!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: const Icon(Icons.person, size: 40, color: Colors.grey),
                    );
                  },
                )
                    : Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Icon(Icons.person, size: 40, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            patientSummary.fullName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Image.asset(
                              "assets/images/chat_icon.png",
                              height: 20.h,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${AppStrings.patientId.tr}: $patientIdDisplay',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${AppStrings.gender.tr}: $gender',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month, size: 14, color: Color(0xFF6B7280)),
                        const SizedBox(width: 4),
                        Text(
                          '${patientSummary.totalAppointments} ${AppStrings.appointments.tr}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.attach_money, size: 14, color: Color(0xFF6B7280)),
                        const SizedBox(width: 2),
                        Text(
                          '${patientSummary.totalSpent.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 20, thickness: 1, color: Color(0xFFF1F1F1)),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE5E7EB),
                    foregroundColor: const Color(0xFF374151),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 0,
                  ),
                  child: Text(AppStrings.schedule.tr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                      Get.to(() => AddNotesScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4285F4),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 0,
                  ),
                  child: Text(AppStrings.addNote.tr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}