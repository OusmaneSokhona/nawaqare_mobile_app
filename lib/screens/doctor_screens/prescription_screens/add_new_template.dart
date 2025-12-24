import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_prescription_controller.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import 'package:patient_app/widgets/patient_widgets/video_call_widgets/setting%20widgets.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';

class AddNewTemplate extends StatelessWidget {
  AddNewTemplate({super.key});

  final DoctorPrescriptionController doctorPrescriptionController = Get.find<DoctorPrescriptionController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              70.verticalSpace,
              Row(
                children: [
                  InkWell(
                    onTap: () {
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
                    AppStrings.addNewTemplate.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 21.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      20.verticalSpace,
                      CustomTextField(
                        labelText: AppStrings.templateName.tr,
                        hintText: "Hypertension Basic Set",
                      ),
                      10.verticalSpace,
                      CustomTextField(
                        labelText: AppStrings.medicationName.tr,
                        hintText: "Amoxicillin 500mg capsule",
                      ),
                      10.verticalSpace,
                      Obx(() => CustomDropdown(
                          label: AppStrings.form.tr,
                          options: doctorPrescriptionController.medicineForm,
                          currentValue: doctorPrescriptionController.selectedMedicineForm.value,
                          onChanged: (val) {
                            if (val != null) doctorPrescriptionController.selectedMedicineForm.value = val;
                          }
                      )),
                      10.verticalSpace,
                      Obx(() => CustomDropdown(
                          label: AppStrings.category.tr,
                          options: doctorPrescriptionController.medicineCategory,
                          currentValue: doctorPrescriptionController.selectedMedicineCategory.value,
                          onChanged: (val) {
                            if (val != null) doctorPrescriptionController.selectedMedicineCategory.value = val;
                          }
                      )),
                      10.verticalSpace,
                      CustomTextField(
                        labelText: AppStrings.dosage.tr,
                        hintText: "1 capsule every 8 hours",
                      ),
                      10.verticalSpace,
                      Obx(() => CustomDropdown(
                          label: AppStrings.routeOfAdministration.tr,
                          options: doctorPrescriptionController.administrationRoute,
                          currentValue: doctorPrescriptionController.selectedAdministrationRoute.value,
                          onChanged: (val) {
                            if (val != null) doctorPrescriptionController.selectedAdministrationRoute.value = val;
                          }
                      )),
                      10.verticalSpace,
                      CustomTextField(
                        labelText: AppStrings.quantityToDispense.tr,
                        hintText: "15 tablets",
                      ),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.refillDate.tr,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      10.verticalSpace,
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
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(() => Text(
                                doctorPrescriptionController.formattedDate,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: doctorPrescriptionController.selectedDate.value == null
                                      ? Colors.grey
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                              const Icon(
                                Icons.calendar_today,
                                color: Colors.blue,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.specialInstructions.tr,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppFonts.jakartaBold,
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      Container(
                        height: 120.h,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: AppColors.lightGrey.withOpacity(0.2))
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                          child: TextField(
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: InputDecoration(
                              hintText: AppStrings.notesHint.tr,
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: AppFonts.jakartaRegular,
                            ),
                          ),
                        ),
                      ),
                      30.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.addAndSave.tr,
                        onTap: () {},
                      ),
                      10.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.cancel.tr,
                        onTap: () {
                          Get.back();
                        },
                        bgColor: AppColors.inACtiveButtonColor,
                        fontColor: Colors.black,
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
      value: [doctorPrescriptionController.selectedDate.value],
      borderRadius: BorderRadius.circular(15),
    );
    if (dates != null && dates.isNotEmpty) {
      doctorPrescriptionController.selectedDate.value = dates.first;
    }
  }
}