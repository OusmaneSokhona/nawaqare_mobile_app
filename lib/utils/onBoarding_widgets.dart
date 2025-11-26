import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/on_boarding_splash_controllers/on_boarding_controller.dart';
import 'app_colors.dart';
import 'app_fonts.dart';

class OnboardingWidgets extends StatelessWidget {
  OnBoardingController onBoardingController;
  List<String> pointList = [];
   OnboardingWidgets({super.key,required this.onBoardingController});

  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: PageView.builder(
        onPageChanged: onBoardingController.onPageChanged,
        controller: onBoardingController.pageController,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: onBoardingController.onBoardingPages.length,
        itemBuilder: (context, index) {
          if (onBoardingController.onBoardingPages[index].points !=
              null) {
            pointList =
            onBoardingController.onBoardingPages[index].points!;
          }
          return Column(
            children: [
              Image.asset(
                onBoardingController.onBoardingPages[index].image,
                height: 210.h,
              ),
              40.verticalSpace,
              Text(
                onBoardingController.onBoardingPages[index].title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontFamily: AppFonts.jakartaBold,
                ),
              ),
              10.verticalSpace,
              onBoardingController.onBoardingPages[index].subtitle !=
                  null
                  ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  onBoardingController
                      .onBoardingPages[index]
                      .subtitle!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: AppFonts.jakartaRegular,
                  ),
                ),
              )
                  : SizedBox(),
              pointList != null
                  ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Column(
                  children: List.generate(pointList.length, (
                      index,
                      ) {
                    return Padding(
                      padding: EdgeInsets.only(
                        top: 5.h,
                        left: 30.w,
                      ),
                      child: Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.primaryColor,
                            size: 20.sp,
                          ),
                          10.horizontalSpace,
                          Text(
                            pointList[index],
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontFamily: AppFonts.jakartaRegular,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              )
                  : SizedBox(),
            ],
          );
        },
      ),
    );
  }
}
