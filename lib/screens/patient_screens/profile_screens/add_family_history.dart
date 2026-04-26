import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/medical_history_controller.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';

class AddFamilyHistory extends StatelessWidget {
  AddFamilyHistory({super.key});

  final MedicalHistoryController controller = Get.find<MedicalHistoryController>();

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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    AppStrings.addFamilyHistory.tr,
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
                child: Obx(
                      () => SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            30.verticalSpace,
                            _buildDropdownField(
                              title: AppStrings.relation.tr,
                              items: controller.relationList,
                              selectedValue: controller.activeRelation,
                              onChanged: (value) {
                                if (value != null) {
                                  controller.activeRelation.value = value;
                                }
                              },
                            ),
                            12.verticalSpace,
                            CustomTextField(
                              labelText: AppStrings.condition.tr,
                              hintText: AppStrings.hypertension.tr,
                              controller: controller.familyConditionController,
                            ),
                            12.verticalSpace,
                            _buildDropdownField(
                              title: AppStrings.severity.tr,
                              items: controller.severityList,
                              selectedValue: controller.selectedSeverityFamilyHistory,
                              onChanged: (value) {
                                if (value != null) {
                                  controller.selectedSeverityFamilyHistory.value = value;
                                }
                              },
                            ),
                            12.verticalSpace,
                            CustomTextField(
                              labelText: AppStrings.age.tr,
                              hintText: AppStrings.ageHint.tr,
                              controller: controller.familyAgeController,
                              keyboardType: TextInputType.number,
                            ),
                            16.verticalSpace,
                            Text(
                              AppStrings.note.tr,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            6.verticalSpace,
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: TextField(
                                controller: controller.familyNotesController,
                                maxLines: 5,
                                minLines: 3,
                                textAlignVertical: TextAlignVertical.top,
                                decoration: InputDecoration(
                                  hintText: AppStrings.writeNoteToDoctor.tr,
                                  hintStyle: TextStyle(color: Colors.grey.shade500),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                            40.verticalSpace,
                            CustomButton(
                              borderRadius: 15,
                              text: AppStrings.addAndSave.tr,
                              isLoading: controller.isLoading.value,
                              onTap: controller.isLoading.value ? (){} : controller.addFamilyHistory,
                            ),
                            12.verticalSpace,
                            CustomButton(
                              borderRadius: 15,
                              text: AppStrings.cancel.tr,
                              bgColor: AppColors.inACtiveButtonColor,
                              fontColor: Colors.black,
                              onTap: controller.isLoading.value ? (){} : () => Get.back(),
                            ),
                            60.verticalSpace,
                          ],
                        ),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
          padding: const EdgeInsets.only(bottom: 6.0, left: 4.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Obx(
                () => DropdownButtonFormField<String>(
              value: selectedValue.value,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: InputBorder.none,
              ),
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: AppColors.darkGrey),
              style: TextStyle(fontSize: 16.sp, color: Colors.black),
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value.tr),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}