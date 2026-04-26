import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_appoinment_controller.dart';
import 'package:patient_app/screens/doctor_screens/appointment_screens/doctor_add_appointment_screen.dart';
import 'package:patient_app/screens/doctor_screens/appointment_screens/doctor_appointment_detail.dart';
import 'package:patient_app/utils/appointment_status.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import 'package:patient_app/widgets/doctor_widgets/appointment_widgets/doctor_appoinment_widget.dart';
import 'package:patient_app/widgets/doctor_widgets/appointment_widgets/schedular_widget.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../services/api_service.dart';
import '../../../utils/api_urls.dart';

class DoctorAppointmentScreen extends StatelessWidget {
  DoctorAppointmentScreen({super.key});

  final DoctorAppointmentController controller = Get.put(DoctorAppointmentController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchDoctorAppointments();
    });
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
                  Spacer(),
                  Obx(() => Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      '${controller.totalCount}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  )),
                  10.horizontalSpace,
                  Obx(() => controller.isLoading.value
                      ? Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  )
                      : InkWell(
                    onTap: () => controller.refreshAppointments(),
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 20.h,
                      ),
                    ),
                  )),
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
                                    "${AppStrings.upcoming.tr}(${controller.upcomingAppointments.length})",
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
                                    "${AppStrings.past.tr}(${controller.pastAppointments.length})",
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
                            : Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                labelText: "",
                                hintText: AppStrings.searchPatientHint.tr,
                                prefixIcon: Icons.search,
                                onChanged: (value) {
                                  controller.searchPatients(value);
                                },
                              ),
                            ),
                            10.horizontalSpace,
                            Padding(
                              padding:  EdgeInsets.only(top: 22.h),
                              child: InkWell(
                                onTap: () {
                                  controller.showFilterBottomSheet();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(12.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Icon(
                                    Icons.filter_list,
                                    color: Colors.white,
                                    size: 24.h,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(
                            () {
                          if (controller.isLoading.value && controller.currentList.isEmpty) {
                            return _buildLoadingState();
                          }

                          var list = controller.paginatedList;
                          bool isPast = controller.appointmentType.value == "past";

                          if (list.isEmpty) {
                            return _buildEmptyState(isPast);
                          }

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
                                isCancelled: list[index].status==AppointmentStatus.CANCELLED?true:false,
                                onTapCancel: (){
                                  showCancelConfirmationDialog(list[index].id);
                                },
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
                      Obx(() {
                        if (controller.currentList.isEmpty) {
                          return SizedBox();
                        }
                        return _buildPagination();
                      }),
                      20.verticalSpace,
                      Obx(
                            () => controller.appointmentType.value == "upcoming"
                            ? CustomButton(
                          borderRadius: 15,
                          text: AppStrings.addAppointment.tr,
                          onTap: () {
                            // When navigating to add appointment, we'll refresh when coming back
                            Get.to(() => DoctorAddAppointmentScreen())?.then((_) {
                              // This will execute when returning from the add appointment screen
                              controller.refreshAppointments();
                            });
                          },
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

  Widget _buildLoadingState() {
    return Container(
      height: 200.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
            20.verticalSpace,
            Text(
              'Loading appointments...',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isPast) {
    return Container(
      height: 300.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 80.h,
              color: Colors.grey.shade300,
            ),
            20.verticalSpace,
            Text(
              isPast ? 'No past appointments' : 'No upcoming appointments',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            10.verticalSpace,
            Text(
              'You don\'t have any ${isPast ? 'past' : 'upcoming'} appointments',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
            30.verticalSpace,
            ElevatedButton(
              onPressed: () => controller.refreshAppointments(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
              ),
              child: Text(
                'Refresh',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
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
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(controller.totalPages, (index) {
                  int page = index + 1;
                  return GestureDetector(
                    onTap: () => controller.currentPage.value = page,
                    child: Container(
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
              ),
            ),
          ),
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

  void showCancelConfirmationDialog(String appointmentId) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          "Cancel Appointment",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Do you really want to cancel this appointment?",
          style: TextStyle(fontSize: 16.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "No",
              style: TextStyle(color: Colors.grey, fontSize: 16.sp),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.updateAppointmentStatus(appointmentId, AppointmentStatus.CANCELLED,false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              "Yes, Cancel",
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
            ),
          ),
        ],
      ),
    );
  }
}