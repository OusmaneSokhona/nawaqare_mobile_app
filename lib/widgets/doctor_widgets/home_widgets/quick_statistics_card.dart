import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient_app/utils/app_colors.dart';

class QuickStatisticsCard extends StatelessWidget {
  const QuickStatisticsCard({super.key});

  static const Color primaryIconColor = Color(0xFF4285F4);

  Widget _buildStatItem(IconData icon, String label) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 32.0,
            color: primaryIconColor,
          ),
          const SizedBox(height: 8.0),
          Text(
            label,
            textAlign: TextAlign.center,
            style:  TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            Icons.medical_services_outlined,
            'Today : 05',
          ),
          _buildStatItem(
            Icons.chat_outlined,
            'Messages : 02',
          ),
          _buildStatItem(
            Icons.star_border,
            'Rating : 4.3/5',
          ),
        ],
      ),
    );
  }
}