import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../../models/appointment_model.dart';
import '../../../utils/app_colors.dart';

class DoctorWidget extends StatelessWidget {
  final AppointmentModel appointmentModel;
  final Function onTap;
  final bool isCompleted;

  const DoctorWidget({
    Key? key,
    required this.appointmentModel,
    this.isCompleted = false,
    required this.onTap,
  }) : super(key: key);

  String _getLocalizedStatus(String status) {
    switch (status.toLowerCase()) {
      case "follow up":
        return AppStrings.followUpStatus.tr;
      case "renewal":
        return AppStrings.renewalStatus.tr;
      case "exam review":
        return AppStrings.examReviewStatus.tr;
      case "initial":
        return AppStrings.initialStatus.tr;
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Card(
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
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(width: 6),
                      Row(
                        children: [
                          Text(
                            "${appointmentModel.date}",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12.sp,
                            ),
                          ),
                          8.horizontalSpace,
                          const Icon(
                            Icons.watch_later_outlined,
                            size: 16,
                            color: AppColors.primaryColor,
                          ),
                          4.horizontalSpace,
                          Text(
                            "${appointmentModel.time}",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "${AppStrings.feeLabel.tr}: ",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      Text(
                        "\$10",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
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
                        const Divider(thickness: 0.3, color: Colors.black45),
                        Text(
                          appointmentModel.specialty.tr,
                          style: TextStyle(color: Colors.black, fontSize: 15.sp),
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
                        5.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.language,
                                  color: AppColors.primaryColor,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  AppStrings.french.tr,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                            7.horizontalSpace,
                            Container(
                              height: 15.h,
                              width: 1.w,
                              color: AppColors.primaryColor,
                            ),
                            7.horizontalSpace,
                            Row(
                              children: [
                                Text(
                                  AppStrings.islam.tr,
                                  style: TextStyle(
                                    color: AppColors.darkGrey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        3.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.orange,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${appointmentModel.rating}",
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                            7.horizontalSpace,
                            Container(
                              height: 15.h,
                              width: 1.w,
                              color: AppColors.primaryColor,
                            ),
                            7.horizontalSpace,
                            Row(
                              children: [
                                Text(
                                  AppStrings.reviewsCount.trParams({'count': '1,872'}),
                                  style: TextStyle(
                                    color: AppColors.darkGrey,
                                    fontWeight: FontWeight.w500,
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
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}