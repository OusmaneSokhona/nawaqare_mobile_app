import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/calender_controller.dart';
import 'package:patient_app/screens/doctor_screens/reception_screens/view_as_patient.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:patient_app/widgets/doctor_widgets/reception_widgets/edit_day_drawer.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';

class CalenderScreen extends StatelessWidget {
  CalenderScreen({super.key});

  final CalenderController controller = Get.put(CalenderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      endDrawer: EditDayDrawer(),
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
                      "assets/images/back_icon.png",
                      height: 22.h,
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    AppStrings.calendar.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Obx(
                        () => Column(
                      children: [
                        20.verticalSpace,
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildLegendItem(AppColors.green, AppStrings.available.tr, controller.availableSlotsCount),
                              _buildLegendItem(Colors.red, AppStrings.cancelled.tr, controller.cancelledSlotsCount),
                              _buildLegendItem(AppColors.primaryColor, AppStrings.booked.tr, controller.bookedSlotsCount),
                            ],
                          ),
                        ),
                        20.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.selectDate.tr,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0),
                              decoration: BoxDecoration(
                                color: AppColors.lightGrey.withOpacity(0.1),
                                border: Border.all(color: AppColors.lightGrey.withOpacity(0.2)),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: Obx(
                                      () => DropdownButton<String>(
                                    value: controller.selectedDuration.value,
                                    icon: Icon(Icons.keyboard_arrow_down, color: AppColors.lightGrey),
                                    items: [
                                      DropdownMenuItem<String>(
                                        value: 'daily',
                                        child: Text(AppStrings.daily.tr),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: 'weekly',
                                        child: Text(AppStrings.weekly.tr),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: 'monthly',
                                        child: Text(AppStrings.monthly.tr),
                                      ),
                                    ],
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        controller.selectedDuration.value = newValue;
                                      }
                                    },
                                    dropdownColor: Colors.white,
                                    isExpanded: false,
                                    hint: Text(_getDisplayValue(controller.selectedDuration.value)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Obx(() => CalendarDatePicker2(
                            config: _buildCalendarConfig(),
                            value: [controller.selectedDate.value],
                            onValueChanged: (dates) {
                              if (dates.isNotEmpty && dates.first != null) {
                                controller.selectNewDate(dates.first!);
                              }
                            },
                          )),
                        ),
                        SizedBox(height: 24.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.availableTimes.tr,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Obx(() => Text(
                              '${controller.availableSlotsCount} slots',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Obx(() {
                          if (controller.isLoading.value) {
                            return Container(
                              height: 200.h,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            );
                          } else if (controller.availableTimes.isEmpty) {
                            return Container(
                              height: 100.h,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.schedule_outlined,
                                      size: 40.w,
                                      color: Colors.grey.withOpacity(0.5),
                                    ),
                                    10.verticalSpace,
                                    Text(
                                      'No available slots',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return GridView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: controller.availableTimes.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 2.5,
                                  crossAxisSpacing: 10.w,
                                  mainAxisSpacing: 10.h
                              ),
                              itemBuilder: (context, index) {
                                return _buildTimeSlot(
                                    controller.availableTimes[index],
                                    controller.getSlotIdByTime(controller.availableTimes[index]),
                                    true
                                );
                              },
                            );
                          }
                        }),
                        20.verticalSpace,
                        if (controller.bookedTimes.isNotEmpty) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Booked Times',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              Obx(() => Text(
                                '${controller.bookedSlotsCount} slots',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              )),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: controller.bookedTimes.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 2.5,
                                crossAxisSpacing: 10.w,
                                mainAxisSpacing: 10.h
                            ),
                            itemBuilder: (context, index) {
                              return _buildTimeSlot(
                                  controller.bookedTimes[index],
                                  controller.getSlotIdByTime(controller.bookedTimes[index]),
                                  false,
                                  isBooked: true
                              );
                            },
                          ),
                          20.verticalSpace,
                        ],
                        if (controller.cancelledTimes.isNotEmpty) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Cancelled Times',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              Obx(() => Text(
                                '${controller.cancelledSlotsCount} slots',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              )),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: controller.cancelledTimes.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 2.5,
                                crossAxisSpacing: 10.w,
                                mainAxisSpacing: 10.h
                            ),
                            itemBuilder: (context, index) {
                              return _buildTimeSlot(
                                  controller.cancelledTimes[index],
                                  controller.getSlotIdByTime(controller.cancelledTimes[index]),
                                  false,
                                  isCancelled: true
                              );
                            },
                          ),
                          20.verticalSpace,
                        ],
                        20.verticalSpace,
                        CustomButton(
                            borderRadius: 15,
                            text: AppStrings.editDay.tr,
                            onTap: () {
                              controller.clearForm();
                              controller.scaffoldKey.currentState!.openEndDrawer();
                            }
                        ),
                        // 10.verticalSpace,
                        // CustomButton(
                        //   borderRadius: 15,
                        //   text: AppStrings.viewAsPatient.tr,
                        //   onTap: () {
                        //     Get.to(ViewAsPatient());
                        //   },
                        //   bgColor: AppColors.inACtiveButtonColor,
                        //   fontColor: Colors.black,
                        // ),
                        30.verticalSpace,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDisplayValue(String value) {
    switch (value) {
      case 'daily':
        return AppStrings.daily.tr;
      case 'weekly':
        return AppStrings.weekly.tr;
      case 'monthly':
        return AppStrings.monthly.tr;
      default:
        return value;
    }
  }

  CalendarDatePicker2Config _buildCalendarConfig() {
    return CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.single,
      currentDate: controller.initialDate.value,
      weekdayLabelTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      selectedDayTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 14.sp,
      ),
      selectedDayHighlightColor: AppColors.primaryColor,
      dayTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 14.sp,
      ),
      selectedRangeDayTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 14.sp,
      ),
      todayTextStyle: TextStyle(
        color: AppColors.primaryColor,
        fontWeight: FontWeight.w500,
      ),
      controlsTextStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryColor,
      ),
      controlsHeight: 40.h,
      dayBuilder: ({
        DateTime? date,
        TextStyle? textStyle,
        BoxDecoration? decoration,
        bool? isSelected,
        bool? isDisabled,
        bool? isToday,
      }) {
        if (date == null) return null;
        final isSelectedDay = isSelected ?? false;
        final day = date.day.toString();

        return Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 2.w),
          width: 38.w,
          height: 38.h,
          decoration: BoxDecoration(
            color: isSelectedDay ? AppColors.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            day,
            style: TextStyle(
              color: isSelectedDay ? Colors.white : (isDisabled == true ? Colors.grey : Colors.black),
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
        );
      },
    );
  }

  Widget _buildLegendItem(Color color, String label, int count) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 10.sp, color: color),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              '$label ($count)',
              style: TextStyle(fontSize: 12.sp, color: Colors.black87),
            ),
          ),
          SizedBox(width: 12.w),
        ],
      ),
    );
  }

  Widget _buildTimeSlot(String time, String slotId, bool isAvailable, {bool isBooked = false, bool isCancelled = false}) {
    return Obx(
          () {
        final isSelected = controller.selectedTime.value == time;
        final isDeleting = controller.isDeleting.value;

        Color bgColor = Colors.white;
        Color textColor = Colors.black87;
        Color borderColor = Colors.grey.shade300;

        if (isBooked) {
          bgColor = AppColors.primaryColor.withOpacity(0.1);
          textColor = AppColors.primaryColor;
          borderColor = AppColors.primaryColor.withOpacity(0.3);
        } else if (isCancelled) {
          bgColor = Colors.red.withOpacity(0.1);
          textColor = Colors.red;
          borderColor = Colors.red.withOpacity(0.3);
        } else if (isAvailable) {
          if (isSelected) {
            bgColor = AppColors.primaryColor;
            textColor = Colors.white;
            borderColor = AppColors.primaryColor;
          }
        }

        return GestureDetector(
          onTap: () {
            if (isAvailable && !isDeleting) {
              controller.selectNewTime(time);
            }
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: borderColor,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    time,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
              if (isAvailable && slotId.isNotEmpty)
                Positioned(
                  top: -10,
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      print("object");
                      if (!isDeleting) {
                        controller.deleteTimeSlot(slotId);
                      }
                    },
                    child: Container(
                      width: 22.w,
                      height: 22.h,
                      decoration: BoxDecoration(
                        color: isDeleting ? Colors.grey : Colors.red.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: isDeleting && controller.deletingSlotId.value == slotId
                          ? Padding(
                        padding: EdgeInsets.all(4.w),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 17.sp,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}