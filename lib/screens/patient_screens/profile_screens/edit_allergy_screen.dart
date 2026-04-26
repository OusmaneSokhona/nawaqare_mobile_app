import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/allergies_controller.dart';
import 'package:patient_app/models/allergy_model.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../../widgets/custom_button.dart';

class EditAllergyScreen extends StatelessWidget {
  final Allergy allergy;
  EditAllergyScreen({super.key, required this.allergy});

  final AllergyController controller = Get.find<AllergyController>();

  @override
  Widget build(BuildContext context) {
    controller.prepareEditScreen(allergy);

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              70.verticalSpace,
              _buildAppBar(),
              20.verticalSpace,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildDropdownField(
                        title: AppStrings.medical.tr,
                        items: controller.allergyTypeList,
                        selectedValue: controller.selectedAllergy,
                        onChanged: (val) => controller.selectedAllergy.value = val,
                      ),
                      10.verticalSpace,
                      CustomTextField(
                        controller: controller.allergenNameController,
                        labelText: AppStrings.allergenName.tr,
                        hintText: AppStrings.penicillin.tr,
                      ),
                      10.verticalSpace,
                      CustomTextField(
                        controller: controller.reactionController,
                        labelText: AppStrings.reaction.tr,
                        hintText: AppStrings.rash.tr,
                      ),
                      10.verticalSpace,
                      _buildDropdownField(
                        title: AppStrings.severity.tr,
                        items: controller.severityList,
                        selectedValue: controller.selectedSeverity,
                        onChanged: (val) => controller.selectedSeverity.value = val,
                      ),
                      10.verticalSpace,
                      _buildDatePicker(context),
                      20.verticalSpace,
                      _buildFileUploadSection(),
                      20.verticalSpace,
                      _buildNoteSection(),
                      30.verticalSpace,
                      _buildActionButtons(),
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

  Widget _buildAppBar() {
    return Row(
      children: [
        InkWell(
          onTap: () => Get.back(),
          child: Image.asset(AppImages.backIcon, height: 33.h, fit: BoxFit.fill),
        ),
        10.horizontalSpace,
        Text(
          AppStrings.editAllergy.tr,
          style: TextStyle(
            color: Colors.black,
            fontSize: 23.sp,
            fontWeight: FontWeight.w800,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.dateIdentified.tr,
          style: TextStyle(color: AppColors.darkGrey, fontWeight: FontWeight.w600, fontSize: 15.sp),
        ),
        5.verticalSpace,
        Obx(() => InkWell(
          onTap: () => _showDatePicker(context),
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
                Text(
                  controller.formattedDate,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: controller.selectedDate == null ? Colors.grey : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(Icons.calendar_today, color: Colors.blue, size: 24),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildFileUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.uploadDocPhoto.tr,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        5.verticalSpace,
        InkWell(
          onTap: controller.pickFile,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Obx(() => Column(
              children: [
                Icon(Icons.cloud_upload_outlined, size: 40, color: Colors.blue.shade700),
                const SizedBox(height: 12),
                Text(
                  controller.selectedFileName.value == 'No file selected'
                      ? AppStrings.uploadPdfJpeg.tr
                      : controller.selectedFileName.value!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                ),
              ],
            )),
          ),
        ),
      ],
    );
  }

  Widget _buildNoteSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.note.tr,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        5.verticalSpace,
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: controller.noteController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: AppStrings.writeNoteToDoctor.tr,
              hintStyle: TextStyle(color: Colors.grey.shade500),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Obx(() => controller.isUpdatingAllergy.value
            ? const Center(child: CircularProgressIndicator())
            : CustomButton(
          borderRadius: 15,
          text: AppStrings.save.tr,
          onTap: () async {
            Map<String, dynamic> data = {
              "allergyType": controller.selectedAllergy.value,
              "allergenName": controller.allergenNameController.text.trim(),
              "reaction": controller.reactionController.text.trim(),
              "severity": controller.selectedSeverity.value,
              "dateIdentified": controller.selectedDate?.toIso8601String(),
              "notes": controller.noteController.text.trim(),
            };
            bool success = await controller.updateAllergy(allergy.id!, data);
            if (success) Get.back();
          },
        )),
        15.verticalSpace,
        CustomButton(
          borderRadius: 15,
          text: AppStrings.cancel.tr,
          onTap: () => Get.back(),
          bgColor: AppColors.inACtiveButtonColor,
          fontColor: Colors.black,
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
      ),
      dialogSize: const Size(325, 400),
      value: [controller.selectedDate],
      borderRadius: BorderRadius.circular(15),
    );
    if (dates != null && dates.isNotEmpty) {
      controller.updateDate(dates.first);
    }
  }

  Widget _buildDropdownField({
    required String title,
    required List<String> items,
    required Rx<String?> selectedValue,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0, left: 10.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
        ),
        Obx(() => DropdownButtonFormField<String>(
          value: selectedValue.value,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.white,
          ),
          items: items.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
          onChanged: onChanged,
        )),
      ],
    );
  }
}