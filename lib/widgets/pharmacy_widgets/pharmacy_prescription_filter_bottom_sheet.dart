import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/pharmacy_controllers/pharmacy_prescription_controller.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/patient_widgets/video_call_widgets/setting%20widgets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../custom_button.dart';

class PharmacyPrescriptionFilterBottomSheet extends StatelessWidget {
  final VoidCallback onApply;
  final VoidCallback onReset;
  final PharmacyPrescriptionController controller = Get.find();

  PharmacyPrescriptionFilterBottomSheet({
    required this.onApply,
    required this.onReset,
    super.key,
  });

  // These should ideally come from the controller to persist state
  final RxString selectedStatus = AppStrings.statusApproved.tr.obs;
  final RxString selectedDoctor = "Dr. Alina shah".obs;

  // Localized statuses list
  final List<String> statuses = [
    AppStrings.statusApproved.tr,
    AppStrings.statusPending.tr,
    AppStrings.statusReadyToShip.tr,
    AppStrings.statusDelivered.tr,
    AppStrings.cancel.tr // Using existing cancel key
  ];

  final List<String> doctors = ["Dr. Alina shah", "Dr. John Doe", "Dr. Jane Smith"];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, MediaQuery.of(context).viewInsets.bottom + 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCloseButton(),
          10.verticalSpace,
          _buildDateSelector(context),
          20.verticalSpace,
          Obx(() => CustomDropdown(
            label: AppStrings.status.tr,
            options: statuses,
            currentValue: selectedStatus.value,
            onChanged: (val) => selectedStatus.value = val!,
          )),
          20.verticalSpace,
          Obx(() => CustomDropdown(
            label: AppStrings.doctor.tr,
            options: doctors,
            currentValue: selectedDoctor.value,
            onChanged: (val) => selectedDoctor.value = val!,
          )),
          40.verticalSpace,
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildCloseButton() {
    return Align(
      alignment: Alignment.topRight,
      child: InkWell(
        onTap: () => Get.back(),
        child: Container(
          padding: EdgeInsets.all(5.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            color: AppColors.primaryColor,
          ),
          child: Icon(Icons.close, color: Colors.white, size: 18.sp),
        ),
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.issueDate.tr,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
            fontFamily: AppFonts.jakartaMedium,
          ),
        ),
        8.verticalSpace,
        InkWell(
          onTap: () => _showDatePicker(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text(
                  controller.selectedDate == null
                      ? AppStrings.selectDate.tr
                      : controller.formattedDate,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: controller.selectedDate == null ? Colors.grey : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                )),
                const Icon(Icons.calendar_today, color: Colors.blue, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: AppStrings.reset.tr,
            borderRadius: 15,
            bgColor: AppColors.inACtiveButtonColor,
            fontColor: Colors.black,
            onTap: onReset,
          ),
        ),
        15.horizontalSpace,
        Expanded(
          child: CustomButton(
            text: AppStrings.apply.tr,
            borderRadius: 15,
            onTap: onApply,
          ),
        ),
      ],
    );
  }

  void _showDatePicker(BuildContext context) async {
    await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.single,
        selectedDayHighlightColor: AppColors.primaryColor,
      ),
      dialogSize: Size(325.w, 400.h),
      value: [controller.selectedDate],
      borderRadius: BorderRadius.circular(15.r),
    );
    // Note: Ensure your controller updates 'selectedDate' inside this logic if not handled by standard dialog callback
  }
}