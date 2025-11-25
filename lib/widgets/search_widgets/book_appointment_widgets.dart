import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_colors.dart';

import '../../controllers/patient_controllers/appointment_controllers/book_appointment_controller.dart';

class ConsultationDetailsCard extends StatelessWidget {
  final BookAppointmentController controller;
  const ConsultationDetailsCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Consultation Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Type of Appointment', style: TextStyle(color: Color(0xFF666666))),
            const SizedBox(height: 8),
            Obx(
                  () => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE5E5E5), width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: controller.appointmentType.value,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF666666)),
                    onChanged: controller.selectAppointmentType,
                    items: controller.appointmentOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(color: Color(0xFF333333))),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Duration', style: TextStyle(color: Color(0xFF666666))),
            const SizedBox(height: 8),
            InputField(
              text: controller.duration.value,
              readOnly: true,
            ),
            const SizedBox(height: 16),
            const Text('Fee', style: TextStyle(color: Color(0xFF666666))),
            const SizedBox(height: 8),
            InputField(
              text: controller.fee.value,
              readOnly: true,
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
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E5E5), width: 1),
        borderRadius: BorderRadius.circular(10),
        color: readOnly ? const Color(0xFFF7F9FC) : Colors.white,
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF333333),
          fontSize: 16,
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
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(
                'June 2025',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
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
          const _DayLabels(),
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
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Icon(
          icon,
          size: 16,
          color: const Color(0xFF999999),
        ),
      ),
    );
  }
}

class _DayLabels extends StatelessWidget {
  const _DayLabels();
  final List<String> days = const ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days
          .map((day) => Expanded(
        child: Text(
          day,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Color(0xFF666666),
          ),
        ),
      ))
          .toList(),
    );
  }
}

class _DateGrid extends StatelessWidget {
  final BookAppointmentController controller;
  const _DateGrid({required this.controller});

  List<int> get dates => [
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
    21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 1, 2, 3, 4, 5
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.0,
        mainAxisSpacing: 8,
        crossAxisSpacing: 0,
      ),
      itemCount: dates.length,
      itemBuilder: (context, index) {
        final dayNumber = dates[index];
        final isNextMonth = index >= 30;
        final date = DateTime(2023, 6, dayNumber);

        return Obx(() {
          final isSelected = controller.selectedDate.value.day == dayNumber &&
              !isNextMonth;
          return _DateTile(
            dayNumber: dayNumber,
            isSelected: isSelected,
            isNextMonth: isNextMonth,
            onTap: isNextMonth
                ? () {}
                : () => controller.selectDate(date),
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
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4285F4) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '$dayNumber',
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : isNextMonth
                ? const Color(0xFFCCCCCC)
                : const Color(0xFF333333),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class TimeSlotsGrid extends StatelessWidget {
  final BookAppointmentController controller;
  const TimeSlotsGrid({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Wrap(
        spacing: 10.0,
        runSpacing: 10.0,
        children: controller.availableTimes.map((time) {
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4285F4) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? null
              : Border.all(color: const Color(0xFFE5E5E5), width: 1),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: const Color(0xFF4285F4).withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: Text(
          time,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF333333),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}