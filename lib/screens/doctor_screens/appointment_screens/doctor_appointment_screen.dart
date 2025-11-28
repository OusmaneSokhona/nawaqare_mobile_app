import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_appoinment_controller.dart';
import 'package:patient_app/screens/doctor_screens/appointment_screens/doctor_appointment_detail.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import 'package:patient_app/widgets/doctor_widgets/appointment_widgets/doctor_appoinment_widget.dart';
import 'package:patient_app/widgets/doctor_widgets/appointment_widgets/filtter_bottom_sheet.dart';
import 'package:patient_app/widgets/doctor_widgets/appointment_widgets/schedular_widget.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/patient_widgets/appointment_widgets/appointment_widget.dart';
import '../../patient_screens/appointment_screens/appointment_detail_screen.dart';

class DoctorAppointmentScreen extends StatelessWidget {
  DoctorAppointmentScreen({super.key});

  DoctorAppointmentController controller = Get.put(
    DoctorAppointmentController(),
  );

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
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              50.verticalSpace,
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
              10.verticalSpace,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
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
                                  controller.appointmentType.value = "upcoming";
                                },
                                child: Container(
                                  height: 55.h,
                                  width: 0.455.sw,
                                  decoration: BoxDecoration(
                                    color:
                                        controller.appointmentType.value ==
                                                "upcoming"
                                            ? AppColors.primaryColor
                                            : Colors.white,
                                    borderRadius: BorderRadius.circular(14.sp),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Upcoming(${controller.patientList.length})",
                                    style: TextStyle(
                                      color:
                                          controller.appointmentType.value ==
                                                  "upcoming"
                                              ? Colors.white
                                              : Colors.black,
                                      fontSize: 16.sp,
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
                                  controller.appointmentType.value = "past";
                                },
                                child: Container(
                                  height: 55.h,
                                  width: 0.455.sw,
                                  decoration: BoxDecoration(
                                    color:
                                        controller.appointmentType.value ==
                                                "past"
                                            ? AppColors.primaryColor
                                            : Colors.white,
                                    borderRadius: BorderRadius.circular(14.sp),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Past(${controller.patientList.length})",
                                    style: TextStyle(
                                      color:
                                          controller.appointmentType.value ==
                                                  "past"
                                              ? Colors.white
                                              : Colors.black,
                                      fontSize: 16.sp,
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
                        () =>
                            controller.appointmentType.value == "upcoming"
                                ? SchedulerWidget()
                                : CustomTextField(
                                  labelText: "",
                                  hintText: "Search by patient name...",
                                  prefixIcon: Icons.search,
                                  suffixIcon: Icons.filter_list,
                                ),
                      ),
                      Obx(
                        () =>
                            controller.appointmentType.value == "upcoming"
                                ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.only(
                                    top: 20.h,
                                    bottom: 20.h,
                                  ),
                                  itemCount: controller.patientList.length,
                                  itemBuilder: (context, index) {
                                    return DoctorAppoinmentWidget(
                                      onTap: () {
                                        Get.to(
                                          DoctorAppointmentDetail(
                                            appointmentModel:
                                                controller.patientList[index],
                                          ),
                                        );
                                      },
                                      appointmentModel:
                                          controller.patientList[index],
                                    );
                                  },
                                )
                                : ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.only(
                                    top: 20.h,
                                    bottom: 20.h,
                                  ),
                                  itemCount: controller.postPatientList.length,
                                  itemBuilder: (context, index) {
                                    return DoctorAppoinmentWidget(
                                      isCompleted: true,
                                      onTap: () {
                                        Get.to(
                                          DoctorAppointmentDetail(
                                            isCompleted: true,
                                            appointmentModel:
                                                controller.patientList[index],
                                          ),
                                        );
                                      },
                                      appointmentModel:
                                          controller.postPatientList[index],
                                    );
                                  },
                                ),
                      ),
                      Obx(
                        () =>
                            controller.appointmentType.value == "upcoming"
                                ? CustomButton(
                                  borderRadius: 15,
                                  text: "Add Appointment",
                                  onTap: () {},
                                )
                                : SizedBox(),
                      ),
                      20.verticalSpace,
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
