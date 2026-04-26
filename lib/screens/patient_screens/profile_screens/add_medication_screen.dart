import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/medical_history_controller.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import '../../../models/doctor_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';

class AddMedicationScreen extends StatelessWidget {
  AddMedicationScreen({super.key});

  final MedicalHistoryController controller = Get.find();

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
                    AppStrings.addMedication.tr,
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
                  child: Obx(
                        () => Stack(
                      children: [
                        Column(
                          children: [
                            30.verticalSpace,
                            CustomTextField(
                              labelText: AppStrings.medicationName.tr,
                              hintText: AppStrings.metforminHint.tr,
                              controller: controller.medicineNameController,
                            ),
                            10.verticalSpace,
                            CustomTextField(
                              labelText: AppStrings.dosage.tr,
                              hintText: AppStrings.dosageHint.tr,
                              controller: controller.dosageController,
                            ),
                            10.verticalSpace,
                            if (controller.allDoctorList.isNotEmpty)
                              _buildDoctorDropdown()
                            else
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                child: Text(
                                  "No doctors available",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ),
                            10.verticalSpace,
                            _buildRefillField(),
                            10.verticalSpace,
                            buildDropdownField(
                              title: AppStrings.status.tr,
                              items: controller.medicationStatusList,
                              selectedValue: controller.medicationStatus,
                              onChanged: (value) {
                                if (value != null) {
                                  controller.medicationStatus.value = value;
                                }
                              },
                            ),
                            30.verticalSpace,
                            CustomButton(
                              borderRadius: 15,
                              text: AppStrings.addAndSave.tr,
                              isLoading: controller.isLoading.value,
                              onTap: controller.isLoading.value ? (){} : controller.addMedication,
                            ),
                            12.verticalSpace,
                            CustomButton(
                              borderRadius: 15,
                              text: AppStrings.cancel.tr,
                              bgColor: AppColors.inACtiveButtonColor,
                              fontColor: Colors.black,
                              onTap: controller.isLoading.value ? (){} : () => Get.back(),
                            ),
                            20.verticalSpace,
                          ],
                        ),
                        if (controller.isLoading.value)
                          Container(
                            color: Colors.black.withOpacity(0.3),
                            child: const Center(child: CircularProgressIndicator()),
                          ),
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

  Widget _buildDoctorDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 10.0),
          child: Text(
            "Doctor",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.jakartaMedium,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Obx(
                () => DropdownButton<DoctorModel>(
              value: controller.selectedDoctor.value,
              isExpanded: true,
              underline: const SizedBox(),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              items: controller.allDoctorList.map((doctor) {
                return DropdownMenuItem<DoctorModel>(
                  value: doctor,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: doctor.profileImage != null
                            ? NetworkImage(doctor.profileImage!)
                            :  AssetImage("assets/demo_images/demo_doctor.jpeg"),
                      ),
                      10.horizontalSpace,
                      Text(
                        doctor.displayName ?? "Unknown Doctor",
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (DoctorModel? newValue) {
                controller.selectedDoctor.value = newValue;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRefillField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 10.0),
          child: Text(
            AppStrings.refill.tr,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.jakartaMedium,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Obx(
                () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.hasRefill.value ? 'Yes (Refill available)' : 'No refill',
                  style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                ),
                Switch(
                  value: controller.hasRefill.value,
                  onChanged: (value) => controller.hasRefill.value = value,
                  activeColor: AppColors.primaryColor,
                  activeTrackColor: AppColors.primaryColor.withOpacity(0.5),
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Widget buildDropdownField({
    required String title,
    required List<String> items,
    required Rx<String?> selectedValue,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 10.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Obx(
                () => DropdownButtonFormField<String>(
              value: selectedValue.value,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              style: const TextStyle(fontSize: 14, color: Colors.black),
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}