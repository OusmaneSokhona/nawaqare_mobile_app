import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_strings.dart';

import '../../../models/appointment_model.dart';
import '../../../utils/app_colors.dart';

class DoctorAppoinmentDetailWidget extends StatelessWidget {
  final AppointmentModel appointmentModel;

  const DoctorAppoinmentDetailWidget({Key? key, required this.appointmentModel})
      : super(key: key);

  Color _getStatusColor(String status) {
    String s = status.toLowerCase();
    if (s.contains("follow") || s.contains("suivi")) return AppColors.primaryColor;
    if (s.contains("renewal") || s.contains("renouvellement")) return Colors.orange;
    if (s.contains("exam") || s.contains("examen")) return Colors.lightBlueAccent;
    if (s.contains("initial")) return Colors.green;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
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
                      size: 16,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(width: 6),
                    Row(
                      children: [
                        Text(
                          "${appointmentModel.date}",
                          style: TextStyle(color: Colors.black54, fontSize: 12.sp),
                        ),
                        8.horizontalSpace,
                        Icon(
                          Icons.watch_later_outlined,
                          size: 16,
                          color: AppColors.primaryColor,
                        ),
                        4.horizontalSpace,
                        Text(
                          "${appointmentModel.time}",
                          style: TextStyle(color: Colors.black54, fontSize: 12.sp),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(appointmentModel.status),
                    borderRadius: BorderRadius.circular(8.sp),
                  ),
                  child: Text(
                    appointmentModel.status.tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Divider(thickness: 0.3, color: Colors.black45),
            const SizedBox(height: 4),
            Row(
              children: [
                Image.asset(
                  appointmentModel.imageUrl,
                  height: 105.h,
                  fit: BoxFit.fill,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointmentModel.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            appointmentModel.consultationType
                                .toLowerCase()
                                .contains("remote")
                                ? Icons.add_ic_call
                                : Icons.meeting_room_outlined,
                            color: Colors.blue,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            appointmentModel.consultationType.tr,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13.sp,
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