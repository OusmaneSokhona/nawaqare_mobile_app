import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_appoinment_controller.dart';
import 'package:patient_app/utils/app_strings.dart';

class SchedulerWidget extends StatelessWidget {
  SchedulerWidget({super.key});

  final DoctorAppointmentController controller = Get.find();

  final List<String> daysOfWeek = [
    AppStrings.mondayAbbr.tr,
    AppStrings.tuesdayAbbr.tr,
    AppStrings.wednesdayAbbr.tr,
    AppStrings.thursdayAbbr.tr,
    AppStrings.fridayAbbr.tr,
    AppStrings.saturdayAbbr.tr,
    AppStrings.sundayAbbr.tr,
  ];

  final List<String> dates = ['23', '24', '25', '26', '26', '26', '27'];
  static const Color primaryColor = Color(0xFF4285F4);
  static const Color borderColor = Color(0xFFE0E0E0);
  static const double borderRadius = 10.0;

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: 24,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      controller.searchUpcomingPatients(value);
                    },
                    onTapOutside: (_) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    decoration: InputDecoration(
                      hintText: AppStrings.searchByPatientName.tr,
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10.0),
        InkWell(
          onTap: () {
            controller.showFilterBottomSheet();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.filter_list,
                  color: Colors.black,
                  size: 24,
                ),
                const SizedBox(width: 8.0),
                Text(
                  "Filter",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateItem(int index) {
    return Obx(() {
      final isSelected = controller.selectedDateIndex.value == index;
      return GestureDetector(
        onTap: () => controller.selectDate(index),
        child: Container(
          width: 50.w,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                daysOfWeek[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                dates[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black54,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchBar(),
        const SizedBox(height: 20.0),
        Text(
          AppStrings.todayScheduler.tr,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12.0),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 18),
            ),
            Expanded(
              child: SizedBox(
                height: 80.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: daysOfWeek.length,
                  itemBuilder: (context, index) {
                    return _buildDateItem(index);
                  },
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
            ),
          ],
        ),
      ],
    );
  }
}