import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_home_controller.dart';
import 'package:patient_app/main.dart';
import 'package:patient_app/screens/doctor_screens/appointment_screens/doctor_appointment_detail.dart';
import 'package:patient_app/screens/doctor_screens/appointment_screens/doctor_appointment_screen.dart';
import 'package:patient_app/screens/doctor_screens/patient_screens/patient_screen.dart';
import 'package:patient_app/screens/doctor_screens/prescription_screens/doctor_prescription_screen.dart';
import 'package:patient_app/screens/doctor_screens/statics_screen/statics_screen.dart';
import 'package:patient_app/screens/patient_screens/video_call_screens/help_center_screen.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/widgets/category_button.dart';
import 'package:patient_app/widgets/doctor_widgets/home_widgets/doctor_appointment_card.dart';
import 'package:patient_app/widgets/doctor_widgets/home_widgets/quick_statistics_card.dart';
import 'package:patient_app/widgets/doctor_widgets/home_widgets/recent_activity_card.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../patient_screens/notifications_screens/notifications_screen.dart';

class DoctorHomeScreen extends StatelessWidget {
  DoctorHomeScreen({super.key});

  DoctorHomeController homeController = Get.put(DoctorHomeController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeController.fetchAppointments();
    });
    homeController.scrollChange();
    bool isDesktop = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      body: Obx(() {
        if (homeController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        final doctor = homeController.currentUser.value;
        final doctorName = doctor?.fullName ?? 'Doctor';
        final doctorImage = doctor?.profileImage;

        return Container(
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
                    isDesktop
                        ? homeController.scrollValue.value >= 120
                        : homeController.scrollValue.value >= 280;
                final double targetHeight =
                    isScrolledPastThreshold ? 100.0 : 0.0;
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 25.h,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            doctorImage != null && doctorImage.isNotEmpty
                                ? NetworkImage(doctorImage)
                                : AssetImage("assets/demo_images/doctor_1.png")
                                    as ImageProvider,
                      ),
                      isDesktop ? 5.horizontalSpace : 20.horizontalSpace,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctorName,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: AppFonts.jakartaBold,
                              fontSize: 22.h,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          isDesktop
                              ? Text(
                                "Home",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontFamily: AppFonts.jakartaBold,
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                              : SizedBox(),
                        ],
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
                      isDesktop ? 2.horizontalSpace : 10.horizontalSpace,
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
                child: RefreshIndicator(
                  onRefresh: () async {
                    await homeController.fetchAppointments();
                  },
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
                                backgroundImage:
                                    doctorImage != null &&
                                            doctorImage.isNotEmpty
                                        ? NetworkImage(doctorImage)
                                        : AssetImage(
                                              "assets/demo_images/doctor_1.png",
                                            )
                                            as ImageProvider,
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
                              isDesktop
                                  ? 2.horizontalSpace
                                  : 10.horizontalSpace,
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
                              "${AppStrings.hello.tr}\n$doctorName",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: isDesktop ? 8.sp : 32.sp,
                                fontWeight:
                                    isDesktop
                                        ? FontWeight.w500
                                        : FontWeight.w800,
                                fontFamily: AppFonts.jakartaBold,
                              ),
                            ),
                          ),
                          Obx(
                            () =>
                                homeController.ongoingAppointment.value != null
                                    ? 15.verticalSpace
                                    : SizedBox(),
                          ),
                          Obx(
                            () =>
                                homeController.ongoingAppointment.value != null
                                    ? DoctorAppointmentCard(
                                      title: AppStrings.ongoingAppointment.tr,
                                      buttonText: AppStrings.join.tr,
                                      appointment:
                                          homeController
                                              .ongoingAppointment
                                              .value!,
                                      onTap: () {},
                                    )
                                    : SizedBox(),
                          ),
                          Obx(
                            () =>
                                homeController.upcomingAppointment.value != null
                                    ? 15.verticalSpace
                                    : SizedBox(),
                          ),
                          Obx(
                            () =>
                                homeController.upcomingAppointment.value != null
                                    ? DoctorAppointmentCard(
                                      title: AppStrings.upcomingAppointment.tr,
                                      buttonText: AppStrings.detail.tr,
                                      appointment:
                                          homeController
                                              .upcomingAppointment
                                              .value!,
                                      onTap: () {
                                        Get.to(DoctorAppointmentDetail(appointmentModel: homeController.upcomingAppointment.value!));
                                      },
                                    )
                                    : SizedBox(),
                          ),
                          20.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CategoryButton(
                                onTap: () {
                                  Get.to(DoctorAppointmentScreen());
                                },
                                title: AppStrings.appointments.tr,
                                icon: "assets/images/calender_icon.png",
                                color: AppColors.primaryColor,
                              ),
                              CategoryButton(
                                onTap: () {
                                  Get.to(PatientScreen());
                                },
                                title: AppStrings.patients.tr,
                                icon: "assets/images/pateint_button_icon.png",
                                color: AppColors.green,
                              ),
                              CategoryButton(
                                onTap: () {
                                  Get.to(DoctorPrescriptionScreen());
                                },
                                title: AppStrings.prescriptionDoctor.tr,
                                icon: "assets/images/prescription_icon.png",
                                color: AppColors.secondryColor,
                              ),
                              CategoryButton(
                                onTap: () {
                                  Get.to(StaticsScreen());
                                },
                                title: AppStrings.statistics.tr,
                                icon:
                                    "assets/images/statistics_button_icon.png",
                                color: AppColors.orange,
                              ),
                            ],
                          ),
                          15.verticalSpace,
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppStrings.quickStatistics.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontFamily: AppFonts.jakartaBold,
                                fontSize: isWeb ? 6.sp : 19.sp,
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
                              AppStrings.recentActivity.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontFamily: AppFonts.jakartaBold,
                                fontSize: isWeb ? 6.sp : 19.sp,
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
              ),
            ],
          ),
        );
      }),
    );
  }
}
