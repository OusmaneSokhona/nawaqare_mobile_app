import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/pharmacy_controllers/pharmacy_home_controller.dart';
import 'package:patient_app/screens/patient_screens/chat_screens/chat_screen.dart';
import 'package:patient_app/screens/patient_screens/video_call_screens/help_center_screen.dart';
import 'package:patient_app/screens/pharmacy_screens/upload_prescription_screen.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import '../patient_screens/notifications_screens/notifications_screen.dart';

class PharmacyHomeScreen extends StatelessWidget {
  PharmacyHomeScreen({super.key});

  PharmacyHomeController homeController = Get.put(PharmacyHomeController());

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
              isScrolledPastThreshold ? AppColors.primaryColor : Colors.transparent;

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
                      "Dr Alex",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: AppFonts.jakartaBold,
                        fontSize: 22.h,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                      },
                      child: Image.asset(
                        "assets/images/chat_icon.png",
                        height: 25.h,
                        color: Colors.white,
                      ),
                    ),
                    5.horizontalSpace,
                    InkWell(
                      onTap: () {
                        Get.to(() => HelpCenterScreen());
                      },
                      child: Image.asset(
                        "assets/images/help_center_icon.png",
                        height: 25.h,
                      ),
                    ),
                    5.horizontalSpace,
                    InkWell(
                      onTap: () {
                        Get.to(() => NotificationScreen());
                      },
                      child: Image.asset(
                        "assets/images/bell_icon.png",
                        height: 25.h,
                      ),
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
                          InkWell(
                            onTap: () {
                            },
                            child: Image.asset(
                              "assets/images/chat_icon.png",
                              height: 25.h,
                              color: Colors.white,
                            ),
                          ),
                          10.horizontalSpace,
                          InkWell(
                            onTap: () {
                              Get.to(() => HelpCenterScreen());
                            },
                            child: Image.asset(
                              "assets/images/help_center_icon.png",
                              height: 25.h,
                            ),
                          ),
                          10.horizontalSpace,
                          InkWell(
                            onTap: () {
                              Get.to(() => NotificationScreen());
                            },
                            child: Image.asset(
                              "assets/images/bell_icon.png",
                              height: 30.h,
                            ),
                          ),
                        ],
                      ),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Pharma Plus\nLahore",
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
      borderRadius: BorderRadius.circular(12.sp)
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(icon, color: iconColor, height: 30.h),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style:  TextStyle(
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
      switch (status) {
        case 'Pending':
          return AppColors.orange;
        case 'Accepted':
          return AppColors.green;
        case 'Rejected':
          return AppColors.red;
        default:
          return Colors.grey.shade100;
      }
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
          fontSize: 12.sp,
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
            style:  TextStyle(fontSize: 13.sp,fontFamily: AppFonts.jakartaMedium,color: AppColors.lightGrey,fontWeight: FontWeight.w500),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: statusTag(status: status),
          ),
          Text(
            time,
            style: const TextStyle(color: Colors.black54),
            textAlign: TextAlign.end,
          ),
          const SizedBox(width: 12),
          const ImageIcon(AssetImage("assets/images/pharmacy_chat_icon.png"), color: Colors.blue, size: 18),
        ],
      ),
    );
  }



  Widget scanUploadButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          Get.to(UploadPrescriptionScreen());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  <Widget>[
            ImageIcon(AssetImage("assets/images/qr_scan_icon.png"), size: 24,color: Colors.white,),
            SizedBox(width: 8),
            Text(
              'Scan or Upload Prescription\"',
              style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget pharmacyDashboardUI() {
    final List<Map<String, String>> recentActivity = const [
      {'id': 'RX-20391', 'status': 'Pending', 'time': '2h ago'},
      {'id': 'RX-20391', 'status': 'Accepted', 'time': '2h ago'},
      {'id': 'RX-20391', 'status': 'Rejected', 'time': '2h ago'},
      {'id': 'RX-20391', 'status': 'Pending', 'time': '2h ago'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: <Widget>[
            statCard(
              icon:"assets/images/pending_prescription_icon.png",
              title: 'Pending Prescriptions',
              value: '15h',
              iconColor: AppColors.primaryColor,
            ),
            statCard(
              icon: "assets/images/pharmacy_calender_icon.png",
              title: 'Validated Today',
              value: '20',
              iconColor: AppColors.primaryColor,
            ),
          ],
        ),10.verticalSpace,
        Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: <Widget>[
            statCard(
              icon: "assets/images/pharmacy_warning_icon.png",
              title: 'Deliveries In Progress',
              value: '15h',
              iconColor: AppColors.primaryColor,
            ),
            statCard(
              icon: "assets/images/delivery_icon.png",
              title: 'Stock Alerts',
              value: '20',
              iconColor: AppColors.primaryColor,
            ),
          ],
        ),
        const SizedBox(height: 20),
        CustomTextField(
         hintText: "Search by Prescription ID...",
          prefixIcon: Icons.search,
          prefixIconColor: AppColors.lightGrey,
          suffixIcon: Icons.filter_list,
          suffixIconColor: AppColors.lightGrey,
        ),
        const SizedBox(height: 20),
         Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 18.sp,
            fontFamily: AppFonts.jakartaBold,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Prescription ID",
                    style:  TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w500),
                  ),
                   SizedBox(width: 20.w),
                  Text(
                    "Status",
                    style:  TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: 40.w),
                  Text(
                    "Time",
                    style:  TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w500),
                    textAlign: TextAlign.end,
                  ),
                  Spacer(),
                  Text(
                    "Action",
                    style:  TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w500),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
              Column(
                children: recentActivity.map((activity) {
                  return activityRow(
                    prescriptionId: activity['id']!,
                    status: activity['status']!,
                    time: activity['time']!,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        scanUploadButton(),
      ],
    );
  }
}