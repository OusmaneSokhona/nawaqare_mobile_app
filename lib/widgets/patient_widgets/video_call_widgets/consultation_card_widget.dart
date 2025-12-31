import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_strings.dart';

import '../../../models/appointment_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';

class ConsultationCardWidget extends StatelessWidget {
  final AppointmentModel appointmentModel;

  const ConsultationCardWidget({super.key, required this.appointmentModel});

  Color _getStatusColor(String status) {
    // It's best to compare against the non-translated raw status from your model
    final s = status.toLowerCase();
    if (s.contains("follow up")) return AppColors.primaryColor;
    if (s.contains("renewal")) return Colors.orange;
    if (s.contains("exam review")) return Colors.lightBlueAccent;
    if (s.contains("initial")) return Colors.green;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
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
                Row(
                  children: [
                     Icon(
                      Icons.calendar_today_outlined,
                      size: 14.sp,
                      color: AppColors.primaryColor,
                    ),
                    6.horizontalSpace,
                    Row(
                      children: [
                        Text(
                          appointmentModel.date,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 11.sp,
                            fontFamily: AppFonts.jakartaMedium,
                          ),
                        ),
                        8.horizontalSpace,
                         Icon(
                          Icons.watch_later_outlined,
                          size: 14.sp,
                          color: AppColors.primaryColor,
                        ),
                        4.horizontalSpace,
                        Text(
                          appointmentModel.time,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 11.sp,
                            fontFamily: AppFonts.jakartaMedium,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                 decoration: BoxDecoration(color: AppColors.primaryColor,borderRadius: BorderRadius.circular(6.sp)),
                 padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 4.h),
                 child: Text("Follow Up",style: TextStyle(fontSize: 11.sp,color: Colors.white),),
                ),
              ],
            ),
            4.verticalSpace,
            const Divider(thickness: 0.3, color: Colors.black45),
            4.verticalSpace,
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.asset(
                    appointmentModel.imageUrl,
                    height: 105.h,
                    width: 90.w, // Added width for consistency
                    fit: BoxFit.cover,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointmentModel.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                          fontFamily: AppFonts.jakartaBold,
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        appointmentModel.specialty,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontFamily: AppFonts.jakartaMedium,
                        ),
                      ),
                      4.verticalSpace,
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