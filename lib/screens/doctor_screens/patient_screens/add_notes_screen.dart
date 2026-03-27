import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import '../../../controllers/doctor_controllers/notes_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_button.dart';

class AddNotesScreen extends StatelessWidget {
  final String? patientId;
  final bool? isEditing;
  final String? noteId;
  final String? diagnosis;
  final String? existingNotes;
  final String? existingIcdCode;

  const AddNotesScreen({
    Key? key,
    this.patientId,
    this.isEditing = false,
    this.noteId,
    this.diagnosis,
    this.existingNotes,
    this.existingIcdCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NoteController controller = Get.put(NoteController());
    final TextEditingController notesController = TextEditingController();
    final TextEditingController diagnosisController = TextEditingController();
    final TextEditingController icdCodeController = TextEditingController();

    if (isEditing == true) {
      if (diagnosis != null) diagnosisController.text = diagnosis!;
      if (existingNotes != null) notesController.text = existingNotes!;
      if (existingIcdCode != null) icdCodeController.text = existingIcdCode!;
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
            children: [
              70.verticalSpace,
              _buildAppBar(),
              20.verticalSpace,
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _buildDiagnosisField(diagnosisController),
                      15.verticalSpace,
                      _buildICDCodeField(icdCodeController),
                      15.verticalSpace,
                      _buildNotesField(notesController),
                      30.verticalSpace,
                      Obx(() => _buildActionButtons(
                        controller,
                        notesController,
                        diagnosisController,
                        icdCodeController,
                      )),
                      20.verticalSpace,
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
          onTap: () {
            Get.delete<NoteController>();
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
          isEditing == true ? 'Edit Note' : AppStrings.addNotes.tr,
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

  Widget _buildDiagnosisField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Diagnosis *',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.jakartaMedium,
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
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: CustomTextField(
            controller: controller,
            hintText: 'Enter diagnosis (e.g., Acute Bronchitis)',
            prefixIcon: Icons.medical_services_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildICDCodeField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ICD-10 Code *',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.jakartaMedium,
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
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: CustomTextField(
            controller: controller,
            hintText: 'Enter ICD-10 code (e.g., J20.9)',
            prefixIcon: Icons.code,
          ),
        ),
      ],
    );
  }

  Widget _buildNotesField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppStrings.addNote.tr} *',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.jakartaMedium,
          ),
        ),
        8.verticalSpace,
        Container(
          width: 1.sw,
          height: 250.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: TextField(
              controller: controller,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: AppStrings.enterNotesHint.tr,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: AppColors.lightGrey,
                  fontSize: 14.sp,
                ),
              ),
              style: TextStyle(
                fontSize: 15.sp,
                fontFamily: AppFonts.jakartaRegular,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
      NoteController controller,
      TextEditingController notesController,
      TextEditingController diagnosisController,
      TextEditingController icdCodeController,
      ) {
    return Column(
      children: [
        if (controller.errorMessage.value.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 16.sp),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      controller.errorMessage.value,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        CustomButton(
          borderRadius: 15,
          text: isEditing == true ? "Update Note" : "Add Note",
          isLoading: controller.isLoading.value,
          onTap: () async {
            final diagnosis = diagnosisController.text.trim();
            final icdCode = icdCodeController.text.trim();
            final notes = notesController.text.trim();

            if (diagnosis.isEmpty) {
              Get.snackbar(
                'Error',
                'Please enter diagnosis',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              return;
            }

            if (icdCode.isEmpty) {
              Get.snackbar(
                'Error',
                'Please enter ICD-10 code',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              return;
            }

            if (notes.isEmpty) {
              Get.snackbar(
                'Error',
                'Please enter notes',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              return;
            }

            if (diagnosis.length < 3) {
              Get.snackbar(
                'Error',
                'Diagnosis must be at least 3 characters long',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              return;
            }

            if (notes.length < 5) {
              Get.snackbar(
                'Error',
                'Notes must be at least 5 characters long',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              return;
            }

            if (isEditing == true) {
              final result = await controller.updateNote(
                noteId: noteId!,
                diagnosis: diagnosis,
                note: notes,
                icdCode: icdCode,
              );

              if (result != null) {
                Get.back(result: true);
                Get.snackbar(
                  'Success',
                  'Note updated successfully',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.green,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                );
              } else {
                Get.snackbar(
                  'Error',
                  controller.errorMessage.value,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 3),
                );
              }
            } else {
              final result = await controller.createNote(
                patientId: patientId!,
                diagnosis: diagnosis,
                note: notes,
                icdCode: icdCode,
              );

              if (result != null) {
                Get.back(result: true);
                Get.snackbar(
                  'Success',
                  'Note added successfully',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.green,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                );
              } else {
                Get.snackbar(
                  'Error',
                  controller.errorMessage.value,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 3),
                );
              }
            }
          },
        ),
        10.verticalSpace,
        CustomButton(
          borderRadius: 15,
          bgColor: AppColors.inACtiveButtonColor,
          fontColor: Colors.black,
          text: "Cancel",
          onTap: () {
            Get.delete<NoteController>();
            Get.back();
          },
        ),
      ],
    );
  }
}