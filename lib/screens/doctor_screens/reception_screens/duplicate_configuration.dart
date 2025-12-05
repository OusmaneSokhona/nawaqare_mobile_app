import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/duplicate_configuration_controller.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/custom_radio_tile.dart';
import 'package:patient_app/widgets/patient_widgets/video_call_widgets/setting%20widgets.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';

class DuplicateConfiguration extends StatelessWidget {
  DuplicateConfiguration({super.key});

  DuplicateConfigurationController controller = Get.put(
    DuplicateConfigurationController(),
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
                    "Duplicate Configuration",
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
                  child: Column(
                    children: [
                      10.verticalSpace,
                      CustomDropdown(
                        label: "Duplicate for",
                        options: [
                          "Next Week",
                          "This Week",
                          "This Month",
                          "Next Month",
                        ],
                        currentValue: controller.selectedDuration.value,
                        onChanged: (_) {},
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Select days to duplicate",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18.sp,
                            fontFamily: AppFonts.jakartaMedium,
                          ),
                        ),
                      ),
                      5.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(controller.daysList.length, (
                          index,
                        ) {
                          final day = controller.daysList[index];
                          return Obx(() {
                            if (controller.daysList.isEmpty) {
                              return SizedBox();
                            }

                            final isSelected = controller.selectedDays.contains(
                              day,
                            );

                            return InkWell(
                              onTap: () {
                                if (isSelected) {
                                  controller.selectedDays.remove(day);
                                } else {
                                  controller.selectedDays.add(day);
                                }
                                print("${controller.selectedDays}");
                              },
                              child: Container(
                                height: 47.h,
                                width: 47.w,
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? AppColors.primaryColor
                                          : Colors.transparent,
                                  borderRadius: BorderRadius.circular(9.sp),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  day,
                                  style: TextStyle(
                                    // Corrected: Set text color based on selection status
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.black,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily:
                                        AppFonts
                                            .jakartaMedium, // Reusing font for consistency
                                  ),
                                ),
                              ),
                            );
                          });
                        }),
                      ),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Include in duplication",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18.sp,
                            fontFamily: AppFonts.jakartaMedium,
                          ),
                        ),
                      ),
                      Obx(
                        ()=> CustomRadioTile(
                          text: "Hours",
                          isSelected: controller.hours.value,
                          onTap: () {
                            controller.hours.value=!controller.hours.value;
                          },
                          isCircle: false,
                        ),
                      ),
                      5.verticalSpace,
                      Obx(
                        ()=> CustomRadioTile(
                          text: "Services",
                          isSelected: controller.services.value,
                          onTap: () {
                            controller.services.value=!controller.services.value;
                          },
                          isCircle: false,
                        ),
                      ),
                      5.verticalSpace,
                      Obx(
                        ()=> CustomRadioTile(
                          text: "Locations",
                          isSelected: controller.location.value,
                          onTap: () {
                            controller.location.value=!controller.location.value;
                          },
                          isCircle: false,
                        ),
                      ),
                      5.verticalSpace,
                      Obx(
                        ()=> CustomRadioTile(
                          text: "Buffers",
                          isSelected: controller.buffers.value,
                          onTap: () {
                            controller.buffers.value=!controller.buffers.value;
                          },
                          isCircle: false,
                        ),
                      ),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Affected Period Preview",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18.sp,
                            fontFamily: AppFonts.jakartaMedium,
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.lightGrey.withOpacity(0.3),
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Obx(
                          () => CalendarDatePicker2(
                            config: _buildCalendarConfig(),
                            value: [controller.selectedDate.value],
                            onValueChanged: (dates) {
                              if (dates.isNotEmpty && dates.first != null) {
                                controller.selectNewDate(dates.first!);
                              }
                            },
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      CustomButton(borderRadius: 15, text: "Confirm Duplication", onTap: (){}),
                      10.verticalSpace,
                      CustomButton(borderRadius: 15, text: "Cancel", onTap: (){
                        Get.back();
                      },bgColor: AppColors.inACtiveButtonColor,fontColor: Colors.black,),
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

  CalendarDatePicker2Config _buildCalendarConfig() {
    return CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.single,
      currentDate: controller.initialDate,
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
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryColor,
      ),
      controlsHeight: 40,
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
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: isSelectedDay ? AppColors.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            day,
            style: TextStyle(
              color:
                  isSelectedDay
                      ? Colors.white
                      : (isDisabled == true ? Colors.grey : Colors.black),
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }
}
