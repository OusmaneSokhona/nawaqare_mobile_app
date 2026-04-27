import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/doctor_controllers/follow_up_plan_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_button.dart';

class FollowUpPlanScreen extends StatelessWidget {
  final String consultationId;

  FollowUpPlanScreen({super.key, required this.consultationId});

  late final FollowUpPlanController controller =
      Get.put(FollowUpPlanController(consultationId: consultationId));

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
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              70.verticalSpace,
              _buildHeader(),
              20.verticalSpace,
              Expanded(
                child: Obx(
                  () => controller.isLoading.value
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildPatientInstructionsSection(),
                              20.verticalSpace,
                              _buildObjectivesSection(),
                              20.verticalSpace,
                              _buildRedFlagsSection(),
                              20.verticalSpace,
                              _buildControlVisitsSection(),
                              30.verticalSpace,
                              _buildActionButtons(),
                              30.verticalSpace,
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

  Widget _buildHeader() {
    return Row(
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Follow-Up Plan",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 23.sp,
                  fontWeight: FontWeight.w800,
                  fontFamily: AppFonts.jakartaBold,
                ),
              ),
              5.verticalSpace,
              Text(
                "Plan continuity of care",
                style: TextStyle(
                  color: AppColors.lightGrey,
                  fontSize: 12.sp,
                  fontFamily: AppFonts.jakartaRegular,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPatientInstructionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Patient Instructions",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        10.verticalSpace,
        Container(
          width: 1.sw,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
            child: TextField(
              controller: controller.patientSummaryController,
              maxLines: 4,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: "Instructions in French (patient_summary_fr)",
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: AppColors.lightGrey,
                  fontSize: 14.sp,
                  fontFamily: AppFonts.jakartaRegular,
                ),
              ),
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: AppFonts.jakartaRegular,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildObjectivesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Treatment Objectives",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        10.verticalSpace,
        Obx(
          () => Column(
            children: [
              ...controller.objectives.asMap().entries.map((entry) {
                return Container(
                  margin: EdgeInsets.only(bottom: 10.h),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.inACtiveButtonColor),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24.w,
                        height: 24.w,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            "${entry.key + 1}",
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppFonts.jakartaBold,
                            ),
                          ),
                        ),
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: Text(
                          entry.value,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13.sp,
                            fontFamily: AppFonts.jakartaRegular,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => controller.removeObjective(entry.key),
                        child: Icon(
                          Icons.close,
                          color: AppColors.red,
                          size: 18.sp,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
        10.verticalSpace,
        _buildAddItemRow(
          controller: controller.objectiveInputController,
          hint: "Add an objective",
          onAdd: () => controller.addObjective(controller.objectiveInputController.text),
        ),
      ],
    );
  }

  Widget _buildRedFlagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Red Flags (When to Seek Help)",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        10.verticalSpace,
        Obx(
          () => Column(
            children: [
              ...controller.redFlags.asMap().entries.map((entry) {
                return Container(
                  margin: EdgeInsets.only(bottom: 10.h),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.red.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.red.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_rounded,
                        color: AppColors.red,
                        size: 18.sp,
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: Text(
                          entry.value,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13.sp,
                            fontFamily: AppFonts.jakartaRegular,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => controller.removeRedFlag(entry.key),
                        child: Icon(
                          Icons.close,
                          color: AppColors.red,
                          size: 18.sp,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
        10.verticalSpace,
        _buildAddItemRow(
          controller: controller.redFlagInputController,
          hint: "e.g., Fever > 38.5°C, difficulty breathing",
          onAdd: () => controller.addRedFlag(controller.redFlagInputController.text),
        ),
      ],
    );
  }

  Widget _buildControlVisitsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Control Visits",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        10.verticalSpace,
        Obx(
          () => Column(
            children: [
              ...controller.controlVisits.asMap().entries.map((entry) {
                return Container(
                  margin: EdgeInsets.only(bottom: 10.h),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.inACtiveButtonColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: AppColors.primaryColor,
                                size: 16.sp,
                              ),
                              8.horizontalSpace,
                              Text(
                                DateFormat('MMM d, yyyy').format(entry.value.date),
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppFonts.jakartaBold,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => controller.removeControlVisit(entry.key),
                            child: Icon(
                              Icons.close,
                              color: AppColors.red,
                              size: 18.sp,
                            ),
                          ),
                        ],
                      ),
                      8.verticalSpace,
                      Text(
                        entry.value.description,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.sp,
                          fontFamily: AppFonts.jakartaRegular,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
        10.verticalSpace,
        _buildAddVisitRow(),
      ],
    );
  }

  Widget _buildAddItemRow({
    required TextEditingController controller,
    required String hint,
    required Function() onAdd,
  }) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.lightWhite,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.inACtiveButtonColor),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: AppColors.lightGrey,
                    fontSize: 13.sp,
                    fontFamily: AppFonts.jakartaRegular,
                  ),
                ),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontFamily: AppFonts.jakartaRegular,
                ),
              ),
            ),
          ),
        ),
        10.horizontalSpace,
        InkWell(
          onTap: onAdd,
          child: Container(
            width: 45.w,
            height: 45.w,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddVisitRow() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _selectDate(),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: AppColors.lightWhite,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.inACtiveButtonColor),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: AppColors.lightGrey,
                        size: 16.sp,
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: Text(
                          controller.visitDateController.text.isEmpty
                              ? "Select date"
                              : controller.visitDateController.text,
                          style: TextStyle(
                            color: controller.visitDateController.text.isEmpty
                                ? AppColors.lightGrey
                                : Colors.black,
                            fontSize: 13.sp,
                            fontFamily: AppFonts.jakartaRegular,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.lightWhite,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.inACtiveButtonColor),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  child: TextField(
                    controller: controller.visitDescriptionController,
                    decoration: InputDecoration(
                      hintText: "Description",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: AppColors.lightGrey,
                        fontSize: 13.sp,
                        fontFamily: AppFonts.jakartaRegular,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: AppFonts.jakartaRegular,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        10.verticalSpace,
        SizedBox(
          width: 1.sw,
          child: CustomButton(
            borderRadius: 12,
            text: "Add Visit",
            onTap: () {
              if (controller.visitDateController.text.isNotEmpty &&
                  controller.visitDescriptionController.text.isNotEmpty) {
                final dateStr = controller.visitDateController.text;
                final date = DateFormat('MMM d, yyyy').parse(dateStr);
                controller.addControlVisit(date, controller.visitDescriptionController.text);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Obx(
      () => Column(
        children: [
          if (controller.errorMessage.isNotEmpty)
            Container(
              width: 1.sw,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.red),
              ),
              child: Text(
                controller.errorMessage.value,
                style: TextStyle(
                  color: AppColors.red,
                  fontSize: 12.sp,
                  fontFamily: AppFonts.jakartaRegular,
                ),
              ),
            ),
          if (controller.errorMessage.isNotEmpty) 15.verticalSpace,
          CustomButton(
            borderRadius: 15,
            text: "Save Follow-up Plan",
            isLoading: controller.isSaving.value,
            onTap: () async {
              final success = await controller.saveFollowUpPlan();
              if (success) {
                Future.delayed(const Duration(milliseconds: 500), () {
                  Get.back();
                });
              }
            },
          ),
          12.verticalSpace,
          CustomButton(
            borderRadius: 15,
            text: "Cancel",
            onTap: () => Get.back(),
            bgColor: AppColors.inACtiveButtonColor,
            fontColor: Colors.black,
          ),
        ],
      ),
    );
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      controller.visitDateController.text = DateFormat('MMM d, yyyy').format(picked);
    }
  }
}
