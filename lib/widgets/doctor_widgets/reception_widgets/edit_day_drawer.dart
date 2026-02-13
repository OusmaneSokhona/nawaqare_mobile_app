import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:patient_app/controllers/doctor_controllers/calender_controller.dart';
import 'package:patient_app/screens/doctor_screens/reception_screens/duplicate_configuration.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/custom_radio_tile.dart';
import '../../../utils/app_fonts.dart';

class EditDayDrawer extends StatelessWidget {
  EditDayDrawer({super.key});
  final CalenderController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.9,
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Container(
            width: 0.8.sw,
            height: 1.sh,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.onboardingBackground, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 60.h, left: 18.w, right: 10.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.editDay.tr,
                      style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    10.verticalSpace,
                    Text(
                      AppStrings.startTime.tr,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.jakartaMedium,
                      ),
                    ),
                    5.verticalSpace,
                    Obx(() => InkWell(
                      onTap: () => controller.showTimePickerCustom(true),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: AppColors.lightGrey.withOpacity(0.5)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: AppColors.primaryColor,
                              size: 20.w,
                            ),
                            10.horizontalSpace,
                            Text(
                              controller.formatTimeOfDayForDisplay(controller.startTime.value),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontFamily: AppFonts.jakartaMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                    10.verticalSpace,
                    Text(
                      AppStrings.endTime.tr,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.jakartaMedium,
                      ),
                    ),
                    5.verticalSpace,
                    Obx(() => InkWell(
                      onTap: () => controller.showTimePickerCustom(false),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: AppColors.lightGrey.withOpacity(0.5)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: AppColors.primaryColor,
                              size: 20.w,
                            ),
                            10.horizontalSpace,
                            Text(
                              controller.formatTimeOfDayForDisplay(controller.endTime.value),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontFamily: AppFonts.jakartaMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                    10.verticalSpace,
                    Text(
                      'Break Start',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.jakartaMedium,
                      ),
                    ),
                    5.verticalSpace,
                    Obx(() => InkWell(
                      onTap: () => controller.showBreakTimePicker(true),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: AppColors.lightGrey.withOpacity(0.5)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.free_breakfast,
                              color: AppColors.primaryColor,
                              size: 20.w,
                            ),
                            10.horizontalSpace,
                            Text(
                              controller.formatTimeOfDayForDisplay(controller.breakStartTime.value),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontFamily: AppFonts.jakartaMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                    10.verticalSpace,
                    Text(
                      'Break End',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.jakartaMedium,
                      ),
                    ),
                    5.verticalSpace,
                    Obx(() => InkWell(
                      onTap: () => controller.showBreakTimePicker(false),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: AppColors.lightGrey.withOpacity(0.5)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.free_breakfast,
                              color: AppColors.primaryColor,
                              size: 20.w,
                            ),
                            10.horizontalSpace,
                            Text(
                              controller.formatTimeOfDayForDisplay(controller.breakEndTime.value),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontFamily: AppFonts.jakartaMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                    10.verticalSpace,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppStrings.consultationMode.tr,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppFonts.jakartaBold,
                        ),
                      ),
                    ),
                    10.verticalSpace,
                    Obx(
                          () => CustomRadioTile(
                          text: AppStrings.inPerson.tr,
                          isSelected: controller.inPerson.value,
                          onTap: () {
                            controller.inPerson.value = !controller.inPerson.value;
                          }
                      ),
                    ),
                    10.verticalSpace,
                    Obx(
                          () => CustomRadioTile(
                          text: AppStrings.teleconsultation.tr,
                          isSelected: controller.teleConsultation.value,
                          onTap: () {
                            controller.teleConsultation.value = !controller.teleConsultation.value;
                          }
                      ),
                    ),
                    10.verticalSpace,
                    Obx(
                          () => CustomRadioTile(
                          text: AppStrings.mixed.tr,
                          isSelected: controller.mixed.value,
                          onTap: () {
                            controller.mixed.value = !controller.mixed.value;
                          }
                      ),
                    ),
                    10.verticalSpace,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppStrings.services.tr,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppFonts.jakartaBold,
                        ),
                      ),
                    ),
                    10.verticalSpace,
                    Obx(
                          () => CustomRadioTile(
                        text: AppStrings.consultation.tr,
                        isSelected: controller.consultation.value,
                        onTap: () {
                          controller.consultation.value = !controller.consultation.value;
                        },
                        isCircle: false,
                      ),
                    ),
                    10.verticalSpace,
                    Obx(
                          () => CustomRadioTile(
                        text: AppStrings.followUp.tr,
                        isSelected: controller.followUp.value,
                        onTap: () {
                          controller.followUp.value = !controller.followUp.value;
                        },
                        isCircle: false,
                      ),
                    ),
                    10.verticalSpace,
                    Obx(
                          () => CustomRadioTile(
                        text: AppStrings.physiotherapy.tr,
                        isSelected: controller.physiotherapy.value,
                        onTap: () {
                          controller.physiotherapy.value = !controller.physiotherapy.value;
                        },
                        isCircle: false,
                      ),
                    ),
                    30.verticalSpace,
                    Obx(
                          () => CustomButton(
                          borderRadius: 15,
                          text: controller.isCreating.value ? 'Creating...' : AppStrings.apply.tr,
                          onTap: () {
                            if (!controller.isCreating.value) {
                              controller.createTimeSlotsForDay();
                            }
                          }
                      ),
                    ),
                    10.verticalSpace,
                    CustomButton(
                      borderRadius: 15,
                      text: AppStrings.duplicateConfiguration.tr,
                      onTap: () {
                        Get.back();
                        Get.to(DuplicateConfiguration());
                      },
                      bgColor: AppColors.inACtiveButtonColor,
                      fontColor: Colors.black,
                    ),
                    10.verticalSpace,
                    Center(
                      child: Text(
                        "${AppStrings.autoSaved.tr}: ${AppStrings.lastSaved.tr} ${DateFormat('HH:mm').format(DateTime.now())}",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.lightGrey,
                        ),
                      ),
                    ),
                    30.verticalSpace,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 12.w,
            top: 55.h,
            child: Container(
              height: 40.h,
              width: 40.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_forward_outlined,
                  color: Colors.white,
                  size: 20.sp,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}