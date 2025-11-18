import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';

class TrackOrderCard extends StatelessWidget {

  const TrackOrderCard({super.key,});

  @override
  Widget build(BuildContext context) {
    const List<String> progressStages = [
      'Order',
      'Preparing',
      'Ready',
      'Pick up',
    ];

    return Container(
      width: 1.sw,
      margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 5.h),
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.sp),
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
        children: [
          Text(
            "Central Pharmacy",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              fontFamily: AppFonts.jakartaBold,
            ),
          ),
          5.verticalSpace,
          Text(
            "12 Health St,75000 Paris",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14.sp,
              fontFamily: AppFonts.jakartaRegular,
            ),
          ),
          20.verticalSpace,

          // 2. Progress Tracker Bar
          _buildProgressBar(context),
          10.verticalSpace,

          // 3. Progress Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: progressStages
                .map(
                  (stage) => Text(
                stage,
                style: TextStyle(
                  color: progressStages.indexOf(stage) <= 2
                      ? AppColors.primaryColor
                      : Colors.grey.shade500,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.jakartaMedium,
                ),
              ),
            )
                .toList(),
          ),
          10.verticalSpace,
          const Divider(color: AppColors.lightGrey, thickness: 1),
          Text(
            'Order Summary',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              fontFamily: AppFonts.jakartaBold,
            ),
          ),
          10.verticalSpace,
          Text(
            "Amoxicillin 500mg",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14.sp,
              fontFamily: AppFonts.jakartaRegular,
            ),
          ),
          5.verticalSpace,
          _buildInfoRow('Order ID: ', '#${12134}'),
          5.verticalSpace,
          _buildInfoRow('Expected By: ',"Sep 30, 2025"),
          10.verticalSpace,
          const Divider(color: AppColors.lightGrey, thickness: 1),
          10.verticalSpace,

          Text(
            'Delivery Address',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              fontFamily: AppFonts.jakartaBold,
            ),
          ),
          3.verticalSpace,
          Text(
            "John Doe, 123 Main Street, Anytown, CA 90210, USA",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14.sp,
              fontFamily: AppFonts.jakartaRegular,
            ),
          ),
          10.verticalSpace,
          const Divider(color: AppColors.lightGrey, thickness: 1),
          Text(
            'Delivery Information',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              fontFamily: AppFonts.jakartaBold,
            ),
          ),
          10.verticalSpace,
          _buildInfoRow('Courier Name: ', 'Adam Asmith'),
          5.verticalSpace,
          _buildInfoRow('Phone Number:', '0356-67-9855'),
          10.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    double totalStages = 4.0;
    double progressValue = (3) / totalStages;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.sp),
      child: LinearProgressIndicator(
        value: progressValue,
        minHeight: 12.h,
        backgroundColor: AppColors.lightGrey.withOpacity(0.3),
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 14.sp,
          fontFamily: AppFonts.jakartaRegular,
        ),
        children: <TextSpan>[
          TextSpan(
            text: label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.darkGrey,
              fontFamily: AppFonts.jakartaMedium,
            ),
          ),
          TextSpan(
            text: value,
          ),
        ],
      ),
    );
  }
}