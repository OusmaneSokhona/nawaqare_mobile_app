import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/main.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';

import '../../../controllers/doctor_controllers/recent_activity_controller.dart';

class RecentActivityCard extends StatelessWidget {
   RecentActivityCard({super.key});
   final RecentActivityController controller = Get.put(RecentActivityController());
  static const Color primaryIconColor = Color(0xFF4285F4);
  static const Color primaryTextColor = AppColors.darkGrey;
  static const Color timeTextColor = Color(0xFF9E9E9E);
  static const double iconSize = 19.0;

  String _getActivityIcon(String activity) {
    if (activity.toLowerCase().contains('reschedule')) {
      return "assets/images/call_icon.png";
    } else if (activity.toLowerCase().contains('booked')) {
      return "assets/images/consultation_plan_icon.png";
    } else if (activity.toLowerCase().contains('prescription')) {
      return "assets/images/sent_to_pharmacy_icon.png";
    } else if (activity.toLowerCase().contains('payment')) {
      return "assets/images/payment_confirmed_icon.png";
    } else {
      return "assets/images/chat_icon.png";
    }
  }



  Widget _buildLogItem(String icon, String description,) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ImageIcon(
            AssetImage(icon),
            size: iconSize,
            color: primaryIconColor,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontSize: isWeb ? 6.sp : 12.sp,
                color: primaryTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Container(
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Container(
            width: 50,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
controller.fetchRecentActivity();
    return Obx(() => Container(
      width: 1.sw,
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.3), width: 1),
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: controller.isLoading.value
            ? [
          _buildShimmerItem(),
          _buildShimmerItem(),
          _buildShimmerItem(),
        ]
            : controller.hasError.value
            ? [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red[400],
                  size: 40,
                ),
                const SizedBox(height: 8),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isWeb ? 6.sp : 13.sp,
                    color: Colors.red[400],
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => controller.refreshActivity(),
                  child: const Text('Retry',style: TextStyle(color: AppColors.primaryColor)),
                ),
              ],
            ),
          ),
        ]
            : controller.activities.isEmpty
            ? [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                Text(
                  'No recent activities',
                  style: TextStyle(
                    fontSize: isWeb ? 6.sp : 13.sp,
                    color: timeTextColor,
                  ),
                ),
                TextButton(
                  onPressed: () => controller.refreshActivity(),
                  child: const Text('Retry',style: TextStyle(color: AppColors.primaryColor)),
                ),
              ],
            ),
          ),
        ]
            : controller.activities.map((activity) {
          return _buildLogItem(
            _getActivityIcon(activity),
            activity,
          );
        }).toList(),
      ),
    ));
  }
}