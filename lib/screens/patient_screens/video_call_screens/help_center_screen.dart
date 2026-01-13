import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/main.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../../controllers/patient_controllers/appointment_controllers/setting_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';

class HelpCenterScreen extends StatelessWidget {
  HelpCenterScreen({super.key});

  final SettingsController controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.onboardingBackground, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              70.verticalSpace,
              Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: Image.asset(
                      "assets/images/back_icon.png",
                      height: 22.h,
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    AppStrings.helpCenter.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: isWeb?12.sp:23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              20.verticalSpace,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lightGrey.withOpacity(0.3)),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.sp),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset('assets/images/help_center_image.png',height: 0.3.sh),
                      10.verticalSpace,
                      _buildContactCard(
                        icon: Icons.phone,
                        title: AppStrings.phone.tr,
                        subtitle: '03 5432 1234',
                      ),
                      10.verticalSpace,
                      _buildContactCard(
                        icon: Icons.email,
                        title: AppStrings.email.tr,
                        subtitle: 'Abc@gmail.com',
                      ),
                      const SizedBox(height: 15),
                      Obx(() => _buildFaqSection(context)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Icon(icon, color: Color(0xFF4285F4), size: 30),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFaqSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: controller.toggleFaq,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  const Icon(
                    Icons.live_help_outlined,
                    color: Color(0xFF4285F4),
                    size: 30,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    AppStrings.faqs.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    controller.isFaqExpanded.value
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey.shade700,
                  ),
                ],
              ),
            ),
          ),
          if (controller.isFaqExpanded.value)
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Divider(height: 1, color: Color(0xFFF7F9FA)),
            ),
          if (controller.isFaqExpanded.value)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.faqQuestion1.tr,
                    style: const TextStyle(fontSize: 16, height: 1.8),
                  ),
                  Text(
                    AppStrings.faqQuestion2.tr,
                    style: const TextStyle(fontSize: 16, height: 1.8),
                  ),
                  Text(
                    AppStrings.faqQuestion3.tr,
                    style: const TextStyle(fontSize: 16, height: 1.8),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}