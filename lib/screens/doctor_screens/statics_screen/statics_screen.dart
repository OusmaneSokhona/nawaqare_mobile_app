import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/doctor_screens/statics_screen/report_screen.dart';
import 'package:patient_app/screens/doctor_screens/statics_screen/review_screen.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/doctor_widgets/statics_widgets/engagement_card.dart';

class StaticsScreen extends StatelessWidget {
  const StaticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.onboardingBackground, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              70.verticalSpace,
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Image.asset(
                      AppImages.backIcon,
                      height: 33.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    AppStrings.statistics.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              30.verticalSpace,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // These appear to be demo charts - ideally these would be localized
                      // or generated via a library like fl_chart in the future
                      Image.asset("assets/demo_images/d_1.png"),
                      Image.asset("assets/demo_images/d_2.png"),
                      10.verticalSpace,
                      Image.asset("assets/demo_images/d_3.png"),
                      20.verticalSpace,
                      Image.asset("assets/demo_images/d_4.png"),
                      20.verticalSpace,
                      Image.asset("assets/demo_images/d_5.png"),
                      20.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.patientEngagement.tr,
                          style: TextStyle(
                            fontSize: 19.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      EngagementCard(
                        onTap: () {},
                        icon: Icons.access_time,
                        title: AppStrings.avgResponseTime.tr,
                        value: '2h 14m',
                        showLink: false,
                      ),
                      EngagementCard(
                        icon: Icons.star_border,
                        title: AppStrings.avgSatisfaction.tr,
                        value: '4.7 ⭐',
                        linkText: AppStrings.viewPatientReviews.tr,
                        showLink: true,
                        onTap: () {
                          Get.to(ReviewScreen());
                        },
                      ),
                      EngagementCard(
                        onTap: () {},
                        icon: Icons.message,
                        title: AppStrings.messagesSentReceived.tr,
                        value: '120 / 98',
                        showLink: false,
                      ),
                      EngagementCard(
                        onTap: () {},
                        icon: Icons.checklist,
                        title: AppStrings.patientsWithoutFollowUp.tr,
                        value: '5',
                        linkText: AppStrings.viewPatientList.tr,
                        showLink: true,
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.complianceRecords.tr,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: ComplianceCard(
                              icon: Icons.description,
                              title: AppStrings.dmpDocuments.tr,
                              value: '04',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ComplianceCard(
                              icon: Icons.edit,
                              title: AppStrings.validSignatures.tr,
                              value: '02',
                            ),
                          ),
                        ],
                      ),
                      20.verticalSpace,
                      Image.asset("assets/demo_images/d_7.png"),
                      Container(
                        height: 40.h,
                        width: 1.sw,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.sp),
                          border: Border.all(
                            color: AppColors.lightGrey.withOpacity(0.3),
                          ),
                          color: AppColors.orange.withOpacity(0.3),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 6.h),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/explanation_icon.png",
                              height: 35.sp,
                            ),
                            5.horizontalSpace,
                            Text(
                              AppStrings.hdsDataStandard.tr,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      20.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.exportMonthlyReport.tr,
                        onTap: () {
                          Get.to(const ReportScreen());
                        },
                      ),
                      30.verticalSpace,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}