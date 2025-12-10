import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_profile_controller.dart';
import 'package:patient_app/controllers/patient_controllers/profile_controller.dart';
import 'package:patient_app/widgets/doctor_widgets/profile_widgets/doctor_documents.dart';
import 'package:patient_app/widgets/doctor_widgets/profile_widgets/doctor_personal_info.dart';
import 'package:patient_app/widgets/doctor_widgets/profile_widgets/doctor_professional_info.dart';
import 'package:patient_app/widgets/doctor_widgets/profile_widgets/revalidation.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../widgets/patient_widgets/profile_widgets/delete_account_dialog.dart';
import '../../../widgets/patient_widgets/profile_widgets/health_space_card.dart';
import '../../patient_screens/notifications_screens/notifications_screen.dart';
import '../../patient_screens/video_call_screens/help_center_screen.dart';

class DoctorProfileScreen extends StatelessWidget {
  DoctorProfileScreen({super.key});
  DoctorProfileController controller=Get.put(DoctorProfileController());
  ProfileController profileController=Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    controller.scrollChange();
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
                  controller.scrollValue.value >= 280;

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
                controller: controller.scrollController,
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
                              height: 30.h,
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
                          "Profile",
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
                          "Real-Time Messaging For Consultations.",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppFonts.jakartaMedium,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ),
                      15.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              profileType("Personal Info", 65.w),
                              9.horizontalSpace,
                              profileType("Professional Info", 80.w),
                              9.horizontalSpace,
                              profileType("Documents", 55.w),
                              9.horizontalSpace,
                              profileType("Revalidation", 60.w),
                            ],
                          ),
                        ),
                      ),
                      15.verticalSpace,
                      Obx(
                            () =>
                        controller.type.value == "Personal Info"
                            ? DoctorPersonalInfo()
                            : controller.type.value == "Professional Info"
                            ? DoctorProfessionalInfo()
                            : controller.type.value=="Documents"?DoctorDocuments():Revalidation(),
                      ),
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

  Widget profileType(String title, double width) {
    return Obx(
          () => InkWell(
        onTap: () {
          controller.type.value = title;
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color:
                controller.type.value == title
                    ? AppColors.primaryColor
                    : AppColors.lightGrey,
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            2.verticalSpace,
            controller.type.value == title
                ? Container(
              width: width.w,
              height: 3.h,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(7.sp),
              ),
            )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
