import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/quick_statics_controller.dart';
import 'package:patient_app/main.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';

class QuickStatisticsCard extends StatelessWidget {
   QuickStatisticsCard({super.key});
QuickStatisticsController quickStatisticsController = Get.put(QuickStatisticsController());
  static const Color primaryIconColor = Color(0xFF4285F4);

  Widget _buildStatItem(String icon, String label) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageIcon(
            AssetImage(icon),
            size: isWeb?10.sp:26.sp,
            color: primaryIconColor,
          ),
          const SizedBox(height: 8.0),
          Text(
            label,
            textAlign: TextAlign.center,
            style:  TextStyle(
              fontSize: isWeb?5.sp:13.sp,
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
    quickStatisticsController.fetchQuickStats();
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
      child: Obx(
        ()=> Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              "assets/images/consultation_plan_icon.png",
              '${AppStrings.today.tr} : ${quickStatisticsController.formattedDay}',
            ),
            _buildStatItem(
              "assets/images/chat_icon.png",
              '${AppStrings.messages.tr} : ${quickStatisticsController.messagesCount}',
            ),
            _buildStatItem(
              "assets/images/star_icon.png",
              '${AppStrings.rating.tr} : ${quickStatisticsController.ratingDisplay}',
            ),
          ],
        ),
      ),
    );
  }
}