import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/review_controller.dart';
import 'package:patient_app/utils/app_strings.dart';

class FilterControlBar extends StatelessWidget {
  ReviewsController controller = Get.find();

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
              child: Text(item.tr),
            );
          }).toList(),
          selectedItemBuilder: (BuildContext context) {
            return items.map<Widget>((String item) {
              return Container(
                alignment: Alignment.center,
                child: Text(
                  item.tr,
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
      pillTitle.tr,
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
      child: Container(
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
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDropdownPill(
          pillTitle: AppStrings.sevenDay,
          items: controller.periodList,
          selectedValue: controller.selectedTimeValue,
          onChanged: (v) {
            controller.setTimeValue(v);
            controller.setActivePill(AppStrings.sevenDay);
          },
        ),
        _buildDropdownPill(
          pillTitle: AppStrings.activity,
          items: controller.activityList,
          selectedValue: controller.selectedActivityValue,
          onChanged: (v) {
            controller.setActivityValue(v);
            controller.setActivePill(AppStrings.activity);
          },
        ),
        _buildDropdownPill(
          pillTitle: AppStrings.export,
          items: [],
          selectedValue: ''.obs,
          onChanged: (v) {},
        ),
      ],
    );
  }
}