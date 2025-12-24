import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/absence_exception_controller.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:patient_app/widgets/custom_radio_tile.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import 'package:patient_app/widgets/patient_widgets/video_call_widgets/setting%20widgets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import 'calender_syncronization_screen.dart';

class AbsenceAndException extends StatelessWidget {
  AbsenceAndException({super.key});

  final AbsenceExceptionController controller = Get.put(
    AbsenceExceptionController(),
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
                    AppStrings.absencesExceptions.tr,
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.selectDate.tr,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
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
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.declareAbsence.tr,
                        onTap: () {
                          Get.to( CalenderSyncronizationScreen());
                        },
                      ),
                      10.verticalSpace,
                      CustomTextField(
                        labelText: AppStrings.period.tr,
                        hintText: "Nov 1 - Nov 3",
                      ),
                      10.verticalSpace,
                      Obx(() => CustomDropdown(
                        label: AppStrings.reason.tr,
                        options: [
                          AppStrings.vacation.tr,
                          AppStrings.onWork.tr,
                          AppStrings.weekEnd.tr
                        ],
                        currentValue: controller.selectedReason.value,
                        onChanged: (val) {
                          if (val != null) controller.selectedReason.value = val;
                        },
                      )),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.scope.tr,
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      Obx(
                            () => CustomRadioTile(
                          text: AppStrings.allServices.tr,
                          isSelected: controller.allService.value,
                          onTap: () {
                            controller.allService.value =
                            !controller.allService.value;
                          },
                        ),
                      ),
                      5.verticalSpace,
                      Obx(
                            () => CustomRadioTile(
                          text: AppStrings.specific.tr,
                          isSelected: controller.specific.value,
                          onTap: () {
                            controller.specific.value =
                            !controller.specific.value;
                          },
                        ),
                      ),
                      15.verticalSpace,
                      Obx(
                            () => CustomRadioTile(
                          text: AppStrings.notifyAffectedPatients.tr,
                          isSelected: controller.notifyAffectedPatient.value,
                          onTap: () {
                            controller.notifyAffectedPatient.value =
                            !controller.notifyAffectedPatient.value;
                          },
                          isCircle: false,
                        ),
                      ),
                      20.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.save.tr,
                        onTap: () {},
                      ),
                      10.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.cancel.tr,
                        onTap: () {
                          Get.back();
                        },
                        bgColor: AppColors.inACtiveButtonColor,
                        fontColor: Colors.black,
                      ),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.pastAbsences.tr,
                          style: TextStyle(
                            fontSize: 19.sp,
                            fontFamily: AppFonts.jakartaBold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      5.verticalSpace,
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(color: AppColors.lightGrey.withOpacity(0.2))
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.identity.tr,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            10.verticalSpace,
                            _buildStatusRow(
                              dateRange: 'Oct 10–12',
                              status: AppStrings.completed.tr,
                              isNotified: true,
                            ),
                            const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
                            _buildStatusRow(
                              dateRange: 'Oct 10–12',
                              status: AppStrings.completed.tr,
                              isNotified: true,
                            ),
                          ],
                        ),
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

  // Configuration remains same, but you can localize month labels here if the package supports it
  CalendarDatePicker2Config _buildCalendarConfig() {
    return CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.single,
      currentDate: controller.initialDate,
      weekdayLabelTextStyle: const TextStyle(
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
    );
  }

  Widget _buildStatusRow({
    required String dateRange,
    required String status,
    bool isNotified = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            dateRange,
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF757575),
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.check_box,
                color: Color(0xFF4CAF50),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                status,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isNotified)
                Row(
                  children: [
                    const Text(
                      ' | ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFBDBDBD),
                      ),
                    ),
                    Text(
                      AppStrings.notified.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF757575),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}