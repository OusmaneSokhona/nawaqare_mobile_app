import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/doctor_screens/statics_screen/review_screen.dart';
import 'package:patient_app/widgets/custom_button.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';

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
                    "Statics",
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
                      Image.asset("assets/demo_images/d_1.png"),
                      Image.asset("assets/demo_images/d_2.png"),
                      10.verticalSpace,
                      Image.asset("assets/demo_images/d_3.png"),
                      20.verticalSpace,
                      Image.asset("assets/demo_images/d_4.png"),
                      20.verticalSpace,
                      Image.asset("assets/demo_images/d_5.png"),
                      20.verticalSpace,
                      Image.asset("assets/demo_images/d_6.png"),
                      20.verticalSpace,
                      Image.asset("assets/demo_images/d_1.png"),
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
                        padding: EdgeInsets.symmetric(horizontal: 15.sp,vertical: 6.h),
                        child: Row(
                          children: [
                           Image.asset("assets/images/explanation_icon.png",height: 35.sp,),
                            5.horizontalSpace,
                            Text("Data stored under HDS standards",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w400,color: Colors.black),),
                          ],
                        ),
                      ),
                      20.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: "Export Monthly Report",
                        onTap: () {
                          Get.to(ReviewScreen());
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
