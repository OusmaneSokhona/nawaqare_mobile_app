import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/models/consultation_model.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';

class ConsultationCard extends StatelessWidget {
  final ConsultationModel plan;
  final Function onTap;
  final bool isCompleted;

  const ConsultationCard({
    super.key,
    required this.plan,
    required this.onTap,
    required this.isCompleted,
  });

  Color getStatusColor() {
    // Checking against raw string keys or model status
    if (plan.status == "Active") return AppColors.primaryColor;
    if (plan.status == "Expire Soon" || plan.status == "Expired") return AppColors.red;
    if (plan.status == "Pending") return AppColors.orange;
    if (plan.status == "Completed") return AppColors.green;
    return Colors.grey;
  }

  String getLocalizedStatus(String status) {
    switch (status) {
      case "Active": return AppStrings.activeStatus.tr;
      case "Expire Soon": return AppStrings.expireSoonStatus.tr;
      case "Expired": return AppStrings.expiredStatus.tr;
      case "Pending": return AppStrings.pendingStatus.tr;
      case "Completed": return AppStrings.completedStatus.tr;
      default: return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        '${plan.expirationDate.day} ${getLocalizedMonth(plan.expirationDate.month)} ${plan.expirationDate.year}';

    return Padding(
      padding: EdgeInsets.only(bottom: 15.sp),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.sp),
            border: Border.all(color: AppColors.lightGrey.withOpacity(0.2))),
        padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 20.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  plan.name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: getStatusColor(),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    getLocalizedStatus(plan.status),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              icon: Icons.call,
              text: plan.consultationType,
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              icon: Icons.calendar_today,
              text: '${AppStrings.expiresOn.tr} $formattedDate',
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              icon: Icons.monetization_on,
              text: '\$${plan.cost.toStringAsFixed(0)}',
            ),
            const SizedBox(height: 8),
            Text(
              '${plan.creditsUsed} ${AppStrings.outOf.tr} ${plan.totalCredits} ${AppStrings.credits.tr}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const Divider(height: 30, thickness: 1),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => onTap(),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  isCompleted ? AppStrings.viewDetail.tr : AppStrings.renewPlan.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({required IconData icon, required String text}) {
    return Row(
      children: <Widget>[
        Icon(icon, color: AppColors.primaryColor, size: 20),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  String getLocalizedMonth(int month) {
    // You can also use intl package here, but for consistency with your code:
    final List<String> months = [
      'jan'.tr, 'feb'.tr, 'mar'.tr, 'apr'.tr, 'may'.tr, 'jun'.tr,
      'jul'.tr, 'aug'.tr, 'sep'.tr, 'oct'.tr, 'nov'.tr, 'dec'.tr
    ];
    return months[month - 1];
  }
}