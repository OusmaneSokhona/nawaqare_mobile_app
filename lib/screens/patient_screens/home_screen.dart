import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/home_controller.dart';
import 'package:patient_app/screens/patient_screens/prescription_screens/prescription_screen.dart';
import 'package:patient_app/screens/patient_screens/video_call_screens/help_center_screen.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/category_button.dart';
import 'package:patient_app/widgets/patient_widgets/prescription_widgets/next_action_row.dart';
import 'package:patient_app/widgets/patient_widgets/order_widgets/order_tracking_card.dart';
import '../../widgets/patient_widgets/appointment_widgets/appointment_card.dart';
import 'appointment_screens/appointment_screen.dart';
import 'notifications_screens/notifications_screen.dart';
import 'order_screens/order_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    homeController.scrollChange();
    homeController.scrollValue.value=0.0;
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
                        "assets/demo_images/home_demo_image.png",
                      ),
                    ),
                    20.horizontalSpace,
                    Text(
                      "Mr Alex",
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
                              "assets/demo_images/home_demo_image.png",
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
                          "${AppStrings.hello.tr}\nMr. Alex",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 32.sp,
                            color: Colors.black87,
                            fontWeight: FontWeight.w800,
                            fontFamily: AppFonts.jakartaBold,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${AppStrings.tomorrowAt.tr} 10:30 AM",
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
                          "Dr Dupuis",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontFamily: AppFonts.jakartaBold,
                            fontSize: 20.sp,
                            color: AppColors.lightGrey,
                          ),
                        ),
                      ),
                      15.verticalSpace,
                      AppointmentCard(
                        title: AppStrings.ongoingAppointment.tr,
                        imagePath: "assets/demo_images/doctor_2.png",
                        name: "Dr. Maria Waston",
                        type: AppStrings.heartSurgeon.tr,
                        onTap: () {},
                      ),
                      15.verticalSpace,
                      AppointmentCard(
                        title: AppStrings.upcomingAppointment.tr,
                        imagePath: "assets/demo_images/doctor_1.png",
                        name: "Dr. Daniel Lee",
                        type: AppStrings.gastroenterologist.tr,
                        onTap: () {},
                      ),
                      15.verticalSpace,
                      OrderTrackingCard(currentStep: 2),
                      20.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CategoryButton(
                            onTap: () {
                              Get.to(AppointmentScreen());
                            },
                            title: AppStrings.appointments.tr,
                            icon: "assets/images/calender_icon.png",
                            color: AppColors.primaryColor,
                          ),
                          CategoryButton(
                            onTap: () {
                              Get.to(PrescriptionScreen());
                            },
                            title: AppStrings.prescription.tr,
                            icon: "assets/images/prescription_icon.png",
                            color: AppColors.green,
                          ),
                          CategoryButton(
                            onTap: () {
                              Get.to(OrderScreen());
                            },
                            title: AppStrings.orders.tr,
                            icon: "assets/images/box_icon.png",
                            color: AppColors.orange,
                          ),
                        ],
                      ),
                      15.verticalSpace,
                      NextActionsRow(),
                      10.verticalSpace,
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