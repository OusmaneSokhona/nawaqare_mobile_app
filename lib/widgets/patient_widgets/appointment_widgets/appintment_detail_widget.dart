import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/appointment_model.dart';
import '../../../utils/app_colors.dart';

class AppintmentDetailWidget extends StatelessWidget {
  final AppointmentModel appointmentModel;

  AppintmentDetailWidget({Key? key, required this.appointmentModel, })
      : super(key: key);

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "follow up":
        return AppColors.primaryColor;
      case "renewal":
        return Colors.orange;
      case "exam review":
        return Colors.lightBlueAccent;
      case "initial":
        return Colors.green;
      default:
        return Colors.grey;
    }
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
                          style:  TextStyle(color: Colors.black54, fontSize: 12.sp),
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
                          style:  TextStyle(color: Colors.black54, fontSize: 12.sp),
                        ),
                      ],
                    ),
                  ],
                ),
                Icon(Icons.chat, color: AppColors.primaryColor, size: 20.sp),
              ],
            ),

            const SizedBox(height: 4),
            Divider(thickness: 0.3,color: Colors.black45,),
            const SizedBox(height: 4),

            Row(
              children: [
                Image.asset(
                  appointmentModel.imageUrl,height: 105.h,fit: BoxFit.fill,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointmentModel.name,
                        style:  TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                      ),
                      Divider(thickness: 0.3,color: Colors.black45,),
                      Text(
                        appointmentModel.specialty,
                        style:  TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
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
                            appointmentModel.consultationType,
                            style:  TextStyle(
                              color: Colors.black,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.orange, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                "${appointmentModel.rating}",
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                          7.horizontalSpace,
                          Container(height: 15.h,width: 1.w,color: AppColors.primaryColor,),
                          7.horizontalSpace,
                          Row(
                            children: [
                              Text(
                                "Fee:",
                                style:  TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.sp,
                                ),
                              ),
                              Text(
                                "\$${appointmentModel.fee.toStringAsFixed(0)}",
                                style:  TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
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
