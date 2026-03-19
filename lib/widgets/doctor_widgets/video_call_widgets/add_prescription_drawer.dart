import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/appointment_controllers/video_call_controller.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import '../../../controllers/patient_controllers/appointment_controllers/create_prescription_controller.dart';
import '../../../utils/app_fonts.dart';

class AddPrescriptionDrawer extends GetView<VideoCallController> {
  const AddPrescriptionDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final CreatePrescriptionController prescriptionController = Get.put(CreatePrescriptionController());

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
                      AppStrings.addPrescription.tr,
                      style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    10.verticalSpace,
                    CustomTextField(
                      labelText: "Patient Name",
                      hintText: "Enter patient name",
                      controller: prescriptionController.patientNameController,
                    ),
                    10.verticalSpace,
                    CustomTextField(
                      labelText: "Diagnosis",
                      hintText: "Enter diagnosis",
                      controller: prescriptionController.diagnosisController,
                    ),
                    10.verticalSpace,
                    Text(
                      "Add Medication",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontFamily: AppFonts.jakartaBold,
                      ),
                    ),
                    10.verticalSpace,
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        children: [
                          CustomTextField(
                            labelText: "Medicine Name",
                            hintText: "e.g., Paracetamol",
                            controller: prescriptionController.medicineNameController,
                          ),
                          8.verticalSpace,
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  labelText: "Dosage",
                                  hintText: "e.g., 1 tablet",
                                  controller: prescriptionController.dosageController,
                                ),
                              ),
                              8.horizontalSpace,
                              Expanded(
                                child: CustomTextField(
                                  labelText: "Frequency",
                                  hintText: "e.g., Twice daily (BD)",
                                  controller: prescriptionController.frequencyController,
                                ),
                              ),
                            ],
                          ),
                          8.verticalSpace,
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  labelText: "Duration",
                                  hintText: "e.g., 5 days",
                                  controller: prescriptionController.durationController,
                                ),
                              ),

                            ],
                          ),
                          8.verticalSpace,
                          CustomTextField(
                            labelText: "Instructions",
                            hintText: "e.g., Take after breakfast and dinner",
                            controller: prescriptionController.instructionsController,
                          ),
                          8.verticalSpace,
                          CustomTextField(
                            labelText: "Special Instructions",
                            hintText: "e.g., Complete the full course",
                            controller: prescriptionController.specialInstructionController,
                          ),
                          10.verticalSpace,
                          CustomButton(
                            text: "Add Medication",
                            onTap: () {
                              prescriptionController.addMedication();
                            },
                            borderRadius: 10,
                            height: 40.h,
                          ),
                        ],
                      ),
                    ),
                    10.verticalSpace,
                    Obx(
                          () => prescriptionController.medications.isNotEmpty
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Added Medications",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          8.verticalSpace,
                          ...prescriptionController.medications.asMap().entries.map(
                                (entry) {
                              int index = entry.key;
                              Map<String, dynamic> med = entry.value;
                              return Container(
                                margin: EdgeInsets.only(bottom: 8.h),
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            med['name'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                          Text(
                                            "${med['dosage']} - ${med['frequency']}",
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                        size: 20.sp,
                                      ),
                                      onPressed: () {
                                        prescriptionController.removeMedication(index);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      )
                          : const SizedBox(),
                    ),
                    10.verticalSpace,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Notes",
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
                        border: Border.all(
                          color: AppColors.lightGrey.withOpacity(0.2),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          vertical: 10.h,
                        ),
                        child: TextField(
                          controller: prescriptionController.notesController,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            hintText: "add notes",
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: AppFonts.jakartaRegular,
                          ),
                        ),
                      ),
                    ),
                    10.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Issue Date",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              5.verticalSpace,
                              InkWell(
                                onTap: () async {
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: prescriptionController.issueDate.value,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2030),
                                  );
                                  if (picked != null) {
                                    prescriptionController.updateIssueDate(picked);
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Obx(
                                            () => Text(
                                          "${prescriptionController.issueDate.value.year}-${prescriptionController.issueDate.value.month.toString().padLeft(2, '0')}-${prescriptionController.issueDate.value.day.toString().padLeft(2, '0')}",
                                          style: TextStyle(fontSize: 14.sp),
                                        ),
                                      ),
                                      Icon(Icons.calendar_today, size: 16.sp, color: AppColors.primaryColor),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        10.horizontalSpace,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Valid Until",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              5.verticalSpace,
                              InkWell(
                                onTap: () async {
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: prescriptionController.validUntil.value,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2030),
                                  );
                                  if (picked != null) {
                                    prescriptionController.updateValidUntil(picked);
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Obx(
                                            () => Text(
                                          "${prescriptionController.validUntil.value.year}-${prescriptionController.validUntil.value.month.toString().padLeft(2, '0')}-${prescriptionController.validUntil.value.day.toString().padLeft(2, '0')}",
                                          style: TextStyle(fontSize: 14.sp),
                                        ),
                                      ),
                                      Icon(Icons.calendar_today, size: 16.sp, color: AppColors.primaryColor),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    20.verticalSpace,
                    Obx(
                          () => prescriptionController.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : Column(
                        children: [
                          CustomButton(
                            borderRadius: 15,
                            text: "Save Prescription",
                            onTap: () {
                              prescriptionController.savePrescription(controller.appointmentId.value);
                            },
                          ),
                        ],
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
              decoration: BoxDecoration(
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
                  prescriptionController.clearForm();
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