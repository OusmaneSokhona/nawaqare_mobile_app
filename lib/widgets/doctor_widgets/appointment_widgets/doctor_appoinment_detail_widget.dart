import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:patient_app/models/doctor_appointment_model.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../../utils/app_colors.dart';

class DoctorAppoinmentDetailWidget extends StatelessWidget {
  final DoctorAppointment appointmentModel;

  const DoctorAppoinmentDetailWidget({Key? key, required this.appointmentModel})
      : super(key: key);

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "follow up":
      case "suivi":
        return AppColors.primaryColor;
      case "renewal":
      case "renouvellement":
        return Colors.orange;
      case "exam review":
      case "examen":
        return Colors.lightBlueAccent;
      case "initial":
        return Colors.green;
      case "completed":
      case "terminé":
        return Colors.green;
      case "cancelled":
      case "annulé":
        return Colors.red;
      case "pending":
        return Colors.orange;
      case "confirmed":
        return Colors.blue;
      case "ongoing":
        return AppColors.primaryColor;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final appointmentDay = DateTime(date.year, date.month, date.day);

    if (appointmentDay == today) {
      return "Today";
    } else if (appointmentDay == today.add(Duration(days: 1))) {
      return "Tomorrow";
    } else {
      return DateFormat('EEE, MMM d').format(date);
    }
  }

  String _formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }

  String _getDuration(DateTime startTime, DateTime endTime) {
    final duration = endTime.difference(startTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = _formatDate(appointmentModel.date);
    final formattedTime = _formatTime(appointmentModel.timeslot.startTime);
    final duration = _getDuration(
      appointmentModel.timeslot.startTime,
      appointmentModel.timeslot.endTime,
    );

    return Card(
      color: Colors.white,
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14.h,
                      color: AppColors.primaryColor,
                    ),
                    6.horizontalSpace,
                    Text(
                      formattedDate,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    8.horizontalSpace,
                    Icon(
                      Icons.watch_later_outlined,
                      size: 14.h,
                      color: AppColors.primaryColor,
                    ),
                    4.horizontalSpace,
                    Text(
                      formattedTime,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (duration.isNotEmpty) ...[
                      4.horizontalSpace,
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          duration,
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(appointmentModel.status),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    appointmentModel.status.tr.capitalizeFirst ?? appointmentModel.status,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            8.verticalSpace,
            const Divider(thickness: 0.3, color: Colors.black45),
            8.verticalSpace,
            Row(
              children: [
                Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    image: DecorationImage(
                      image: NetworkImage(appointmentModel.patientId.profileImage),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {
                        // Handle image loading error
                      },
                    ),
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointmentModel.patientId.fullName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      6.verticalSpace,
                      Row(
                        children: [
                          Icon(
                            appointmentModel.consultationType.toLowerCase().contains("video") ||
                                appointmentModel.consultationType.toLowerCase().contains("remote")
                                ? Icons.videocam
                                : Icons.person,
                            color: AppColors.primaryColor,
                            size: 16.h,
                          ),
                          6.horizontalSpace,
                          Text(
                            appointmentModel.consultationType.tr.capitalizeFirst ??
                                appointmentModel.consultationType,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                      4.verticalSpace,
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              '${appointmentModel.fee} ${appointmentModel.currency}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      10.verticalSpace,
                      Text(
                        AppStrings.viewRecord.tr,
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primaryColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}