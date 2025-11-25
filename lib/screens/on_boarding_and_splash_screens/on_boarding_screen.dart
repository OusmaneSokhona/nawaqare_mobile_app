import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/onBoarding_widgets.dart';
import 'package:patient_app/widgets/custom_small_button.dart';

import '../../controllers/patient_controllers/on_boarding_splash_controllers/on_boarding_controller.dart';

class OnBoardingScreen extends StatelessWidget {
  OnBoardingScreen({super.key});

  OnBoardingController onBoardingController = Get.put(OnBoardingController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: 1.sh,
        width: 1.sw,
        color: AppColors.onboardingBackground,
        child: Column(
          children: [
            120.verticalSpace,
Obx(()=>onBoardingController.currentPageIndex.value<3?OnboardingWidgets(onBoardingController: onBoardingController):SizedBox()),
            20.verticalSpace,
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onBoardingController.onBoardingPages.length,
                  (index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.sp),
                      child: Container(
                        height: 10.h,
                        width:
                            onBoardingController.currentPageIndex.value == index
                                ? 25.w
                                : 10.w,
                        decoration: BoxDecoration(
                          color:
                              onBoardingController.currentPageIndex.value ==
                                      index
                                  ? AppColors.primaryColor
                                  : AppColors.secondryColor,
                          borderRadius:
                              onBoardingController.currentPageIndex.value ==
                                      index
                                  ? BorderRadius.circular(5.r)
                                  : BorderRadius.circular(10.r),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            50.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      onBoardingController.skipPage();
                    },
                    child: Text(
                      "Skip",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontFamily: AppFonts.jakartaMedium,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  CustomSmallButton(
                    borderRadius: 17,
                    text: "Next",
                    onTap: () {
                      onBoardingController.nextPage();
                    },
                  ),
                ],
              ),
            ),
            70.verticalSpace,
          ],
        ),
      ),
    );
  }
}
