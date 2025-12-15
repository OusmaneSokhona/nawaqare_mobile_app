import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/pharmacy_controllers/pharmacy_prescription_controller.dart';
import 'package:patient_app/widgets/patient_widgets/video_call_widgets/setting%20widgets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../custom_button.dart';

class PharmacyPrescriptionFilterBottomSheet extends StatelessWidget {
  final VoidCallback onApply;
  final VoidCallback onReset;
PharmacyPrescriptionController controller=Get.find();
  PharmacyPrescriptionFilterBottomSheet({
    required this.onApply,
    required this.onReset,
    super.key,
  });

  final RxString selectedDate = "12/Sep/2025".obs;
  final RxString selectedStatus = "Approved".obs;
  final RxString selectedDoctor = "Dr. Alina shah".obs;

  final List<String> statuses = ["Approved", "Pending", "Ready to Ship", "Delivered", "Canceled"];
  final List<String> doctors = ["Dr. Alina shah", "Dr. John Doe", "Dr. Jane Smith"];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, MediaQuery.of(context).viewInsets.bottom + 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0.sp)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: EdgeInsets.all(5.sp),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.sp),color: AppColors.primaryColor),
              child: InkWell(
                onTap: () => Get.back(),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
            ),
          ),
          Obx(
                () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "Issue Date",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      // Medium boldness
                      color:
                      Colors
                          .black87, // Darker text for the label
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _showDatePicker(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.formattedDate,
                          // Display the formatted date
                          style: TextStyle(
                            fontSize: 18,
                            color:
                            controller.selectedDate ==
                                null
                                ? Colors.grey
                                : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.blue,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          20.verticalSpace,
          CustomDropdown(label: "Status", options: statuses, currentValue: selectedStatus.value, onChanged: (_){}),
          20.verticalSpace,
          CustomDropdown(label: "Doctor", options: doctors, currentValue: selectedDoctor.value, onChanged: (_){}),
          40.verticalSpace,
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: "Reset",
                  borderRadius: 15,
                  bgColor: AppColors.inACtiveButtonColor,
                  fontColor: Colors.black,
                  onTap: onReset,
                ),
              ),
              15.horizontalSpace,
              Expanded(
                child: CustomButton(
                  text: "Apply",
                  borderRadius: 15,
                  onTap: onApply,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterItem(
      String label, IconData? icon, RxString value, VoidCallback? onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            fontFamily: AppFonts.jakartaMedium,
          ),
        ),
        5.verticalSpace,
        InkWell(
          onTap: onTap,
          child: Container(
            height: 55.h,
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.sp),
              border: Border.all(color: AppColors.onboardingBackground, width: 1.5.w),
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: AppColors.primaryColor, size: 20.sp),
                  10.horizontalSpace,
                ],
                Obx(
                      () => Text(
                    value.value,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showDatePicker(BuildContext context) async {
    final List<DateTime?>? dates = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.single,
        selectedDayHighlightColor: Colors.blue,
        centerAlignModePicker: true,
      ),
      dialogSize: const Size(325, 400),
      value: [controller.selectedDate],
      // Current date value
      borderRadius: BorderRadius.circular(15),
    );
  }
}