import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/profile_controller.dart';
import 'package:patient_app/controllers/pharmacy_controllers/pharmacy_profile_controller.dart';
import 'package:patient_app/screens/pharmacy_screens/legal_information.dart';
import 'package:patient_app/screens/pharmacy_screens/pharmacy_document_screen.dart';
import 'package:patient_app/screens/pharmacy_screens/pharmacy_renewal_status.dart';
import 'package:patient_app/widgets/pharmacy_widgets/pharmacy_personal_info.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_strings.dart';
import '../patient_screens/chat_screens/chat_screen.dart';
import '../patient_screens/notifications_screens/notifications_screen.dart';
import '../patient_screens/video_call_screens/help_center_screen.dart';

class PharmacyProfileScreen extends StatelessWidget {
  PharmacyProfileScreen({super.key});

  final ProfileController controller = Get.put(ProfileController());
  final PharmacyProfileController profileController = Get.put(PharmacyProfileController());

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
              final bool isScrolledPastThreshold = profileController.scrollValue.value >= 180;
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
                      AppStrings.mrAlex.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: AppFonts.jakartaBold,
                        fontSize: 22.h,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    _buildTopIcon("assets/images/chat_icon.png", () => Get.to(ChatScreen(showBackIcon: true)), color: Colors.white),
                    10.horizontalSpace,
                    _buildTopIcon("assets/images/bell_icon.png", () => Get.to(NotificationScreen())),
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
                        children: [
                           CircleAvatar(
                            radius: 35.h,
                            backgroundColor: Colors.white,
                            foregroundImage: AssetImage("assets/images/pharmacy_icon.png"),
                          ),
                          const Spacer(),
                          _buildTopIcon("assets/images/chat_icon.png", () => Get.to(ChatScreen(showBackIcon: true)), color: Colors.white),
                          10.horizontalSpace,
                          _buildTopIcon("assets/images/help_center_icon.png", () => Get.to(HelpCenterScreen())),
                          10.horizontalSpace,
                          _buildTopIcon("assets/images/bell_icon.png", () => Get.to(NotificationScreen())),
                        ],
                      ),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.profileAndSettings.tr,
                          style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w800, fontFamily: AppFonts.jakartaBold),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.managePharmacyDetails.tr,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppFonts.jakartaMedium,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ),
                      15.verticalSpace,
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            profileType(AppStrings.personalInfo.tr, 80.w),
                            7.horizontalSpace,
                            profileType(AppStrings.legalInformation.tr, 100.w),
                            7.horizontalSpace,
                            profileType(AppStrings.documents.tr, 70.w),
                            7.horizontalSpace,
                            profileType(AppStrings.renewalStatus.tr, 90.w),
                          ],
                        ),
                      ),
                      15.verticalSpace,
                      Obx(() {
                        final type = controller.type.value;
                        if (type == AppStrings.personalInfo.tr) return PharmacyPersonalInfo();
                        if (type == AppStrings.legalInformation.tr) return LegalInformation();
                        if (type == AppStrings.documents.tr) return PharmacyDocumentScreen();
                        return PharmacyRenewalStatus();
                      }),
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

  Widget _buildTopIcon(String asset, VoidCallback onTap, {Color? color}) {
    return InkWell(
      onTap: onTap,
      child: Image.asset(asset, height: 25.h, color: color),
    );
  }

  Widget profileType(String title, double width) {
    return Obx(
          () => InkWell(
        onTap: () => controller.type.value = title,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: controller.type.value == title ? AppColors.primaryColor : AppColors.lightGrey,
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            2.verticalSpace,
            if (controller.type.value == title)
              Container(
                width: width,
                height: 3.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(7.sp),
                ),
              )
            else
              SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }
}