import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/doctor_controllers/doctor_soap_note_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_button.dart';

class SoapNoteScreen extends StatelessWidget {
  final String consultationId;

  SoapNoteScreen({super.key, required this.consultationId});

  late final DoctorSoapNotesController controller =
      Get.put(DoctorSoapNotesController(consultationId: consultationId));

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
                              if (controller.isSigned.value)
                                _buildSignedBadge(),
                              20.verticalSpace,
                              _buildSoapSection(
                                title: "S - Subjective",
                                hint: "Patient symptoms and complaints",
                                controller: controller.subjectiveController,
                                isReadOnly: controller.isSigned.value,
                              ),
                              20.verticalSpace,
                              _buildSoapSection(
                                title: "O - Objective",
                                hint: "Vital signs, examination findings",
                                controller: controller.objectiveController,
                                isReadOnly: controller.isSigned.value,
                              ),
                              20.verticalSpace,
                              _buildAssessmentSection(),
                              20.verticalSpace,
                              _buildSoapSection(
                                title: "P - Plan",
                                hint: "Treatment plan, medications, follow-up",
                                controller: controller.planController,
                                isReadOnly: controller.isSigned.value,
                              ),
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
                "SOAP Note",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 23.sp,
                  fontWeight: FontWeight.w800,
                  fontFamily: AppFonts.jakartaBold,
                ),
              ),
              5.verticalSpace,
              Text(
                "Structured clinical documentation",
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

  Widget _buildSignedBadge() {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: AppColors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.green),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: AppColors.green,
            size: 20.sp,
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Signed Document",
                  style: TextStyle(
                    color: AppColors.green,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.jakartaBold,
                  ),
                ),
                5.verticalSpace,
                Text(
                  "Signed by ${controller.existingNotes.value?.signedByDoctor ?? 'Doctor'} on ${_formatDate(controller.existingNotes.value?.signedAt)}",
                  style: TextStyle(
                    color: AppColors.darkGrey,
                    fontSize: 11.sp,
                    fontFamily: AppFonts.jakartaRegular,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoapSection({
    required String title,
    required String hint,
    required TextEditingController controller,
    required bool isReadOnly,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
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
              controller: controller,
              readOnly: isReadOnly,
              maxLines: 4,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: hint,
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
                color: isReadOnly ? AppColors.darkGrey : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAssessmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "A - Assessment",
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
              controller: controller.assessmentController,
              readOnly: controller.isSigned.value,
              maxLines: 4,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: "Diagnosis",
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
                color: controller.isSigned.value ? AppColors.darkGrey : Colors.black,
              ),
            ),
          ),
        ),
        15.verticalSpace,
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ICD-10 Code",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                  8.verticalSpace,
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
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
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                      child: TextField(
                        controller: controller.icdCodeController,
                        readOnly: controller.isSigned.value,
                        decoration: InputDecoration(
                          hintText: "e.g., J45.9",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: AppColors.lightGrey,
                            fontSize: 12.sp,
                            fontFamily: AppFonts.jakartaRegular,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontFamily: AppFonts.jakartaRegular,
                          color: controller.isSigned.value ? AppColors.darkGrey : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            15.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ICD-10 Label",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                  8.verticalSpace,
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
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
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                      child: TextField(
                        controller: controller.icdLabelController,
                        readOnly: controller.isSigned.value,
                        decoration: InputDecoration(
                          hintText: "Condition name",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: AppColors.lightGrey,
                            fontSize: 12.sp,
                            fontFamily: AppFonts.jakartaRegular,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontFamily: AppFonts.jakartaRegular,
                          color: controller.isSigned.value ? AppColors.darkGrey : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
          if (!controller.isSigned.value)
            CustomButton(
              borderRadius: 15,
              text: "Sign & Save",
              isLoading: controller.isSaving.value,
              onTap: () => _showSignConfirmation(),
            ),
          if (!controller.isSigned.value) 12.verticalSpace,
          if (!controller.isSigned.value)
            CustomButton(
              borderRadius: 15,
              text: "Save Draft",
              isLoading: controller.isSaving.value,
              onTap: () async {
                final success = await controller.saveSoapNotes();
                if (success) {
                  Future.delayed(const Duration(milliseconds: 500), () {
                    Get.back();
                  });
                }
              },
              bgColor: AppColors.inACtiveButtonColor,
              fontColor: Colors.black,
            ),
          if (controller.isSigned.value) 12.verticalSpace,
          if (controller.isSigned.value)
            CustomButton(
              borderRadius: 15,
              text: "Close",
              onTap: () => Get.back(),
              bgColor: AppColors.inACtiveButtonColor,
              fontColor: Colors.black,
            ),
        ],
      ),
    );
  }

  void _showSignConfirmation() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        title: Text(
          "Sign SOAP Note",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        content: Text(
          "Are you sure you want to sign this SOAP note? This action cannot be reversed.",
          style: TextStyle(
            color: AppColors.darkGrey,
            fontSize: 14.sp,
            fontFamily: AppFonts.jakartaRegular,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 14.sp,
                fontFamily: AppFonts.jakartaBold,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              final success = await controller.signSoapNotes();
              if (success) {
                Future.delayed(const Duration(milliseconds: 500), () {
                  Get.back();
                });
              }
            },
            child: Text(
              "Sign",
              style: TextStyle(
                color: AppColors.green,
                fontSize: 14.sp,
                fontFamily: AppFonts.jakartaBold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "Unknown date";
    return DateFormat('MMM d, yyyy').format(date);
  }
}
