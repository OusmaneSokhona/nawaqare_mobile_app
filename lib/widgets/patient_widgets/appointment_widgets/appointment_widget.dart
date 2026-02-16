import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/appointment_controllers/appointment_controller.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/utils/app_fonts.dart';
import '../../../models/appointment_model.dart';
import '../../../utils/app_colors.dart';

class AppointmentWidget extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback onTap;
  final bool isCompleted;

  const AppointmentWidget({
    super.key,
    required this.appointment,
    this.isCompleted = false,
    required this.onTap,
  });

  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return Colors.orange;
      case AppointmentStatus.confirmed:
        return Colors.green;
      case AppointmentStatus.completed:
        return Colors.blue;
      case AppointmentStatus.cancelled:
        return Colors.red;
      case AppointmentStatus.ongoing:
        return Colors.purple;
      case AppointmentStatus.rescheduled:
        return Colors.amber;
    }
  }

  String _getStatusText(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return 'Pending';
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
      case AppointmentStatus.ongoing:
        return 'Ongoing';
      case AppointmentStatus.rescheduled:
        return 'Rescheduled';
    }
  }

  String _getConsultationTypeIcon(ConsultationType type) {
    switch (type) {
      case ConsultationType.homevisit:
        return '🏠';
      case ConsultationType.inperson:
        return '🏥';
      case ConsultationType.remote:
        return '📱';
      case ConsultationType.video:
        return '📹';
    }
  }

  String _getFormattedDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final appointmentDay = DateTime(date.year, date.month, date.day);

    if (appointmentDay == today) {
      return "Today";
    } else if (appointmentDay == today.add(Duration(days: 1))) {
      return "Tomorrow";
    } else {
      final weekdayMap = {
        1: 'Mon',
        2: 'Tue',
        3: 'Wed',
        4: 'Thu',
        5: 'Fri',
        6: 'Sat',
        7: 'Sun',
      };

      final monthMap = {
        1: 'Jan',
        2: 'Feb',
        3: 'Mar',
        4: 'Apr',
        5: 'May',
        6: 'Jun',
        7: 'Jul',
        8: 'Aug',
        9: 'Sep',
        10: 'Oct',
        11: 'Nov',
        12: 'Dec',
      };

      final weekday = weekdayMap[date.weekday] ?? 'Day';
      final month = monthMap[date.month] ?? 'Month';

      return '$weekday, ${date.day} $month';
    }
  }

  String _getFormattedTime(DateTime startTime, DateTime endTime) {
    // Add null checks
    if (startTime == null || endTime == null) {
      return 'Time not available';
    }

    final startHour = startTime.hour % 12 == 0 ? 12 : startTime.hour % 12;
    final startPeriod = startTime.hour < 12 ? 'AM' : 'PM';
    final endHour = endTime.hour % 12 == 0 ? 12 : endTime.hour % 12;
    final endPeriod = endTime.hour < 12 ? 'AM' : 'PM';

    return '$startHour:${startTime.minute.toString().padLeft(2, '0')} $startPeriod - $endHour:${endTime.minute.toString().padLeft(2, '0')} $endPeriod';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppointmentController>();

    return Card(
      color: Colors.white,
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDateTimeInfo(),
                _buildStatusOrRating(),
              ],
            ),
            4.verticalSpace,
            const Divider(thickness: 0.3, color: Colors.black45),
            4.verticalSpace,
            _buildDoctorInfo(),
            12.verticalSpace,
            CustomButton(
              borderRadius: 15,
              text: AppStrings.viewDetail.tr,
              onTap: onTap,
              height: 40.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeInfo() {
    return Row(
      children: [
        const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.primaryColor),
        6.horizontalSpace,
        Text(
          _getFormattedDate(appointment.date),
          style: TextStyle(color: Colors.black54, fontSize: 12.sp),
        ),
        8.horizontalSpace,
        const Icon(Icons.watch_later_outlined, size: 16, color: AppColors.primaryColor),
        4.horizontalSpace,
        Text(
          // Fix: Safely handle null timeslot
          appointment.timeslot != null
              ? _getFormattedTime(appointment.timeslot!.startTime, appointment.timeslot!.endTime)
              : 'Time not specified',
          style: TextStyle(color: Colors.black54, fontSize: 12.sp),
        ),
      ],
    );
  }

  Widget _buildStatusOrRating() {
    if (isCompleted) {
      return Row(
        children: [
          const Icon(Icons.star, color: Colors.orange, size: 16),
          4.horizontalSpace,
          Text("5.0/5", style: TextStyle(fontSize: 13.sp)),
          20.horizontalSpace,
        ],
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _getStatusColor(appointment.status),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        _getStatusText(appointment.status),
        style: TextStyle(
          color: Colors.white,
          fontSize: 9.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDoctorInfo() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: _buildDoctorImage(),
        ),
        12.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appointment.doctor.fullName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                  fontFamily: AppFonts.jakartaBold,
                ),
              ),
              const Divider(thickness: 0.3, color: Colors.black45),
              Text(
                "General Practitioner",
                style: TextStyle(color: Colors.black, fontSize: 15.sp),
              ),
              4.verticalSpace,
              Row(
                children: [
                  Icon(
                    appointment.consultationType == ConsultationType.remote
                        ? Icons.add_ic_call
                        : Icons.meeting_room_outlined,
                    color: Colors.blue,
                    size: 16.sp,
                  ),
                  6.horizontalSpace,
                  Text(
                    appointment.consultationType.displayName,
                    style: TextStyle(color: Colors.black, fontSize: 13.sp),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 16),
                  4.horizontalSpace,
                  Text(
                    "5.0",
                    style: TextStyle(fontSize: 13.sp),
                  ),
                  7.horizontalSpace,
                  Container(height: 15.h, width: 1.w, color: AppColors.primaryColor),
                  7.horizontalSpace,
                  Text(
                    "${AppStrings.fee.tr}: ",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp,
                    ),
                  ),
                  Text(
                    "\$${appointment.fee} ${appointment.currency}",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
              if (appointment.consultationType == ConsultationType.homevisit && appointment.visitAddress != null) ...[
                4.verticalSpace,
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.green, size: 14.sp),
                    4.horizontalSpace,
                    Expanded(
                      child: Text(
                        appointment.visitAddress!,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12.sp,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
                4.verticalSpace,
                Row(
                  children: [
                    Icon(Icons.note, color: Colors.amber, size: 14.sp),
                    4.horizontalSpace,
                    Expanded(
                      child: Text(
                        appointment.notes!,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12.sp,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorImage() {
    if (appointment.doctor.profileImage != null && appointment.doctor.profileImage!.isNotEmpty) {
      return Image.network(
        appointment.doctor.profileImage!,
        height: 105.h,
        width: 85.w,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildFallbackImage(),
      );
    }
    return _buildFallbackImage();
  }

  Widget _buildFallbackImage() {
    return Container(
      height: 105.h,
      width: 85.w,
      color: AppColors.primaryColor.withOpacity(0.1),
      child: Center(
        child: Text(
          _getConsultationTypeIcon(appointment.consultationType),
          style: TextStyle(fontSize: 30.sp),
        ),
      ),
    );
  }
}