import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/review_controller.dart';

class FilterControlBar extends StatelessWidget {
  ReviewsController  controller =Get.find();

  Widget _buildDropdownPill({
    required String pillTitle,
    required List<String> items,
    required Rx<String> selectedValue,
    required Function(String?) onChanged,
  }) {
    bool hasDropdown = items.isNotEmpty;

    Widget content = hasDropdown
        ? DropdownButtonHideUnderline(
      child: Obx(
            () => DropdownButton<String>(
          value: selectedValue.value,
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 20,
            color: Colors.black54,
          ),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          selectedItemBuilder: (BuildContext context) {
            return items.map<Widget>((String item) {
              return Container(
                alignment: Alignment.center,
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              );
            }).toList();
          },
          isDense: true,
          style: TextStyle(color: Colors.black87),
          dropdownColor: Color(0xFFDEE6EB),
        ),
      ),
    )
        : Text(
      pillTitle,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );

    return GestureDetector(
      onTap: () {
        if (!hasDropdown) {
          controller.handleExportTap(pillTitle);
        } else {
          controller.setActivePill(pillTitle);
        }
      },
      child: Obx(
            () {
          bool isSelected = controller.activePillTitle.value == pillTitle;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: hasDropdown ? 0 : 8),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Color(0xFFDEE6EB),
              borderRadius: BorderRadius.circular(15.sp),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: hasDropdown ? 8 : 0),
                  child: content,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDropdownPill(
          // Ensure pillTitle matches the title used in the onTap handler
          pillTitle: '7 day',
          items: controller.periodList,
          // selectedValue now has an initial value that matches an item in periodList
          selectedValue: controller.selectedTimeValue,
          onChanged: (v) {
            controller.setTimeValue(v);
            controller.setActivePill('7 day');
          },
        ),
        _buildDropdownPill(
          pillTitle: 'Activity',
          items: controller.activityList,
          // selectedValue now has an initial value that matches an item in ratingList
          selectedValue: controller.selectedActivityValue,
          onChanged: (v) {
            controller.setActivityValue(v);
            controller.setActivePill('Activity');
          },
        ),
        _buildDropdownPill(
          pillTitle: 'Export',
          items: [],
          // When items is empty, selectedValue is not used, but kept for signature.
          // Using controller.activePillTitle as a placeholder is a quick fix to satisfy type
          // but a better solution is to not require a Rx<String> if items is empty.
          // Since the function signature requires it, we'll keep the empty RxString from the controller
          selectedValue: ''.obs,
          onChanged: (v) {},
        ),
      ],
    );
  }
}