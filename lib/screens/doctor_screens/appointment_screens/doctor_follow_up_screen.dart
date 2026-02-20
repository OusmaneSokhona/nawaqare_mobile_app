import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/doctor_controllers/doctor_follow_up_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';

class DoctorFollowupScreen extends StatelessWidget {
  final String appointmentId;
  DoctorFollowupScreen({required this.appointmentId, super.key});
  final DoctorFollowupController controller = Get.put(
    DoctorFollowupController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: Container(
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
                20.verticalSpace,
                // Header
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        controller.resetForm();
                        Get.back();
                      },
                      child: Image.asset(
                        AppImages.backIcon,
                        height: 33.h,
                        fit: BoxFit.fill,
                      ),
                    ),
                    10.horizontalSpace,
                    Text(
                      "Schedule Follow-up",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 23.sp,
                        fontWeight: FontWeight.w800,
                        fontFamily: AppFonts.jakartaBold,
                      ),
                    ),
                  ],
                ),
                20.verticalSpace,
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDateField(),
                        20.verticalSpace,
                        _buildTimeSlotField(),
                        20.verticalSpace,
                        _buildPriceField(),
                        20.verticalSpace,
                        _buildNotesField(),
                        30.verticalSpace,
                        Obx(
                              () => CustomButton(
                            borderRadius: 15,
                            text: "Schedule Follow-up",
                            isLoading: controller.isLoading.value,
                            onTap: () async {
                              final result = await controller.createFollowUp(appointmentId);
                              if (result) {
                                Get.back();
                              }
                            },
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
      ),
    );
  }



  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Follow-up Date",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.jakartaMedium,
            color: Colors.black87,
          ),
        ),
        8.verticalSpace,
        InkWell(
          onTap: () => controller.selectDate(Get.context!),
          child: Container(
            width: 1.sw,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.sp),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppColors.primaryColor,
                  size: 20.sp,
                ),
                10.horizontalSpace,
                Expanded(
                  child: Obx(
                        () => Text(
                      controller.selectedDate.value != null
                          ? controller.formatDate(
                        controller.selectedDate.value!,
                      )
                          : "Select follow-up date",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: controller.selectedDate.value != null
                            ? Colors.black
                            : Colors.grey,
                      ),
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

  Widget _buildTimeSlotField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Follow-up Time Slot",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.jakartaMedium,
            color: Colors.black87,
          ),
        ),
        8.verticalSpace,
        Obx(
              () => controller.isLoadingTimeSlots.value
              ? Center(
            child: Padding(
              padding: EdgeInsets.all(16.sp),
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            ),
          )
              : InkWell(
            onTap: controller.selectedDate.value != null
                ? () => _showTimeSlotsBottomSheet()
                : null,
            child: Container(
              width: 1.sw,
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              decoration: BoxDecoration(
                color: controller.selectedDate.value != null
                    ? Colors.white
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12.sp),
                border: Border.all(
                  color: controller.selectedDate.value != null
                      ? Colors.grey.shade300
                      : Colors.grey.shade200,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: controller.selectedDate.value != null
                        ? AppColors.primaryColor
                        : Colors.grey,
                    size: 20.sp,
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Obx(
                          () => Text(
                        controller.selectedTimeSlot.value != null
                            ? controller
                            .selectedTimeSlot
                            .value!
                            .formattedTime
                            : controller.selectedDate.value != null
                            ? "Tap to select time slot"
                            : "Select date first",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: controller.selectedTimeSlot.value != null
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  if (controller.selectedDate.value != null &&
                      controller.availableTimeSlots.isNotEmpty)
                    Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.primaryColor,
                      size: 24.sp,
                    ),
                ],
              ),
            ),
          ),
        ),
        // Availability info
        Obx(() {
          if (controller.selectedDate.value != null &&
              !controller.isLoadingTimeSlots.value) {
            if (controller.availableTimeSlots.isEmpty) {
              return Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Text(
                  "No time slots available for this date",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.red,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              );
            } else {
              return Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Text(
                  "${controller.availableTimeSlots.length} slot(s) available for follow-up",
                  style: TextStyle(fontSize: 12.sp, color: Colors.green),
                ),
              );
            }
          }
          return const SizedBox();
        }),
      ],
    );
  }

  Widget _buildPriceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        8.verticalSpace,
        CustomTextField(
          labelText: "Follow-up Price",
          hintText: "Enter follow-up price",
          controller: controller.followupPriceController,
          keyboardType: TextInputType.number,

        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Additional Notes (Optional)",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.jakartaMedium,
            color: Colors.black87,
          ),
        ),
        8.verticalSpace,
        CustomTextField(
          labelText: "Notes",
          hintText: "Add any additional notes for follow-up",
          controller: controller.notesController,
        ),
      ],
    );
  }

  void _showTimeSlotsBottomSheet() {
    Get.bottomSheet(
      Container(
        height: 0.6.sh,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.sp)),
        ),
        child: Column(
          children: [
            Container(
              width: 50.w,
              height: 5.h,
              margin: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10.sp),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Follow-up Time",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey.shade200),
            Expanded(
              child: Obx(() {
                if (controller.isLoadingTimeSlots.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  );
                }

                if (controller.availableTimeSlots.isEmpty) {
                  return Center(
                    child: Text(
                      "No time slots available",
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                  );
                }

                return Padding(
                  padding: EdgeInsets.all(16.sp),
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.6,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                    ),
                    itemCount: controller.availableTimeSlots.length,
                    itemBuilder: (context, index) {
                      final slot = controller.availableTimeSlots[index];
                      final isSelected =
                          controller.selectedTimeSlot.value?.id == slot.id;

                      return GestureDetector(
                        onTap: () {
                          controller.selectedTimeSlot.value = slot;
                          Get.back();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryColor.withOpacity(0.1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12.sp),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.access_time,
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : Colors.grey,
                                size: 20.sp,
                              ),
                              5.verticalSpace,
                              Text(
                                controller.formatTime(slot.startTime),
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : Colors.black,
                                ),
                              ),
                              Text(
                                "-",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                controller.formatTime(slot.endTime),
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}