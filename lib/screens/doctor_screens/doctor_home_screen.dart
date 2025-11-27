import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_home_controller.dart';
import 'package:patient_app/screens/doctor_screens/appointment_screens/doctor_appointment_screen.dart';
import 'package:patient_app/screens/patient_screens/appointment_screens/appointment_screen.dart';
import 'package:patient_app/screens/patient_screens/video_call_screens/help_center_screen.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/widgets/category_button.dart';
import 'package:patient_app/widgets/doctor_widgets/home_widgets/quick_statistics_card.dart';
import 'package:patient_app/widgets/doctor_widgets/home_widgets/recent_activity_card.dart';

import '../../widgets/patient_widgets/appointment_widgets/appointment_card.dart';
import '../patient_screens/notifications_screens/notifications_screen.dart';

class DoctorHomeScreen extends StatelessWidget {
  DoctorHomeScreen({super.key});

  DoctorHomeController homeController = Get.put(DoctorHomeController());

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
                  homeController.scrollValue.value >= 280;

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
                      foregroundImage: AssetImage(
                        "assets/demo_images/doctor_1.png",
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
                    Spacer(),
                    InkWell(
                      onTap: () {
                        Get.to(HelpCenterScreen());
                      },
                      child: Image.asset(
                        "assets/images/help_center_icon.png",
                        height: 25.h,
                      ),
                    ),
                    10.horizontalSpace,
                    InkWell(
                      onTap: () {
                        Get.to(NotificationScreen());
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
                            foregroundImage: AssetImage(
                              "assets/demo_images/doctor_1.png",
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Get.to(HelpCenterScreen());
                            },
                            child: Image.asset(
                              "assets/images/help_center_icon.png",
                              height: 25.h,
                            ),
                          ),
                          10.horizontalSpace,
                          InkWell(
                            onTap: () {
                              Get.to(NotificationScreen());
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
                          "Hello,\nDr. Alex",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 35.sp,
                            fontWeight: FontWeight.w800,
                            fontFamily: AppFonts.jakartaBold,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Tomorrow at 10:30 AM",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontFamily: AppFonts.jakartaBold,
                            fontSize: 20.sp,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ),
                      5.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Mr Dupuis",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontFamily: AppFonts.jakartaBold,
                            fontSize: 20.sp,
                            color: AppColors.lightGrey,
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      Container(
                        height: 40.h,
                        width: 1.sw,
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10.sp),
                          border: Border.all(
                            color: AppColors.lightGrey.withOpacity(0.5),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/offline_mode_icon.png",
                              height: 20.h,
                              fit: BoxFit.fill,
                            ),
                            10.horizontalSpace,
                            Text(
                              "Offline mode activated",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                fontFamily: AppFonts.jakartaMedium,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      15.verticalSpace,
                      AppointmentCard(
                        title: "Ongoing  Appointment",
                        imagePath: "assets/demo_images/home_demo_image.png",
                        name: "Mr. Waston",
                        type: 'Patient',
                        showGreenDot: false,
                        showRating: false,
                      ),
                      15.verticalSpace,
                      AppointmentCard(
                        title: "Upcoming Appointment",
                        imagePath: "assets/demo_images/home_demo_image.png",
                        name: "Mr. Waston",
                        type: 'Patient',
                        buttonText: "Detail",
                        showGreenDot: false,
                        showRating: false,
                        consultationTypeIcon: Icons.home_work_outlined,
                        consultationTypeText: "In-Person Consultation",
                      ),
                      20.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CategoryButton(
                            onTap: () {
                              Get.to(DoctorAppointmentScreen());
                            },
                            title: "Appointments",
                            icon: "assets/images/calender_icon.png",
                            color: AppColors.primaryColor,
                          ),
                          CategoryButton(
                            onTap: () {
                            },
                            title: "Patients",
                            icon: "assets/images/pateint_button_icon.png",
                            color: AppColors.green,
                          ),
                          CategoryButton(
                            onTap: () {
                            },
                            title: "Statistics",
                            icon: "assets/images/statistics_button_icon.png",
                            color: AppColors.orange,
                          ),
                        ],
                      ),
                      15.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Quick Statistics",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontFamily: AppFonts.jakartaBold,
                            fontSize: 19.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      QuickStatisticsCard(),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Recent Activity",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontFamily: AppFonts.jakartaBold,
                            fontSize: 19.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      RecentActivityCard(),
                      25.verticalSpace,
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
}
