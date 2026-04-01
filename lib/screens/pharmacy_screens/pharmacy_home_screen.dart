import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/pharmacy_controllers/pharmacy_home_controller.dart';
import 'package:patient_app/screens/patient_screens/chat_screens/chat_screen.dart';
import 'package:patient_app/screens/help_center_screen.dart';
import 'package:patient_app/screens/pharmacy_screens/upload_prescription_screen.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import '../patient_screens/notifications_screens/notifications_screen.dart';

class PharmacyHomeScreen extends StatelessWidget {
  PharmacyHomeScreen({super.key});

  final PharmacyHomeController homeController = Get.put(
    PharmacyHomeController(),
  );

  @override
  Widget build(BuildContext context) {
    homeController.scrollChange();
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
              final bool isScrolledPastThreshold =
                  homeController.scrollValue.value >= 180;
              final double targetHeight = isScrolledPastThreshold ? 100.0 : 0.0;
              final Color targetColor =
                  isScrolledPastThreshold
                      ? AppColors.primaryColor
                      : Colors.transparent;

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
                      foregroundImage: const AssetImage(
                        "assets/images/pharmacy_icon.png",
                      ),
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
                    _buildIconBtn(
                      "assets/images/chat_icon.png",
                      () => Get.to(ChatScreen(showBackIcon: true)),
                    ),
                    5.horizontalSpace,
                    _buildIconBtn(
                      "assets/images/help_center_icon.png",
                      () => Get.to(() => HelpCenterScreen()),
                    ),
                    5.horizontalSpace,
                    _buildIconBtn(
                      "assets/images/bell_icon.png",
                      () => Get.to(() => NotificationScreen()),
                    ),
                  ],
                ),
              );
            }),
            Expanded(
              child: SingleChildScrollView(
                controller: homeController.scrollController,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.sp),
                  child: Column(
                    children: [
                      60.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 35.h,
                            backgroundColor: Colors.white,
                            foregroundImage: const AssetImage(
                              "assets/images/pharmacy_icon.png",
                            ),
                          ),
                          const Spacer(),
                          _buildIconBtn(
                            "assets/images/chat_icon.png",
                            () => Get.to(ChatScreen(showBackIcon: true)),
                          ),
                          10.horizontalSpace,
                          _buildIconBtn(
                            "assets/images/help_center_icon.png",
                            () => Get.to(() => HelpCenterScreen()),
                          ),
                          10.horizontalSpace,
                          _buildIconBtn(
                            "assets/images/bell_icon.png",
                            () => Get.to(() => NotificationScreen()),
                            height: 30.h,
                          ),
                        ],
                      ),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.pharmaPlusLahore.tr,
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
                          "Monday, 20 Oct  at 10:30 AM",
                          // Usually dynamically formatted, kept static for UI
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontFamily: AppFonts.jakartaBold,
                            fontSize: 18.sp,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ),
                      5.verticalSpace,
                      pharmacyDashboardUI(),
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

  Widget _buildIconBtn(
    String asset,
    VoidCallback onTap, {
    double height = 25,
  }) {
    return InkWell(
      onTap: onTap,
      child: Image.asset(
        asset,
        height: height,
        color: asset.contains("chat") ? Colors.white : null,
      ),
    );
  }

  Widget statCard({
    required String icon,
    required String title,
    required String value,
    required Color iconColor,
    Color backgroundColor = Colors.white,
  }) {
    return Container(
      width: 0.44.sw,
      height: 120.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.4)),
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.sp),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(icon, color: iconColor, height: 30.h),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget statusTag({required String status}) {
    Color getStatusColor() {
      if (status == AppStrings.pendingStatus.tr) return AppColors.orange;
      if (status == AppStrings.acceptedStatus.tr) return AppColors.green;
      if (status == AppStrings.rejectedStatus.tr) return AppColors.red;
      return Colors.grey.shade400;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: getStatusColor(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: Colors.white,
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget activityRow({
    required String prescriptionId,
    required String status,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            prescriptionId,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.lightGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          statusTag(status: status),
          Text(
            time,
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
          const ImageIcon(
            AssetImage("assets/images/pharmacy_chat_icon.png"),
            color: Colors.blue,
            size: 18,
          ),
        ],
      ),
    );
  }

  Widget scanUploadButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: ElevatedButton(
        onPressed: () => Get.to(const UploadPrescriptionScreen()),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const ImageIcon(
              AssetImage("assets/images/qr_scan_icon.png"),
              size: 24,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              AppStrings.scanOrUploadPrescription.tr,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget pharmacyDashboardUI() {
    final List<Map<String, String>> recentActivity = [
      {
        'id': 'RX-20391',
        'status': AppStrings.pendingStatus.tr,
        'time': '2h ago',
      },
      {
        'id': 'RX-20391',
        'status': AppStrings.acceptedStatus.tr,
        'time': '2h ago',
      },
      {
        'id': 'RX-20391',
        'status': AppStrings.rejectedStatus.tr,
        'time': '2h ago',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            statCard(
              icon: "assets/images/pending_prescription_icon.png",
              title: AppStrings.pendingPrescriptions.tr,
              value: '15h',
              iconColor: AppColors.primaryColor,
            ),
            statCard(
              icon: "assets/images/pharmacy_calender_icon.png",
              title: AppStrings.validatedToday.tr,
              value: '20',
              iconColor: AppColors.primaryColor,
            ),
          ],
        ),
        10.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            statCard(
              icon: "assets/images/pharmacy_warning_icon.png",
              title: AppStrings.deliveriesInProgress.tr,
              value: '5',
              iconColor: AppColors.primaryColor,
            ),
            statCard(
              icon: "assets/images/delivery_icon.png",
              title: AppStrings.stockAlerts.tr,
              value: '12',
              iconColor: AppColors.primaryColor,
            ),
          ],
        ),
        20.verticalSpace,
        CustomTextField(
          hintText: AppStrings.searchByPrescriptionId.tr,
          prefixIcon: Icons.search,
          prefixIconColor: AppColors.lightGrey,
          suffixIcon: Icons.filter_list,
          suffixIconColor: AppColors.lightGrey,
        ),
        20.verticalSpace,
        Text(
          AppStrings.recentActivity.tr,
          style: TextStyle(
            fontSize: 18.sp,
            fontFamily: AppFonts.jakartaBold,
            fontWeight: FontWeight.bold,
          ),
        ),
        10.verticalSpace,
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _headerText(AppStrings.prescriptionIdLabel.tr),
                  _headerText(AppStrings.statusLabel.tr),
                  _headerText(AppStrings.timeLabel.tr),
                  _headerText(AppStrings.actionLabel.tr),
                ],
              ),
              const Divider(),
              ...recentActivity.map(
                (activity) => activityRow(
                  prescriptionId: activity['id']!,
                  status: activity['status']!,
                  time: activity['time']!,
                ),
              ),
            ],
          ),
        ),
        scanUploadButton(),
      ],
    );
  }

  Widget _headerText(String text) => Text(
    text,
    style: TextStyle(
      fontSize: 11.sp,
      fontWeight: FontWeight.w600,
      color: Colors.grey,
    ),
  );
}
