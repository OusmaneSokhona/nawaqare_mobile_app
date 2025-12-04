import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/calender_controller.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';

class CalenderScreen extends StatelessWidget {
  CalenderScreen({super.key});

  final CalenderController controller = Get.put(CalenderController());

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
                    "Calender",
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
                      20.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLegendItem(AppColors.green, 'Available'),
                          _buildLegendItem(AppColors.red, 'Unavailable'),
                          _buildLegendItem(AppColors.primaryColor, 'Booked'),
                          _buildLegendItem(AppColors.primaryColor, 'Exception'),
                        ],
                      ),
                      20.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select Date',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                            decoration: BoxDecoration(
                              color: AppColors.lightGrey.withOpacity(0.1),
                              border: Border.all(color: AppColors.lightGrey.withOpacity(0.2)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: Obx(
                                ()=> DropdownButton<String>(
                                  value: controller.selectedDuration.value,
                                  icon: Icon(Icons.keyboard_arrow_down, color: AppColors.lightGrey),
                                  items: <String>['Daily', 'Weekly', 'Monthly']
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    controller.selectedDuration.value=newValue!;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
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
                      SizedBox(height: 24),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Available Times',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      GridView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.availableTimes.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 2.5, crossAxisSpacing: 10, mainAxisSpacing: 10),
                          itemBuilder: (context, index) {
                            return _buildTimeSlot(controller.availableTimes[index]);
                          }),
                      20.verticalSpace,
                      CustomButton(borderRadius: 15, text: "Edit Day", onTap: () {}),
                      10.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: "View as Patient",
                        onTap: () {},
                        bgColor: AppColors.inACtiveButtonColor,
                        fontColor: Colors.black,
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
          fontWeight: FontWeight.w500
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
              color: isSelectedDay ? Colors.white : (isDisabled == true ? Colors.grey : Colors.black),
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 10, color: color),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.black87),
        ),
        SizedBox(width: 12),
      ],
    );
  }

  Widget _buildTimeSlot(String time) {
    return Obx(
          () {
        final isSelected = controller.selectedTime.value == time;
        return GestureDetector(
          onTap: () => controller.selectNewTime(time),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                time,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}