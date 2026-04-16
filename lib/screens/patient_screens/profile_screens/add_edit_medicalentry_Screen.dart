import 'package:calendar_date_picker2/calendar_date_picker2.dart';
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

class AddEditMedicalEntryScreen extends StatelessWidget {
  final String entryType;
  final Map<String, dynamic>? existingData;

  AddEditMedicalEntryScreen({
    super.key,
    required this.entryType,
    this.existingData,
  });

  final MedicalHistoryController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    if (existingData != null) {
      _populateFormWithExistingData();
    }

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
                    existingData == null ? _getAddTitle() : _getEditTitle(),
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
                            _buildFormFields(),
                            30.verticalSpace,
                            CustomButton(
                              borderRadius: 15,
                              text: existingData == null ? AppStrings.addAndSave.tr : "Update",
                              isLoading: controller.isLoading.value,
                              onTap: controller.isLoading.value ? () {} : _handleSubmit,
                            ),
                            12.verticalSpace,
                            CustomButton(
                              borderRadius: 15,
                              text: AppStrings.cancel.tr,
                              bgColor: AppColors.inACtiveButtonColor,
                              fontColor: Colors.black,
                              onTap: () => Get.back(),
                            ),
                            20.verticalSpace,
                          ],
                        ),
                        if (controller.isLoading.value)
                          const Center(child: CircularProgressIndicator()),
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

  String _getAddTitle() {
    switch (entryType) {
      case 'medication':
        return "Add Medication";
      case 'vaccination':
        return "Add Vaccination";
      case 'familyHistory':
        return "Add Family History";
      case 'lifestyle':
        return "Add Lifestyle";
      case 'problem':
        return "Add Problem History";
      case 'allergy':
        return "Add Allergy";
      case 'vitals':
        return "Add Baseline Vitals";
      case 'surgical':
        return "Add Surgical History";
      case 'infection':
        return "Add Infectious History";
      default:
        return "Add Entry";
    }
  }

  String _getEditTitle() {
    switch (entryType) {
      case 'medication':
        return "Edit Medication";
      case 'vaccination':
        return "Edit Vaccination";
      case 'familyHistory':
        return "Edit Family History";
      case 'lifestyle':
        return "Edit Lifestyle";
      case 'problem':
        return "Edit Problem History";
      case 'allergy':
        return "Edit Allergy";
      case 'vitals':
        return "Edit Baseline Vitals";
      case 'surgical':
        return "Edit Surgical History";
      case 'infection':
        return "Edit Infectious History";
      default:
        return "Edit Entry";
    }
  }

  void _populateFormWithExistingData() {
    switch (entryType) {
      case 'medication':
        controller.medicineNameController.text = existingData?['medicineName'] ?? '';
        controller.dosageController.text = existingData?['dosage'] ?? '';
        controller.hasRefill.value = existingData?['refill'] ?? false;
        String statusValue = existingData?['status']?.toString() ?? 'active';
        controller.medicationStatus.value = _capitalizeFirst(statusValue);
        break;
      case 'vaccination':
        controller.vaccineNameController.text = existingData?['vaccineName'] ?? '';
        if (existingData?['date'] != null) {
          controller.updateDate(DateTime.tryParse(existingData?['date']));
        }
        String statusValue = existingData?['status']?.toString() ?? 'pending';
        controller.vaccinationStatus.value = _capitalizeFirst(statusValue);
        break;
      case 'familyHistory':
        controller.familyConditionController.text = existingData?['condition'] ?? '';
        controller.familyAgeController.text = existingData?['age']?.toString() ?? '';
        controller.familyNotesController.text = existingData?['notes'] ?? '';
        controller.activeRelation.value = existingData?['relation'] ?? 'Father';
        String severityValue = existingData?['severity']?.toString() ?? 'mild';
        controller.selectedSeverityFamilyHistory.value = _capitalizeFirst(severityValue);
        break;
      case 'lifestyle':
        String smokingValue = existingData?['smoking']?.toString() ?? 'yes';
        controller.selectedSmoking.value = _capitalizeFirst(smokingValue);
        String alcoholValue = existingData?['alcohol']?.toString() ?? 'none';
        controller.selectedAlcohol.value = _capitalizeFirst(alcoholValue);
        String activityValue = existingData?['physicalActivity']?.toString() ?? 'sedentary';
        controller.selectedActivity.value = _capitalizeFirst(activityValue);
        String dietValue = existingData?['dietType']?.toString() ?? 'balanced';
        controller.selectedDiet.value = _capitalizeFirst(dietValue);
        String sleepValue = existingData?['sleepQuality']?.toString() ?? 'good';
        controller.selectedSleep.value = _capitalizeFirst(sleepValue);
        break;
      case 'problem':
        controller.problemNameController.text = existingData?['problemName'] ?? '';
        controller.treatmentController.text = existingData?['treatment'] ?? '';
        break;
      case 'allergy':
        controller.allergenController.text = existingData?['allergen'] ?? '';
        controller.reactionController.text = existingData?['reaction'] ?? '';
        String severityValue = existingData?['severity']?.toString() ?? 'mild';
        controller.selectedSeverity.value = _capitalizeFirst(severityValue);
        break;
      case 'vitals':
        controller.bpController.text = existingData?['bp'] ?? '';
        controller.weightController.text = existingData?['weight']?.toString() ?? '';
        controller.heightController.text = existingData?['height']?.toString() ?? '';
        break;
      case 'surgical':
        controller.procedureController.text = existingData?['procedure'] ?? '';
        controller.surgicalDateController.text = existingData?['date'] ?? '';
        String severityValue = existingData?['severity']?.toString() ?? 'mild';
        controller.selectedSurgicalSeverity.value = _capitalizeFirst(severityValue);
        break;
      case 'infection':
        controller.infectionTypeController.text = existingData?['infectionType'] ?? '';
        controller.infectionDateController.text = existingData?['date'] ?? '';
        controller.infectionNotesController.text = existingData?['notes'] ?? '';
        break;
    }
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  Widget _buildFormFields() {
    switch (entryType) {
      case 'medication':
        return _buildMedicationForm();
      case 'vaccination':
        return _buildVaccinationForm();
      case 'familyHistory':
        return _buildFamilyHistoryForm();
      case 'lifestyle':
        return _buildLifestyleForm();
      case 'problem':
        return _buildProblemForm();
      case 'allergy':
        return _buildAllergyForm();
      case 'vitals':
        return _buildVitalsForm();
      case 'surgical':
        return _buildSurgicalForm();
      case 'infection':
        return _buildInfectionForm();
      default:
        return Container();
    }
  }

  Widget _buildMedicationForm() {
    return Column(
      children: [
        CustomTextField(
          labelText: "Medication Name",
          hintText: "Enter medication name",
          controller: controller.medicineNameController,
        ),
        10.verticalSpace,
        CustomTextField(
          labelText: "Dosage",
          hintText: "Enter dosage (e.g., 500mg)",
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
              style: TextStyle(color: Colors.grey.shade700, fontSize: 15.sp),
            ),
          ),
        10.verticalSpace,
        _buildRefillField(),
        10.verticalSpace,
        _buildDropdownField(
          title: "Status",
          items: controller.medicationStatusList,
          selectedValue: controller.medicationStatus,
          onChanged: (value) {
            if (value != null) controller.medicationStatus.value = value;
          },
        ),
      ],
    );
  }

  Widget _buildVaccinationForm() {
    return Column(
      children: [
        CustomTextField(
          controller: controller.vaccineNameController,
          labelText: "Vaccination Name",
          hintText: "Enter vaccine name",
        ),
        10.verticalSpace,
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Date",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.jakartaMedium,
            ),
          ),
        ),
        InkWell(
          onTap: () => _showDatePicker(Get.context!),
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
                    fontSize: 14,
                    color: controller.selectedDate == null ? Colors.grey : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(Icons.calendar_today, color: Colors.blue, size: 24),
              ],
            ),
          ),
        ),
        10.verticalSpace,
        _buildDropdownField(
          title: "Status",
          items: controller.vacinationStatusList,
          selectedValue: controller.vaccinationStatus,
          onChanged: (value) {
            if (value != null) controller.vaccinationStatus.value = value;
          },
        ),
        10.verticalSpace,
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Upload Certificate (Optional)",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.jakartaMedium,
            ),
          ),
        ),
        InkWell(
          onTap: controller.pickFile,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
            ),
            child: Obx(
                  () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload_outlined, size: 40, color: Colors.blue.shade700),
                  const SizedBox(height: 12),
                  Text(
                    _getUploadText(controller.selectedFileName.value!),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFamilyHistoryForm() {
    return Column(
      children: [
        _buildDropdownField(
          title: "Relation",
          items: controller.relationList,
          selectedValue: controller.activeRelation,
          onChanged: (value) {
            if (value != null) controller.activeRelation.value = value;
          },
        ),
        10.verticalSpace,
        CustomTextField(
          labelText: "Medical Condition",
          hintText: "Enter condition (e.g., Diabetes)",
          controller: controller.familyConditionController,
        ),
        10.verticalSpace,
        CustomTextField(
          labelText: "Age at Diagnosis",
          hintText: "Enter age",
          controller: controller.familyAgeController,
          keyboardType: TextInputType.number,
        ),
        10.verticalSpace,
        _buildDropdownField(
          title: "Severity",
          items: controller.severityList,
          selectedValue: controller.selectedSeverityFamilyHistory,
          onChanged: (value) {
            if (value != null) controller.selectedSeverityFamilyHistory.value = value;
          },
        ),
        10.verticalSpace,
        CustomTextField(
          labelText: "Notes (Optional)",
          hintText: "Additional notes",
          controller: controller.familyNotesController,
        ),
      ],
    );
  }

  Widget _buildLifestyleForm() {
    return Column(
      children: [
        _buildDropdownField(
          title: "Smoking",
          items: controller.categories['Smoking']!,
          selectedValue: controller.selectedSmoking,
          onChanged: (value) {
            if (value != null) controller.updateSelection('Smoking', value);
          },
        ),
        10.verticalSpace,
        _buildDropdownField(
          title: "Alcohol Use",
          items: controller.categories['Alcohol Use']!,
          selectedValue: controller.selectedAlcohol,
          onChanged: (value) {
            if (value != null) controller.updateSelection('Alcohol Use', value);
          },
        ),
        10.verticalSpace,
        _buildDropdownField(
          title: "Physical Activity",
          items: controller.categories['Physical Activity']!,
          selectedValue: controller.selectedActivity,
          onChanged: (value) {
            if (value != null) controller.updateSelection('Physical Activity', value);
          },
        ),
        10.verticalSpace,
        _buildDropdownField(
          title: "Diet Type",
          items: controller.categories['Diet Type']!,
          selectedValue: controller.selectedDiet,
          onChanged: (value) {
            if (value != null) controller.updateSelection('Diet Type', value);
          },
        ),
        10.verticalSpace,
        _buildDropdownField(
          title: "Sleep Quality",
          items: controller.categories['Sleep Quality']!,
          selectedValue: controller.selectedSleep,
          onChanged: (value) {
            if (value != null) controller.updateSelection('Sleep Quality', value);
          },
        ),
      ],
    );
  }

  Widget _buildProblemForm() {
    return Column(
      children: [
        CustomTextField(
          labelText: "Problem Name",
          hintText: "Enter medical problem",
          controller: controller.problemNameController,
        ),
        10.verticalSpace,
        CustomTextField(
          labelText: "Treatment",
          hintText: "Enter treatment details",
          controller: controller.treatmentController,
        ),
        10.verticalSpace,
        if (controller.allDoctorList.isNotEmpty)
          _buildDoctorDropdown(),
      ],
    );
  }

  Widget _buildAllergyForm() {
    return Column(
      children: [
        CustomTextField(
          labelText: "Allergen",
          hintText: "Enter allergen (e.g., Penicillin)",
          controller: controller.allergenController,
        ),
        10.verticalSpace,
        CustomTextField(
          labelText: "Reaction",
          hintText: "Describe reaction",
          controller: controller.reactionController,
        ),
        10.verticalSpace,
        _buildDropdownField(
          title: "Severity",
          items: controller.severityList,
          selectedValue: controller.selectedSeverity,
          onChanged: (value) {
            if (value != null) controller.selectedSeverity.value = value;
          },
        ),
      ],
    );
  }

  Widget _buildVitalsForm() {
    return Column(
      children: [
        CustomTextField(
          labelText: "Blood Pressure",
          hintText: "e.g., 120/80",
          controller: controller.bpController,
        ),
        10.verticalSpace,
        CustomTextField(
          labelText: "Weight (kg)",
          hintText: "Enter weight in kg",
          controller: controller.weightController,
          keyboardType: TextInputType.number,
        ),
        10.verticalSpace,
        CustomTextField(
          labelText: "Height (cm)",
          hintText: "Enter height in cm",
          controller: controller.heightController,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildSurgicalForm() {
    return Column(
      children: [
        CustomTextField(
          labelText: "Procedure",
          hintText: "Enter surgical procedure",
          controller: controller.procedureController,
        ),
        10.verticalSpace,
        CustomTextField(
          labelText: "Date",
          hintText: "YYYY-MM-DD",
          controller: controller.surgicalDateController,
        ),
        10.verticalSpace,
        _buildDropdownField(
          title: "Severity",
          items: controller.severityList,
          selectedValue: controller.selectedSurgicalSeverity,
          onChanged: (value) {
            if (value != null) controller.selectedSurgicalSeverity.value = value;
          },
        ),
      ],
    );
  }

  Widget _buildInfectionForm() {
    return Column(
      children: [
        CustomTextField(
          labelText: "Infection Type",
          hintText: "Enter infection type",
          controller: controller.infectionTypeController,
        ),
        10.verticalSpace,
        CustomTextField(
          labelText: "Date",
          hintText: "YYYY-MM-DD",
          controller: controller.infectionDateController,
        ),
        10.verticalSpace,
        CustomTextField(
          labelText: "Notes",
          hintText: "Additional notes",
          controller: controller.infectionNotesController,
        ),
      ],
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
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, fontFamily: AppFonts.jakartaMedium),
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
                            : const AssetImage("assets/demo_images/demo_doctor.jpeg") as ImageProvider,
                      ),
                      10.horizontalSpace,
                      Text(doctor.displayName ?? "Unknown Doctor", style: const TextStyle(fontSize: 15)),
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
            "Refill",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, fontFamily: AppFonts.jakartaMedium),
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

  Widget _buildDropdownField({
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
              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.black87),
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

  void _showDatePicker(BuildContext context) async {
    final values = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.single,
        selectedDayHighlightColor: Colors.blue,
        centerAlignModePicker: true,
      ),
      dialogSize: const Size(325, 400),
      value: [controller.selectedDate],
      borderRadius: BorderRadius.circular(15),
    );

    if (values != null && values.isNotEmpty) {
      controller.updateDate(values.first);
    }
  }

  String _getUploadText(String value) {
    if (value == 'No file selected') return "Upload certificate (optional)";
    if (value == 'File selection cancelled') return "Selection cancelled";
    return value;
  }

  void _handleSubmit() {
    switch (entryType) {
      case 'medication':
        controller.addMedication();
        break;
      case 'vaccination':
        controller.addVaccination();
        break;
      case 'familyHistory':
        controller.addFamilyHistory();
        break;
      case 'lifestyle':
        controller.addLifestyle();
        break;
      case 'problem':
        controller.addProblemHistory();
        break;
      case 'allergy':
        controller.addAllergy();
        break;
      case 'vitals':
        controller.addBaselineVitals();
        break;
      case 'surgical':
        controller.addSurgicalHistory();
        break;
      case 'infection':
        controller.addInfectiousHistory();
        break;
    }
  }
}