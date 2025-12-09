import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient_app/utils/app_colors.dart';

class RecentActivityCard extends StatelessWidget {
  const RecentActivityCard({super.key});

  static const Color primaryIconColor = Color(0xFF4285F4);
  static const Color primaryTextColor = AppColors.darkGrey;
  static const Color timeTextColor = Color(0xFF9E9E9E);
  static const double iconSize = 19.0;

  Widget _buildLogItem(String icon, String description, String time) {
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
              style:  TextStyle(
                fontSize: 13.sp,
                color: primaryTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontSize: 14.0,
              color: timeTextColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: [
          _buildLogItem(
            "assets/images/call_icon.png",
            'Mr. Alex joined call',
            '09:15 AM',
          ),
          _buildLogItem(
            "assets/images/sent_to_pharmacy_icon.png",
            'Prescription sent to pharmacy',
            '09:15 AM',
          ),
          _buildLogItem(
            "assets/images/payment_confirmed_icon.png",
            'Payment confirmed by patient',
            '09:15 AM',
          ),
        ],
      ),
    );
  }
}