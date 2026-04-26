import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/patient_widgets/profile_widgets/health_space_card.dart';
import 'package:patient_app/widgets/pharmacy_widgets/pharmacy_health_space_grid.dart';
import '../../../controllers/patient_controllers/profile_controller.dart';

class PharmacyRenewalStatus extends StatelessWidget {
  PharmacyRenewalStatus({super.key});
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: ClipOval(
              child: Image.asset(
                "assets/images/pharmacy_icon.png",
                width: 100.w,
                height: 100.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              "Alex Martin Pharmacy",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
          Center(
            child: Text(
              '${AppStrings.lastUpdate.tr}: ${controller.user.value.lastUpdate}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          const SizedBox(height: 10),
          buildRenewalStatusWidget(context),
          Text(
            AppStrings.securitySettings.tr,
            style:  TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 10.h),
          PharmacyHealthSpaceGrid(profileController: controller),
          10.verticalSpace,
          HealthSpaceCard(
            icon: "assets/images/payment_setting_icon.png",
            title: AppStrings.paymentSetting.tr,
            onTap: () {},
          ),
          10.verticalSpace,
          buildSecuritySection(),
          30.verticalSpace,
        ],
      ),
    );
  }

  Widget buildRenewalStatusWidget(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  const SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      value: 0.75,
                      strokeWidth: 10,
                      backgroundColor: Color(0xFFF3E0DA),
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE35D33)),
                    ),
                  ),
                  Text(
                    '25 ${AppStrings.days.tr}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '25 ${AppStrings.daysLeft.tr}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF9C3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFDE047).withOpacity(0.5)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/images/alert_icon.png", height: 40.h),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppStrings.accountReviewWarning.tr,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 18.h),
          _buildTimelineItem(
            '1',
            AppStrings.renewalRequestSubmitted.tr,
            'Submitted on Oct 20, 2025',
            isLast: false,
          ),
          _buildTimelineItem(
            '2',
            AppStrings.underReview.tr,
            'By Admin R. Khan – Oct 21, 2025',
            isLast: false,
          ),
          _buildTimelineItem(
            '3',
            AppStrings.statusUpdate.tr,
            'Validated on Oct 25, 2025',
            isLast: false,
          ),
          _buildTimelineItem(
            '4',
            AppStrings.nextRenewalDue.tr,
            '15/Oct/2026 – 25 ${AppStrings.daysLeft.tr}',
            isLast: true,
          ),
          const SizedBox(height: 32),
          CustomButton(
            borderRadius: 15,
            fontSize: 14,
            text: AppStrings.startRenewalProcess.tr,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String number, String title, String subtitle, {bool isLast = false}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFF4382E9),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  number,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: const Color(0xFFE5E7EB),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4.h),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
                if (!isLast) const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSecuritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE8E8E8), width: 1.2),
          ),
          child: Row(
            children: [
              const ImageIcon(
                AssetImage("assets/images/delete_account_icon.png"), // Note: Replace with actual 2FA icon if available
                color: Colors.blue,
                size: 30,
              ),
              16.horizontalSpace,
              Expanded(
                child: Text(
                  AppStrings.authentication2FA.tr,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2D3142),
                  ),
                ),
              ),
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: true,
                  onChanged: (val) {},
                  activeColor: Colors.white,
                  activeTrackColor: Colors.blue,
                ),
              ),
            ],
          ),
        ),
        12.verticalSpace,
      ],
    );
  }
}