import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_profile_controller.dart';
import 'package:patient_app/controllers/patient_controllers/profile_controller.dart';
import 'package:patient_app/controllers/pharmacy_controllers/pharmacy_profile_controller.dart';
import 'package:patient_app/screens/pharmacy_screens/legal_information.dart';
import 'package:patient_app/widgets/pharmacy_widgets/pharmacy_personal_info.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../widgets/patient_widgets/profile_widgets/delete_account_dialog.dart';
import '../../../widgets/patient_widgets/profile_widgets/documents_and_reports.dart';
import '../../../widgets/patient_widgets/profile_widgets/health_space_card.dart';
import '../../../widgets/patient_widgets/profile_widgets/medical_vitals.dart';
import '../patient_screens/chat_screens/chat_screen.dart';
import '../patient_screens/notifications_screens/notifications_screen.dart';
import '../patient_screens/video_call_screens/help_center_screen.dart';

class PharmacyProfileScreen extends StatelessWidget {
  PharmacyProfileScreen({super.key});
  ProfileController controller=Get.put(ProfileController());
  PharmacyProfileController profileController=Get.put(PharmacyProfileController());
  @override
  Widget build(BuildContext context) {
    profileController.scrollChange();
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
                  profileController.scrollValue.value >= 180;

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
                        "assets/images/pharmacy_icon.png",
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
                        Get.to(ChatScreen(showBackIcon: true,));
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
                controller: profileController.scrollController,
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
                              "assets/images/pharmacy_icon.png",
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Get.to(ChatScreen(showBackIcon: true,));
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
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Profile & Settings",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w800,
                            fontFamily: AppFonts.jakartaBold,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Manage Your Pharmacy Details & Settings",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          profileType("Personal Info", 80.w),
                          5.horizontalSpace,
                          profileType("Legal Information", 100.w),
                          5.horizontalSpace,
                          profileType("Documents", 70.w),
                          5.horizontalSpace,
                          profileType("Renewal Status", 90),
                        ],
                      ),
                      15.verticalSpace,
                      Obx(
                            () =>
                        controller.type.value == "Personal Info"
                            ? PharmacyPersonalInfo()
                            : controller.type.value == "Legal Information"
                            ? LegalInformation()
                            : controller.type.value == "Documents"?DocumentsAndReportsProfile():SizedBox(),
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
                fontSize: 11.sp,
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
