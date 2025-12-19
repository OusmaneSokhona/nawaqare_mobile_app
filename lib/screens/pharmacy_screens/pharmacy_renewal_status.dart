import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/patient_widgets/profile_widgets/health_space_card.dart';
import 'package:patient_app/widgets/pharmacy_widgets/pharmacy_health_space_grid.dart';

import '../../../controllers/patient_controllers/profile_controller.dart';


class PharmacyRenewalStatus extends StatelessWidget{
  PharmacyRenewalStatus({super.key});
  ProfileController controller=Get.put(ProfileController());
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
          Center(
            child: Text(
              "Alex Martin Pharmacy",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
          Center(
            child: Text(
              'Last update: ${controller.user.value.lastUpdate}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          const SizedBox(height: 10),
          buildRenewalStatusWidget(context),
          const Text(
            'Security Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 10.h),
          PharmacyHealthSpaceGrid(profileController: controller),
          10.verticalSpace,
          HealthSpaceCard(icon: "assets/images/payment_setting_icon.png", title: "Payment Setting", onTap: (){}),
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
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      value: 0.75,
                      strokeWidth: 10,
                      backgroundColor: const Color(0xFFF3E0DA),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE35D33)),
                    ),
                  ),
                   Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '25 Days',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
               Text(
                '25 days left',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
           SizedBox(height: 14.h),
          Container(
            padding:  EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF9C3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFDE047).withOpacity(0.5)),
            ),
            child:  Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/images/alert_icon.png",height: 40.h,),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your account is under review or pending revalidation.',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
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
            'Renewal Request Submitted',
            'Submitted on Oct 20, 2025',
            isLast: false,
          ),
          _buildTimelineItem(
            '2',
            'Under Review',
            'By Admin R. Khan – Oct 21, 2025',
            isLast: false,
          ),
          _buildTimelineItem(
            '3',
            'Status Update',
            'Validated on Oct 25, 2025',
            isLast: false,
          ),
          _buildTimelineItem(
            '4',
            'Next Renewal Due',
            '15/Oct/2026 – 25 days left',
            isLast: true,
          ),
          const SizedBox(height: 32),
         CustomButton(borderRadius: 15, text: "Start Renewal Process", onTap: (){}),
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
                  style:  TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                 SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style:  TextStyle(
                    fontSize: 12.sp,
                    color: Color(0xFF9CA3AF),
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
              ImageIcon(AssetImage("assets/images/delete_account_icon.png"), color: Colors.blue, size: 30.sp),
              16.horizontalSpace,
              Expanded(
                child: Text(
                  "2FA Authentication",
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