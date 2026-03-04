import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/appointment_controllers/appointment_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../../widgets/patient_widgets/appointment_widgets/appointment_widget.dart';
import 'appointment_detail_screen.dart';

class AppointmentScreen extends StatelessWidget {
  AppointmentScreen({super.key});

  final AppointmentController appointmentController = Get.put(AppointmentController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      appointmentController.fetchAppointments();
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
              70.verticalSpace,
              Row(
                children: [
                  InkWell(
                    onTap: () {Get.back();},
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
                      '${appointmentController.totalCount}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  )),
                  10.horizontalSpace,
                  Obx(() => appointmentController.isLoading.value
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
                    onTap: () => appointmentController.refreshAppointments(),
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
                    _buildTabButton("upcoming", AppStrings.upcoming.tr),
                    _buildTabButton("past", AppStrings.past.tr),
                  ],
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (appointmentController.isLoading.value &&
                      appointmentController.currentList.isEmpty) {
                    return _buildLoadingState();
                  }

                  var list = appointmentController.paginatedList;
                  bool isPast = appointmentController.appointmentType.value == "past";

                  if (list.isEmpty) {
                    return _buildEmptyState(isPast);
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      await appointmentController.refreshAppointments();
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return AppointmentWidget(
                          isCompleted: isPast,
                          onTap: () {
                            Get.to(AppointmentDetailScreen(
                              isCompleted: isPast,
                              appointment: list[index],
                            ));
                          },
                          appointment: list[index],
                        );
                      },
                    ),
                  );
                }),
              ),
              Obx(() {
                if (appointmentController.currentList.isEmpty) {
                  return SizedBox();
                }
                return Column(
                  children: [
                    10.verticalSpace,
                    _buildPagination(),
                    20.verticalSpace,
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
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
    );
  }

  Widget _buildEmptyState(bool isPast) {
    return Center(
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
            onPressed: () => appointmentController.refreshAppointments(),
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
    );
  }

  Widget _buildTabButton(String type, String label) {
    return Obx(
          () => InkWell(
        onTap: () {
          appointmentController.appointmentType.value = type;
          appointmentController.currentPage.value = 1;
        },
        child: Container(
          height: 55.h,
          width: 0.455.sw,
          decoration: BoxDecoration(
            color: appointmentController.appointmentType.value == type
                ? AppColors.primaryColor
                : Colors.white,
            borderRadius: BorderRadius.circular(14.sp),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: appointmentController.appointmentType.value == type
                  ? Colors.white
                  : Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.jakartaMedium,
            ),
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
            if (appointmentController.currentPage.value > 1) {
              appointmentController.currentPage.value--;
            }
          }),
          15.horizontalSpace,
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(appointmentController.totalPages, (index) {
                  int page = index + 1;
                  return GestureDetector(
                    onTap: () => appointmentController.currentPage.value = page,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text(
                        "$page",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: AppFonts.jakartaMedium,
                          fontWeight: FontWeight.w600,
                          color: appointmentController.currentPage.value == page
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
            if (appointmentController.currentPage.value < appointmentController.totalPages) {
              appointmentController.currentPage.value++;
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