import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/models/doctor_model.dart';
import 'package:patient_app/models/time_slot_model.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../../controllers/patient_controllers/appointment_controllers/book_appointment_controller.dart';
import 'package:intl/intl.dart';

class ConsultationDetailsCard extends StatelessWidget {
  final BookAppointmentController controller;
  final DoctorModel doctor;

  const ConsultationDetailsCard({
    required this.controller,
    required this.doctor,
  });

  RxString _getFeeBasedOnType() {
    switch (controller.appointmentType.value) {
      case "inPerson":
        return doctor.fee?.displayInPersonFee.obs?? '\$N/A'.obs;
      case "remote":
        return doctor.fee?.displayRemoteFee.obs ?? '\$N/A'.obs;
      case "homeVisit":
        return doctor.fee?.displayHomeVisitFee.obs ?? '\$N/A'.obs;
      default:
        return '\$N/A'.obs;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppStrings.consultationDetails.tr,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF333333),
              ),
            ),
            SizedBox(height: 16.h),
            Obx(
                  () => controller.appointmentType.value != "homeVisit"
                  ? Text(
                AppStrings.typeOfAppointment.tr,
                style: TextStyle(
                  color: const Color(0xFF666666),
                  fontSize: 14.sp,
                ),
              )
                  : SizedBox(),
            ),
            Obx(() => controller.appointmentType.value != "homeVisit" ? SizedBox(height: 8.h) : SizedBox()),
            Obx(
                  () => controller.appointmentType.value != "homeVisit"
                  ? Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE5E5E5), width: 1.w),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: controller.appointmentType.value,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      size: 24.sp,
                      color: const Color(0xFF666666),
                    ),
                    onChanged: controller.selectAppointmentType,
                    items: controller.appointmentOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value.tr,
                          style: TextStyle(
                            color: const Color(0xFF333333),
                            fontSize: 14.sp,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              )
                  : SizedBox(),
            ),
            Obx(
                  () => controller.appointmentType.value == "homeVisit"
                  ? CustomTextField(
                    controller: controller.addressController,
                labelText: AppStrings.consultationAddress.tr,
                hintText: AppStrings.addressHint.tr,
              )
                  : SizedBox(),
            ),
            SizedBox(height: 16.h),
            Text(
              AppStrings.duration.tr,
              style: TextStyle(
                color: const Color(0xFF666666),
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 8.h),
            InputField(
              text: controller.duration.value,
              readOnly: true,
            ),
            SizedBox(height: 16.h),
            Text(
              AppStrings.fee.tr,
              style: TextStyle(
                color: const Color(0xFF666666),
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Obx(
                ()=> InputField(
                text: _getFeeBasedOnType().value,
                readOnly: true,
              ),
            ),
            10.verticalSpace,
            Text(
              AppStrings.contact.tr,
              style: TextStyle(
                color: const Color(0xFF666666),
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 8.h),
            InputField(
              text: doctor.phoneNumber ?? 'N/A',
              readOnly: true,
            ),
            10.verticalSpace,
            Text(
              AppStrings.note.tr,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.lightGrey,
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: TextField(
                controller: controller.notesController,
                maxLines: 5,
                onTapOutside: (_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  hintText: AppStrings.noteHint.tr,
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String text;
  final bool readOnly;
  const InputField({required this.text, this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E5E5), width: 1.w),
        borderRadius: BorderRadius.circular(10.r),
        color: readOnly ? const Color(0xFFFFFFFF) : Colors.white,
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          color: const Color(0xFF333333),
          fontSize: 16.sp,
        ),
      ),
    );
  }
}
class CalendarWidget extends StatelessWidget {
  final BookAppointmentController controller;
  const CalendarWidget({required this.controller});

  String _getMonthYearText(DateTime month) {
    return '${_getMonthName(month.month)} ${month.year}';
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1: return AppStrings.january.tr;
      case 2: return AppStrings.february.tr;
      case 3: return AppStrings.march.tr;
      case 4: return AppStrings.april.tr;
      case 5: return AppStrings.may.tr;
      case 6: return AppStrings.june.tr;
      case 7: return AppStrings.july.tr;
      case 8: return AppStrings.august.tr;
      case 9: return AppStrings.september.tr;
      case 10: return AppStrings.october.tr;
      case 11: return AppStrings.november.tr;
      case 12: return AppStrings.december.tr;
      default: return '';
    }
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final daysInMonth = lastDay.day;
    final firstWeekday = firstDay.weekday;

    List<DateTime> days = [];

    // Add days from previous month
    for (int i = 1; i < firstWeekday; i++) {
      days.add(DateTime(firstDay.year, firstDay.month, 0 - (firstWeekday - i - 1)));
    }

    // Add current month days
    for (int i = 1; i <= daysInMonth; i++) {
      days.add(DateTime(month.year, month.month, i));
    }

    // Add days from next month to fill the grid
    final totalCells = 42;
    final remainingCells = totalCells - days.length;
    for (int i = 1; i <= remainingCells; i++) {
      days.add(DateTime(month.year, month.month + 1, i));
    }

    return days;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentMonth = controller.focusedMonth;
      final selectedDate = controller.selectedDate.value;

      return Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3.h),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getMonthYearText(currentMonth),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
                Row(
                  children: [
                    _CalendarArrowButton(
                      icon: Icons.arrow_back_ios_new,
                      onTap: controller.previousMonth,
                    ),
                    _CalendarArrowButton(
                      icon: Icons.arrow_forward_ios,
                      onTap: controller.nextMonth,
                    ),
                  ],
                )
              ],
            ),
            5.verticalSpace,
            _DayLabels(),
            5.verticalSpace,
            GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.0,
                mainAxisSpacing: 8.h,
                crossAxisSpacing: 0,
              ),
              itemCount: _getDaysInMonth(currentMonth).length,
              itemBuilder: (context, index) {
                final date = _getDaysInMonth(currentMonth)[index];
                final isCurrentMonth = date.month == currentMonth.month;
                final isSelected = selectedDate != null &&
                    date.year == selectedDate.year &&
                    date.month == selectedDate.month &&
                    date.day == selectedDate.day;
                final isToday = date.year == DateTime.now().year &&
                    date.month == DateTime.now().month &&
                    date.day == DateTime.now().day;

                return _DateTile(
                  dayNumber: date.day,
                  date: date,
                  isCurrentMonth: isCurrentMonth,
                  isToday: isToday,
                  onTap: () {
                    if (isCurrentMonth) {
                      controller.selectDate(date);
                    }
                  },
                );
              },
            ),
          ],
        ),
      );
    });
  }
}
class _CalendarArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CalendarArrowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        child: Icon(
          icon,
          size: 16.sp,
          color: const Color(0xFF999999),
        ),
      ),
    );
  }
}

class _DayLabels extends StatelessWidget {
  _DayLabels();
  final List<String> days = [
    'sun'.tr,
    'mon'.tr,
    'tue'.tr,
    'wed'.tr,
    'thu'.tr,
    'fri'.tr,
    'sat'.tr,
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days
          .map(
            (day) => Expanded(
          child: Text(
            day.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
              color: const Color(0xFF666666),
            ),
          ),
        ),
      )
          .toList(),
    );
  }
}

class _DateTile extends StatelessWidget {
  final int dayNumber;
  final DateTime date;
  final bool isCurrentMonth;
  final bool isToday;
  final VoidCallback onTap;

  const _DateTile({
    required this.dayNumber,
    required this.date,
    required this.isCurrentMonth,
    required this.isToday,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookAppointmentController>();

    return Obx(() {
      final selectedDate = controller.selectedDate.value;
      final isSelected = selectedDate != null &&
          date.year == selectedDate.year &&
          date.month == selectedDate.month &&
          date.day == selectedDate.day;

      return GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryColor
                : isToday
                ? AppColors.primaryColor.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
            border: isToday && !isSelected
                ? Border.all(color: AppColors.primaryColor.withOpacity(0.3))
                : null,
          ),
          child: Text(
            '$dayNumber',
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : isCurrentMonth
                  ? const Color(0xFF333333)
                  : const Color(0xFFCCCCCC),
              fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
              fontSize: 14.sp,
            ),
          ),
        ),
      );
    });
  }
}


class TimeSlotsGrid extends StatelessWidget {
  final BookAppointmentController controller;
  final DoctorModel doctor;

  const TimeSlotsGrid({
    super.key,
    required this.controller,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.selectedDate.value == null) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          alignment: Alignment.center,
          child: Text(
            'Please select a date first',
            style: TextStyle(color: AppColors.lightGrey, fontSize: 14.sp),
          ),
        );
      }

      if (controller.filteredTimeSlots.isEmpty) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          alignment: Alignment.center,
          child: Column(
            children: [
              Icon(
                Icons.access_time,
                size: 48.sp,
                color: AppColors.lightGrey,
              ),
              SizedBox(height: 10.h),
              Text(
                'No time slots available for ${controller.appointmentType.value == "inPerson" ? "In-Person" : controller.appointmentType.value == "remote" ? "Remote" : "Home Visit"} consultation on selected date',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.lightGrey, fontSize: 14.sp),
              ),
            ],
          ),
        );
      }

      return Wrap(
        spacing: 10.w,
        runSpacing: 10.h,
        children: controller.filteredTimeSlots.map((TimeSlot timeSlot) {
          final startHour = timeSlot.startTime.hour % 12 == 0 ? 12 : timeSlot.startTime.hour % 12;
          final startMinute = timeSlot.startTime.minute.toString().padLeft(2, '0');
          final startPeriod = timeSlot.startTime.hour < 12 ? 'AM' : 'PM';
          final timeText = '$startHour:$startMinute $startPeriod';
          final isSelected = controller.selectedTime.value == timeSlot.id;

          return GestureDetector(
            onTap: () => controller.selectTime(timeSlot.id),
            child: Container(
              width: 0.265.sw,
              height: 50.h,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(12.sp),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.lightGrey.withOpacity(0.5),
                  width: 1.sp,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                timeText,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppFonts.jakartaMedium,
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}