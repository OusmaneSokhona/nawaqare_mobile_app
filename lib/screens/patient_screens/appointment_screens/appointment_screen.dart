
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/home_controller.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/patient_widgets/appointment_widgets/appointment_widget.dart';
import 'appointment_detail_screen.dart';

class AppointmentScreen extends StatelessWidget {
  AppointmentScreen({super.key});

  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.onboardingBackground, Colors.white,],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              70.verticalSpace,
              Row(
                children: [
                  InkWell(
                    onTap: (){
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
                    "Appointments",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              20.verticalSpace,
              Container(
                height: 55.h,
                width: 1.sw,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.sp),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                          () => InkWell(
                        onTap: () {
                          homeController.appointmentType.value =
                          "upcoming";
                        },
                        child: Container(
                          height: 55.h,
                          width: 0.455.sw,
                          decoration: BoxDecoration(
                            color:
                            homeController.appointmentType.value ==
                                "upcoming"
                                ? AppColors.primaryColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14.sp),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Upcoming",
                            style: TextStyle(
                              color:
                              homeController.appointmentType.value ==
                                  "upcoming"
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppFonts.jakartaMedium,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Obx(
                          () => InkWell(
                        onTap: () {
                          homeController.appointmentType.value = "past";
                        },
                        child: Container(
                          height: 55.h,
                          width: 0.455.sw,
                          decoration: BoxDecoration(
                            color:
                            homeController.appointmentType.value ==
                                "past"
                                ? AppColors.primaryColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14.sp),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Past",
                            style: TextStyle(
                              color:
                              homeController.appointmentType.value ==
                                  "past"
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppFonts.jakartaMedium,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              10.verticalSpace,
              Obx(
                    ()=> homeController.appointmentType.value=="upcoming"?
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 20.h,bottom: 20.h),
                    itemCount: homeController.doctorList.length,
                    itemBuilder: (context, index) {
                      return AppointmentWidget(
                        onTap: (){Get.to(AppointmentDetailScreen(appointmentModel: homeController.doctorList[index]));},
                        appointmentModel: homeController.doctorList[index],
                      );
                    },
                  ),
                ): Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 20.h,bottom: 20.h),
                    itemCount: homeController.doctorList.length,
                    itemBuilder: (context, index) {
                      return AppointmentWidget(
                        isCompleted: true,
                        onTap: (){Get.to(AppointmentDetailScreen(isCompleted: true,appointmentModel: homeController.doctorList[index]));},
                        appointmentModel: homeController.doctorList[index],
                      );
                    },
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
