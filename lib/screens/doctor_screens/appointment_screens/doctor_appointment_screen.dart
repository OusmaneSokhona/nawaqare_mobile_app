import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_appoinment_controller.dart';
import 'package:patient_app/screens/doctor_screens/appointment_screens/doctor_appointment_detail.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import 'package:patient_app/widgets/doctor_widgets/appointment_widgets/doctor_appoinment_widget.dart';
import 'package:patient_app/widgets/doctor_widgets/appointment_widgets/schedular_widget.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';

class DoctorAppointmentScreen extends StatelessWidget {
  DoctorAppointmentScreen({super.key});

  final DoctorAppointmentController controller = Get.put(
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
                    AppStrings.appointments.tr,
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
                                  controller.currentPage.value = 1;
                                },
                                child: Container(
                                  height: 55.h,
                                  width: 0.455.sw,
                                  decoration: BoxDecoration(
                                    color: controller.appointmentType.value ==
                                        "upcoming"
                                        ? AppColors.primaryColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(14.sp),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${AppStrings.upcoming.tr}(${controller.patientList.length})",
                                    style: TextStyle(
                                      color: controller.appointmentType.value ==
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
                                  controller.currentPage.value = 1;
                                },
                                child: Container(
                                  height: 55.h,
                                  width: 0.455.sw,
                                  decoration: BoxDecoration(
                                    color: controller.appointmentType.value ==
                                        "past"
                                        ? AppColors.primaryColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(14.sp),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${AppStrings.past.tr}(${controller.postPatientList.length})",
                                    style: TextStyle(
                                      color: controller.appointmentType.value ==
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
                            () => controller.appointmentType.value == "upcoming"
                            ? SchedulerWidget()
                            : CustomTextField(
                          labelText: "",
                          hintText: AppStrings.searchPatientHint.tr,
                          prefixIcon: Icons.search,
                          suffixIcon: Icons.filter_list,
                        ),
                      ),
                      Obx(
                            () {
                          var list = controller.paginatedList;
                          bool isPast =
                              controller.appointmentType.value == "past";
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(
                              top: 20.h,
                              bottom: 20.h,
                            ),
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return DoctorAppoinmentWidget(
                                isCompleted: isPast,
                                onTap: () {
                                  Get.to(
                                    DoctorAppointmentDetail(
                                      isCompleted: isPast,
                                      appointmentModel: list[index],
                                    ),
                                  );
                                },
                                appointmentModel: list[index],
                              );
                            },
                          );
                        },
                      ),
                      _buildPagination(),
                      20.verticalSpace,
                      Obx(
                            () => controller.appointmentType.value == "upcoming"
                            ? CustomButton(
                          borderRadius: 15,
                          text: AppStrings.addAppointment.tr,
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

  Widget _buildPagination() {
    return Obx(
          () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _paginationArrow(Icons.arrow_back, () {
            if (controller.currentPage.value > 1) {
              controller.currentPage.value--;
            }
          }),
          15.horizontalSpace,
          ...List.generate(controller.totalPages, (index) {
            int page = index + 1;
            return GestureDetector(
              onTap: () => controller.currentPage.value = page,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  "$page",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: AppFonts.jakartaMedium,
                    fontWeight: FontWeight.w600,
                    color: controller.currentPage.value == page
                        ? AppColors.primaryColor
                        : Colors.grey,
                  ),
                ),
              ),
            );
          }),
          15.horizontalSpace,
          _paginationArrow(Icons.arrow_forward, () {
            if (controller.currentPage.value < controller.totalPages) {
              controller.currentPage.value++;
            }
          }),
        ],
      ),
    );
  }

  Widget _paginationArrow(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 17.h,
          color: Colors.black,
        ),
      ),
    );
  }
}