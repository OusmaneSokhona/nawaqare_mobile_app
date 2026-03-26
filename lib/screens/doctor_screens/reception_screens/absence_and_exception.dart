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
    controller.fetchPastAbsences();
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
                          Get.to(CalenderSyncronizationScreen());
                        },
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
                      20.verticalSpace,
                      Obx(
                            () => CustomButton(
                          borderRadius: 15,
                          text: AppStrings.save.tr,
                          onTap: () {
                            if (!controller.isLoading.value) {
                              controller.sendAbsenceException();
                            }
                          },
                          isLoading: controller.isLoading.value,
                        ),
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
                      Obx(() {
                        if (controller.isLoadingHistory.value) {
                          return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,));
                        }
                        if (controller.cancelledHistory.isEmpty) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(color: AppColors.lightGrey.withOpacity(0.2))
                            ),
                            child: Center(
                              child: Text(
                                'No past absences found',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppColors.lightGrey,
                                ),
                              ),
                            ),
                          );
                        }
                        return Container(
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
                              ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.cancelledHistory.length,
                                separatorBuilder: (context, index) => const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
                                itemBuilder: (context, index) {
                                  final item = controller.cancelledHistory[index];
                                  return _buildStatusRow(
                                    dateRange: item.formattedDate,
                                    status: item.status,
                                    reason: item.reason,
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      }),
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
    String? reason,
    bool isNotified = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 5),
      child: Column(
        children: [
          Row(
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


                  Text(
                    status,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.check_box,
                    color: Colors.red,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
          if (reason != null) ...[
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                reason,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF9E9E9E),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}