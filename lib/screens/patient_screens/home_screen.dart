import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/home_controller.dart';
import 'package:patient_app/screens/patient_screens/appointment_screens/appointment_detail_screen.dart';
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

  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeController.fetchAppointments();
    });
    return Scaffold(
      body: Obx(() {
        if (homeController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        }

        final user = homeController.currentUser.value;
        final userName = user?.fullName ?? 'User';
        final userImage = user?.patientData?.profileImage;

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
                    homeController.scrollValue.value >= 280;
                final double targetHeight = isScrolledPastThreshold ? 100.0 : 0.0;
                final Color targetColor = isScrolledPastThreshold
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
                        backgroundImage: userImage != null && userImage.isNotEmpty
                            ? NetworkImage(userImage)
                            : AssetImage("assets/demo_images/home_demo_image.png") as ImageProvider,
                      ),
                      20.horizontalSpace,
                      Text(
                        userName,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: AppFonts.jakartaBold,
                          fontSize: 19.h,
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
                              backgroundImage: userImage != null && userImage.isNotEmpty
                                  ? NetworkImage(userImage)
                                  : AssetImage("assets/demo_images/home_demo_image.png") as ImageProvider,
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
                            "${AppStrings.hello.tr}\n$userName",
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

                        Obx(()=> homeController.ongoingAppointment.value!=null? 15.verticalSpace:SizedBox()),
                        Obx(
        ()=> homeController.ongoingAppointment.value!=null?AppointmentCard(
                            title: AppStrings.ongoingAppointment.tr,
                            buttonText: AppStrings.join.tr,
                            appointment: homeController.ongoingAppointment.value!,

                            onTap: () {
                              Get.to(AppointmentDetailScreen(appointment: homeController.ongoingAppointment.value!));
                            },
                          ):SizedBox(),
                        ),
                        15.verticalSpace,
                        Obx(
        ()=> homeController.upcomingAppointment.value!=null?AppointmentCard(
                            title: AppStrings.upcomingAppointment.tr,
                            buttonText: AppStrings.detail.tr,
                            appointment: homeController.upcomingAppointment.value!,
                            onTap: () {
                              Get.to(AppointmentDetailScreen(appointment: homeController.upcomingAppointment.value!));
                            },
                          ):SizedBox(),
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
        );
      }),
    );
  }
}