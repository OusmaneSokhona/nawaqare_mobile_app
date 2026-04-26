import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_home_controller.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_profile_controller.dart';
import 'package:patient_app/main.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/doctor_widgets/profile_widgets/doctor_documents.dart';
import 'package:patient_app/widgets/doctor_widgets/profile_widgets/doctor_personal_info.dart';
import 'package:patient_app/widgets/doctor_widgets/profile_widgets/doctor_professional_info.dart';
import 'package:patient_app/widgets/doctor_widgets/profile_widgets/revalidation.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../patient_screens/notifications_screens/notifications_screen.dart';
import '../../help_center_screen.dart';

class DoctorProfileScreen extends StatelessWidget {
  DoctorProfileScreen({super.key});
  final DoctorProfileController controller = Get.put(DoctorProfileController());
  final DoctorHomeController homeController = Get.find<DoctorHomeController>();

  @override
  Widget build(BuildContext context) {
    controller.scrollChange();
    return Scaffold(
      body: Obx(() {
        final doctor = homeController.currentUser.value;
        final doctorName = doctor?.fullName ?? 'Dr. Alex';
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
                final bool isScrolledPastThreshold = isWeb?controller.scrollValue.value >= 120:controller.scrollValue.value >= 280;
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
                        backgroundImage: doctorImage != null && doctorImage.isNotEmpty
                            ? NetworkImage(doctorImage)
                            : const AssetImage("assets/demo_images/doctor_1.png")
                        as ImageProvider,
                      ),
                      20.horizontalSpace,
                      Text(
                        doctorName,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: AppFonts.jakartaBold,
                          fontSize: 19.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding:  EdgeInsets.only(bottom: 4.sp),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => HelpCenterScreen());
                          },
                          child: Image.asset(
                            "assets/images/help_center_icon.png",
                            height: 25.h,
                          ),
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
                              backgroundImage: doctorImage != null && doctorImage.isNotEmpty
                                  ? NetworkImage(doctorImage)
                                  : const AssetImage("assets/demo_images/doctor_1.png")
                              as ImageProvider,
                            ),
                            const Spacer(),
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
                            AppStrings.profile.tr,
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
                          child: Obx(
                                ()=> Text(
                              controller.type.value == "Personal Info"?AppStrings.managePersonalInfo.tr:controller.type.value == "Professional Info"?AppStrings.professionalCredentialsDetails.tr:controller.type.value == "Documents"?AppStrings.officialDocumentsVerification.tr:AppStrings.revalidateStatusNote.tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppFonts.jakartaMedium,
                                color: AppColors.darkGrey,
                              ),
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
                                profileType(AppStrings.personalInfo, 65.w, "Personal Info"),
                                9.horizontalSpace,
                                profileType(AppStrings.professionalInfo, 80.w, "Professional Info"),
                                9.horizontalSpace,
                                profileType(AppStrings.documents, 55.w, "Documents"),
                                9.horizontalSpace,
                                profileType(AppStrings.revalidation, 60.w, "Revalidation"),
                              ],
                            ),
                          ),
                        ),
                        15.verticalSpace,
                        Obx(
                              () => controller.type.value == "Personal Info"
                              ? DoctorPersonalInfo()
                              : controller.type.value == "Professional Info"
                              ? DoctorProfessionalInfo()
                              : controller.type.value == "Documents"
                              ? DoctorDocuments()
                              : Revalidation(),
                        ),
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

  Widget profileType(String title, double width, String value) {
    return Obx(
          () => InkWell(
        onTap: () {
          controller.type.value = value;
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title.tr,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: controller.type.value == value
                    ? AppColors.primaryColor
                    : AppColors.lightGrey,
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            2.verticalSpace,
            controller.type.value == value
                ? Container(
              width: width.w,
              height: 3.h,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(7.sp),
              ),
            )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}