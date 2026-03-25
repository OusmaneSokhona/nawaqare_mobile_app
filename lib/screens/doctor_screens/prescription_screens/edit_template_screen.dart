import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_prescription_controller.dart';
import 'package:patient_app/models/prescription_template_model.dart';
import 'package:patient_app/screens/doctor_screens/prescription_screens/electronic_signature_screen.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import 'package:patient_app/widgets/patient_widgets/video_call_widgets/setting%20widgets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';

class EditTemplateScreen extends StatelessWidget {
  final PrescriptionTemplateModel template;

  const EditTemplateScreen({super.key, required this.template});

  @override
  Widget build(BuildContext context) {
    final DoctorPrescriptionController controller = Get.find<DoctorPrescriptionController>();

    // Initialize controllers
    final TextEditingController templateNameController = TextEditingController();
    final TextEditingController medicationNameController = TextEditingController();
    final TextEditingController dosageController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();
    final TextEditingController specialInstructionsController = TextEditingController();

    // Populate fields after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      templateNameController.text = template.templateName;
      medicationNameController.text = template.medicationsName;
      dosageController.text = template.dosage;
      quantityController.text = template.qtd;
      specialInstructionsController.text = template.specialInstruction;
      controller.selectedMedicineForm.value = template.form;
      controller.selectedMedicineCategory.value = template.diagnosis;
      controller.selectedAdministrationRoute.value = template.roa;
      controller.selectedDate.value = template.refillDate;
    });

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
                    onTap: () => Get.back(),
                    child: Image.asset(
                      AppImages.backIcon,
                      height: 33.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    AppStrings.editTemplate.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
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
                        controller: templateNameController,
                        labelText: AppStrings.templateName.tr,
                        hintText: "Hypertension Basic Set",
                      ),
                      10.verticalSpace,
                      CustomTextField(
                        controller: medicationNameController,
                        labelText: AppStrings.medicationName.tr,
                        hintText: "Amoxicillin 500mg capsule",
                      ),
                      10.verticalSpace,
                      Obx(() => CustomDropdown(
                        label: AppStrings.form.tr,
                        options: controller.medicineForm,
                        currentValue: controller.selectedMedicineForm.value,
                        onChanged: (val) {
                          if (val != null) controller.selectedMedicineForm.value = val;
                        },
                      )),
                      10.verticalSpace,
                      Obx(() => CustomDropdown(
                        label: AppStrings.category.tr,
                        options: controller.medicineCategory,
                        currentValue: controller.selectedMedicineCategory.value,
                        onChanged: (val) {
                          if (val != null) controller.selectedMedicineCategory.value = val;
                        },
                      )),
                      10.verticalSpace,
                      CustomTextField(
                        controller: dosageController,
                        labelText: AppStrings.dosage.tr,
                        hintText: "1 capsule every 8 hours",
                      ),
                      10.verticalSpace,
                      Obx(() => CustomDropdown(
                        label: AppStrings.routeOfAdministration.tr,
                        options: controller.administrationRoute,
                        currentValue: controller.selectedAdministrationRoute.value,
                        onChanged: (val) {
                          if (val != null) controller.selectedAdministrationRoute.value = val;
                        },
                      )),
                      10.verticalSpace,
                      CustomTextField(
                        controller: quantityController,
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
                        onTap: () => _showDatePicker(context, controller),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(() => Text(
                                controller.formattedDate,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: controller.selectedDate.value == null
                                      ? Colors.grey
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                              const Icon(Icons.calendar_today, color: Colors.blue, size: 24),
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
                          border: Border.all(color: AppColors.lightGrey.withOpacity(0.2)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                          child: TextField(
                            controller: specialInstructionsController,
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
                      Obx(() => CustomButton(
                        borderRadius: 15,
                        text: AppStrings.generateAndSign.tr,
                        onTap: () async {
                          final data = {
                            'templateName': templateNameController.text.trim(),
                            'diagnosis': controller.selectedMedicineCategory.value,
                            'medicationsName': medicationNameController.text.trim(),
                            'dosage': dosageController.text.trim(),
                            'form': controller.selectedMedicineForm.value,
                            'roa': controller.selectedAdministrationRoute.value,
                            'qtd': quantityController.text.trim(),
                            'refildate': controller.selectedDate.value
                                ?.toIso8601String()
                                .split('T')[0],
                            'specialInsturuction': specialInstructionsController.text.trim(),
                            'notes': ''
                          };
                          await controller.updateTemplate(template.id, data);
                        },
                        bgColor: AppColors.inACtiveButtonColor,
                        fontColor: Colors.black,
                        isLoading: controller.isLoading.value,
                      )),
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

  void _showDatePicker(BuildContext context, DoctorPrescriptionController controller) async {
    final List<DateTime?>? dates = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.single,
        selectedDayHighlightColor: Colors.blue,
        centerAlignModePicker: true,
      ),
      dialogSize: const Size(325, 400),
      value: [controller.selectedDate.value],
      borderRadius: BorderRadius.circular(15),
    );
    if (dates != null && dates.isNotEmpty) {
      controller.selectedDate.value = dates.first;
    }
  }
}