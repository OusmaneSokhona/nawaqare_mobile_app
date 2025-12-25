import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/pharmacy_controllers/pharmacy_report_controller.dart';
import 'package:patient_app/screens/patient_screens/chat_screens/chat_screen.dart';
import 'package:patient_app/screens/patient_screens/video_call_screens/help_center_screen.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import '../patient_screens/notifications_screens/notifications_screen.dart';

class PharmacyReportScreen extends StatelessWidget {
  PharmacyReportScreen({super.key});

  final PharmacyReportController reportController = Get.put(PharmacyReportController());

  @override
  Widget build(BuildContext context) {
    reportController.scrollChange();
    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor,
              AppColors.primaryColor.withOpacity(0.01),
              AppColors.primaryColor.withOpacity(0.01),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Obx(() {
              final bool isScrolledPastThreshold = reportController.scrollValue.value >= 180;
              final double targetHeight = isScrolledPastThreshold ? 100.0 : 0.0;
              final Color targetColor = isScrolledPastThreshold ? AppColors.primaryColor : Colors.transparent;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                height: targetHeight,
                width: 1.sw,
                color: targetColor,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                     CircleAvatar(
                      radius: 20.h,
                      backgroundColor: Colors.white,
                      foregroundImage: AssetImage("assets/images/pharmacy_icon.png"),
                    ),
                    20.horizontalSpace,
                    Text(
                      AppStrings.drAlex.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: AppFonts.jakartaBold,
                        fontSize: 22.h,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    _buildNavIcon("assets/images/chat_icon.png", () => Get.to(ChatScreen(showBackIcon: true)), color: Colors.white),
                    5.horizontalSpace,
                    _buildNavIcon("assets/images/help_center_icon.png", () => Get.to(() => HelpCenterScreen())),
                    5.horizontalSpace,
                    _buildNavIcon("assets/images/bell_icon.png", () => Get.to(() => NotificationScreen())),
                  ],
                ),
              );
            }),
            Expanded(
              child: SingleChildScrollView(
                controller: reportController.scrollController,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.sp),
                  child: Column(
                    children: [
                      60.verticalSpace,
                      _buildHeaderRow(),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.reports.tr,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w800,
                            fontFamily: AppFonts.jakartaBold,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.reportsSubtitle.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: AppFonts.jakartaBold,
                            fontSize: 15.sp,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.analytics.tr,
                          style: TextStyle(fontSize: 19.sp, color: Colors.black, fontWeight: FontWeight.w700),
                        ),
                      ),
                      5.verticalSpace,
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.6,
                        children: [
                          _buildStatCard(
                            icon: Icons.check_circle_rounded,
                            label: AppStrings.acceptanceRate.tr,
                            value: '92%',
                          ),
                          _buildStatCard(
                            icon: Icons.warning_rounded,
                            label: AppStrings.partialFulfillmentRate.tr,
                            value: '20',
                          ),
                          _buildStatCard(
                            icon: Icons.access_time_filled_rounded,
                            label: AppStrings.avgValidationTime.tr,
                            value: '4m 12s',
                          ),
                          _buildStatCard(
                            label: AppStrings.frequentDrugsDelivered.tr,
                            value: '20',
                            iconPath: "assets/images/drug_delivered_icon.png",
                          ),
                          _buildStatCard(
                            label: AppStrings.stockOutFrequency.tr,
                            value: '3/week',
                            iconPath: "assets/images/stock_out_icon.png",
                          ),
                          _buildStatCard(
                            icon: Icons.local_shipping_rounded,
                            label: AppStrings.deliveryCompletionTime.tr,
                            value: '1h 15m avg',
                          ),
                        ],
                      ),
                      10.verticalSpace,
                      _buildStatCard(
                        icon: Icons.monetization_on_rounded,
                        label: AppStrings.generatedRevenue.tr,
                        value: '\$82,00',
                        isFullWidth: true,
                      ),
                      10.verticalSpace,
                      _buildDemoImage("assets/demo_images/1_demo.png"),
                      10.verticalSpace,
                      _buildDemoImage("assets/demo_images/2_demo.png"),
                      10.verticalSpace,
                      _buildDemoImage("assets/demo_images/3_demo.png"),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.dataRefreshNote.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: AppFonts.jakartaBold,
                            fontSize: 15.sp,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.exportReport.tr,
                        onTap: () {},
                      ),
                      20.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(String asset, VoidCallback onTap, {Color? color}) {
    return InkWell(
      onTap: onTap,
      child: Image.asset(asset, height: 25.h, color: color),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: [
         CircleAvatar(
          radius: 35.h,
          backgroundColor: Colors.white,
          foregroundImage: AssetImage("assets/images/pharmacy_icon.png"),
        ),
        const Spacer(),
        _buildNavIcon("assets/images/chat_icon.png", () => Get.to(ChatScreen(showBackIcon: true)), color: Colors.white),
        10.horizontalSpace,
        _buildNavIcon("assets/images/help_center_icon.png", () => Get.to(() => HelpCenterScreen())),
        10.horizontalSpace,
        _buildNavIcon("assets/images/bell_icon.png", () => Get.to(() => NotificationScreen())),
      ],
    );
  }

  Widget _buildDemoImage(String asset) {
    return Image.asset(asset, width: 1.sw, fit: BoxFit.fitWidth);
  }

  Widget _buildStatCard({
    IconData? icon,
    required String label,
    required String value,
    String? iconPath,
    bool isFullWidth = false,
  }) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1.2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) Icon(icon, color: AppColors.primaryColor, size: 28.h),
          if (iconPath != null) ImageIcon(AssetImage(iconPath), color: AppColors.primaryColor, size: 24.h),
          SizedBox(height: 4.h),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2D3142),
            ),
          ),
          Text(
            value,
            maxLines: 1,
            style: TextStyle(
              fontSize: 11.sp,
              color: const Color(0xFF8E949A),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}