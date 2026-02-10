import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:patient_app/controllers/doctor_controllers/time_slot_controller.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_images.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';

class TimeSlotScreen extends StatelessWidget {
  TimeSlotScreen({super.key});
  final TimeSlotController controller = Get.put(TimeSlotController());

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
                    AppStrings.manageSchedule.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      Get.dialog(_buildCreateSlotDialog());
                    },
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 24.w,
                      ),
                    ),
                  ),
                ],
              ),
              30.verticalSpace,
              _buildDateHeader(),
              20.verticalSpace,
              _buildHorizontalDatePicker(),
              20.verticalSpace,
              _buildSlotsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateHeader() {
    return Row(
      children: [
        Obx(() => Text(
          DateFormat('MMMM yyyy').format(controller.selectedDate.value),
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            fontFamily: AppFonts.jakartaBold,
          ),
        )),
        Spacer(),
        Obx(() => Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            children: [
              Icon(
                Icons.event_available,
                color: AppColors.primaryColor,
                size: 16.w,
              ),
              5.horizontalSpace,
              Text(
                '${controller.availableSlotsCount} ${AppStrings.availableSlots.tr}',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.jakartaMedium,
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildHorizontalDatePicker() {
    return SizedBox(
      height: 100.h,
      child: Obx(() {
        final List<DateTime> dates = [];
        for (int i = 0; i < 365; i++) {
          dates.add(DateTime.now().add(Duration(days: i)));
        }

        final selectedDateValue = controller.selectedDate.value;

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: dates.length,
          itemBuilder: (context, index) {
            final date = dates[index];
            final isSelected = DateFormat('yyyy-MM-dd').format(date) ==
                DateFormat('yyyy-MM-dd').format(selectedDateValue);

            return GestureDetector(
              onTap: () {
                controller.selectedDate.value = date;
                controller.fetchSlotsForDate(date);
              },
              child: Container(
                margin: EdgeInsets.only(right: 10.w),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('E').format(date),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.jakartaMedium,
                      ),
                    ),
                    5.verticalSpace,
                    Text(
                      DateFormat('d').format(date),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: AppFonts.jakartaBold,
                      ),
                    ),
                    5.verticalSpace,
                    Text(
                      DateFormat('MMM').format(date),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppFonts.jakartaRegular,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildSlotsList() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                AppStrings.timeSlots.tr,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppFonts.jakartaBold,
                ),
              ),
              Spacer(),
              Obx(() => Text(
                DateFormat('EEEE, MMMM d').format(controller.selectedDate.value),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.sp,
                  fontFamily: AppFonts.jakartaRegular,
                ),
              )),
            ],
          ),
          10.verticalSpace,
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              } else if (controller.allSlots.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.schedule_outlined,
                        size: 80.w,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      20.verticalSpace,
                      Text(
                        AppStrings.noSlotsAvailable.tr,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppFonts.jakartaMedium,
                        ),
                      ),
                      10.verticalSpace,
                      Text(
                        'Tap + to create new slots',
                        style: TextStyle(
                          color: Colors.grey.withOpacity(0.7),
                          fontSize: 14.sp,
                          fontFamily: AppFonts.jakartaRegular,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: controller.allSlots.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final slot = controller.allSlots[index];
                    final isBooked = slot.status == 'booked';

                    return Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.all(15.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(
                          color: isBooked ? Colors.green.withOpacity(0.3) : AppColors.primaryColor.withOpacity(0.1),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.05),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                              color: isBooked ? Colors.green.withOpacity(0.1) : AppColors.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Icon(
                              isBooked ? Icons.check_circle : Icons.schedule,
                              color: isBooked ? Colors.green : AppColors.primaryColor,
                              size: 24.w,
                            ),
                          ),
                          15.horizontalSpace,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${DateFormat('hh:mm a').format(slot.startTime.toLocal())} - ${DateFormat('hh:mm a').format(slot.endTime.toLocal())}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppFonts.jakartaMedium,
                                  ),
                                ),
                                5.verticalSpace,
                                Text(
                                  'Duration: ${slot.endTime.difference(slot.startTime).inMinutes} minutes',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.sp,
                                    fontFamily: AppFonts.jakartaRegular,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isBooked)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.green,
                                    size: 16.w,
                                  ),
                                  5.horizontalSpace,
                                  Text(
                                    AppStrings.booked.tr,
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: AppFonts.jakartaMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (!isBooked)
                            InkWell(
                              onTap: () => controller.deleteTimeSlot(slot.id),
                              child: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 20.w,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateSlotDialog() {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  AppStrings.createTimeSlot.tr,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: AppFonts.jakartaBold,
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () => Get.back(),
                  child: Icon(
                    Icons.close,
                    color: Colors.grey,
                    size: 24.w,
                  ),
                ),
              ],
            ),
            20.verticalSpace,
            Text(
              AppStrings.date.tr,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: AppFonts.jakartaMedium,
              ),
            ),
            5.verticalSpace,
            Obx(() => InkWell(
              onTap: () => _showDatePicker(),
              child: Container(
                padding: EdgeInsets.all(15.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: AppColors.lightGrey.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: AppColors.primaryColor,
                      size: 20.w,
                    ),
                    10.horizontalSpace,
                    Text(
                      DateFormat('EEEE, MMMM d, yyyy').format(controller.selectedDateForSlot.value),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.sp,
                        fontFamily: AppFonts.jakartaMedium,
                      ),
                    ),
                  ],
                ),
              ),
            )),
            15.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.startTime.tr,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppFonts.jakartaMedium,
                        ),
                      ),
                      5.verticalSpace,
                      Obx(() => InkWell(
                        onTap: () => _showTimePicker(true),
                        child: Container(
                          padding: EdgeInsets.all(15.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: AppColors.lightGrey.withOpacity(0.5)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: AppColors.primaryColor,
                                size: 20.w,
                              ),
                              10.horizontalSpace,
                              Text(
                                _formatTimeOfDay(controller.startTime.value),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.sp,
                                  fontFamily: AppFonts.jakartaMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                20.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.endTime.tr,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppFonts.jakartaMedium,
                        ),
                      ),
                      5.verticalSpace,
                      Obx(() => InkWell(
                        onTap: () => _showTimePicker(false),
                        child: Container(
                          padding: EdgeInsets.all(15.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: AppColors.lightGrey.withOpacity(0.5)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: AppColors.primaryColor,
                                size: 20.w,
                              ),
                              10.horizontalSpace,
                              Text(
                                _formatTimeOfDay(controller.endTime.value),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.sp,
                                  fontFamily: AppFonts.jakartaMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
            25.verticalSpace,
            Obx(() => CustomButton(
              borderRadius: 15,
              text: controller.isCreating.value
                  ? AppStrings.creating.tr
                  : AppStrings.createSlot.tr,
              onTap: () {
                if (!controller.isCreating.value) {
                  controller.createTimeSlot();
                }
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showDatePicker() async {
    final selectedDate = await showDatePicker(
      context: Get.context!,
      initialDate: controller.selectedDateForSlot.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.primaryColor,
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      // Update both the dialog date AND the main selected date
      controller.selectedDateForSlot.value = selectedDate;
      controller.selectedDate.value = selectedDate;
    }
  }

  void _showTimePicker(bool isStartTime) async {
    final currentTime = isStartTime ? controller.startTime.value : controller.endTime.value;

    final selectedTime = await showTimePicker(
      context: Get.context!,
      initialTime: currentTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.primaryColor,
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              dialBackgroundColor: Colors.grey[50],
              hourMinuteTextColor: Colors.black,
              dayPeriodTextColor: Colors.black,
              dayPeriodColor: AppColors.primaryColor.withOpacity(0.5),
              dialHandColor: AppColors.primaryColor,
              dialTextColor: Colors.black,
              entryModeIconColor: AppColors.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      if (isStartTime) {
        controller.startTime.value = selectedTime;
        // Automatically set end time to 30 minutes after start time
        controller.endTime.value = TimeOfDay(
          hour: selectedTime.hour,
          minute: selectedTime.minute + 30,
        );
      } else {
        controller.endTime.value = selectedTime;
      }
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}

extension TimeOfDayExtension on TimeOfDay {
  int get hourOfPeriod {
    return hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
  }
}