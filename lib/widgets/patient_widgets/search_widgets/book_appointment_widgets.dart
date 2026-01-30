import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/models/doctor_model.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../../controllers/patient_controllers/appointment_controllers/book_appointment_controller.dart';

class ConsultationDetailsCard extends StatelessWidget {
  final BookAppointmentController controller;
  final DoctorModel doctor;

  const ConsultationDetailsCard({
    required this.controller,
    required this.doctor,
  });

  String _getFeeBasedOnType() {
    switch (controller.appointmentType.value) {
      case "inPerson":
        return doctor.fee?.displayInPersonFee ?? '\$N/A';
      case "remote":
        return doctor.fee?.displayVideoFee ?? '\$N/A';
      case "homeVisit":
        return '\$100'; // Default home visit fee
      default:
        return '\$N/A';
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
            InputField(
              text: _getFeeBasedOnType(),
              readOnly: true,
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
              text: doctor.phoneNumber,
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
                maxLines: 5,
                onTapOutside: (_) {
                  FocusManager.instance.primaryFocus!.unfocus();
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

  @override
  Widget build(BuildContext context) {
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
                '${AppStrings.june.tr} 2025',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: AppColors.primaryColor,
                ),
              ),
              Row(
                children: [
                  _CalendarArrowButton(icon: Icons.arrow_back_ios_new, onTap: () {}),
                  _CalendarArrowButton(icon: Icons.arrow_forward_ios, onTap: () {}),
                ],
              )
            ],
          ),
          5.verticalSpace,
          _DayLabels(),
          5.verticalSpace,
          _DateGrid(controller: controller),
        ],
      ),
    );
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

class _DateGrid extends StatelessWidget {
  final BookAppointmentController controller;
  const _DateGrid({required this.controller});

  List<int> get dates => [
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 1, 2, 3, 4, 5
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.0,
        mainAxisSpacing: 8.h,
        crossAxisSpacing: 0,
      ),
      itemCount: dates.length,
      itemBuilder: (context, index) {
        final dayNumber = dates[index];
        final isNextMonth = index >= 30;
        final date = DateTime(2023, 6, dayNumber);

        return Obx(() {
          final isSelected = controller.selectedDate.value.day == dayNumber && !isNextMonth;
          return _DateTile(
            dayNumber: dayNumber,
            isSelected: isSelected,
            isNextMonth: isNextMonth,
            onTap: isNextMonth ? () {} : () => controller.selectDate(date),
          );
        });
      },
    );
  }
}

class _DateTile extends StatelessWidget {
  final int dayNumber;
  final bool isSelected;
  final bool isNextMonth;
  final VoidCallback onTap;
  const _DateTile({
    required this.dayNumber,
    required this.isSelected,
    required this.isNextMonth,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4285F4) : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          '$dayNumber',
          style: TextStyle(
            color: isSelected ? Colors.white : isNextMonth ? const Color(0xFFCCCCCC) : const Color(0xFF333333),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
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

  List<String> _getAvailableTimeSlots() {
    if (doctor.availableSlots.isNotEmpty) {
      return doctor.availableSlots;
    }
    return [
      "09:00 AM",
      "10:00 AM",
      "11:00 AM",
      "12:00 PM",
      "02:00 PM",
      "03:00 PM",
      "04:00 PM",
      "05:00 PM",
    ];
  }

  @override
  Widget build(BuildContext context) {
    final timeSlots = _getAvailableTimeSlots();

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
      child: Wrap(
        spacing: 10.w,
        runSpacing: 10.h,
        children: timeSlots.map((time) {
          final isSelected = controller.selectedTime.value == time;
          return _TimeSlotButton(
            time: time,
            isSelected: isSelected,
            onTap: () => controller.selectTime(time),
          );
        }).toList(),
      ),
    );
  }
}

class _TimeSlotButton extends StatelessWidget {
  final String time;
  final bool isSelected;
  final VoidCallback onTap;
  const _TimeSlotButton({
    required this.time,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4285F4) : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: isSelected ? null : Border.all(color: const Color(0xFFE5E5E5), width: 1.w),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: const Color(0xFF4285F4).withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2.h),
            ),
          ]
              : null,
        ),
        child: Text(
          time,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF333333),
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}