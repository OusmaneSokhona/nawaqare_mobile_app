import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_button.dart';

class AddNotesScreen extends StatelessWidget {
  final String? patientId;
  final bool? isEditing;
  final String? diagnosis;
  final String? existingNotes;

  const AddNotesScreen({
    Key? key,
    this.patientId,
    this.isEditing = false,
    this.diagnosis,
    this.existingNotes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController notesController = TextEditingController();
    final TextEditingController diagnosisController = TextEditingController();
    final TextEditingController icdCodeController = TextEditingController();

    // Set initial values if editing
    if (isEditing == true) {
      if (diagnosis != null) diagnosisController.text = diagnosis!;
      if (existingNotes != null) notesController.text = existingNotes!;
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
                      _buildActionButtons(notesController, diagnosisController, icdCodeController),
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
          'Diagnosis',
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
            hintText: 'Enter diagnosis (e.g., Migraine without aura)',
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
          'ICD-10 Code',
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
            hintText: 'Enter ICD-10 code (e.g., G43.909)',
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
          AppStrings.addNote.tr,
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
      TextEditingController notesController,
      TextEditingController diagnosisController,
      TextEditingController icdCodeController,
      ) {
    return Column(
      children: [
        CustomButton(
          borderRadius: 15,
          text: isEditing == true ? "Update Note" : "Add Note",
          onTap: () {
            _saveNote(notesController, diagnosisController, icdCodeController);
          },
        ),
        10.verticalSpace,
        CustomButton(
          borderRadius: 15,
          bgColor: AppColors.inACtiveButtonColor,
          fontColor: Colors.black,
          text: "Cancel",
          onTap: () {
            Get.back();
          },
        ),
      ],
    );
  }

  void _saveNote(
      TextEditingController notesController,
      TextEditingController diagnosisController,
      TextEditingController icdCodeController,
      ) {
    // Validate inputs
    if (notesController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter notes',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Here you would typically save to your backend
    String action = isEditing == true ? 'updated' : 'added';

    Get.back();
    Get.snackbar(
      'Success',
      'Note $action successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );

    // Print for debugging
    print('Note saved for patient: $patientId');
    print('Diagnosis: ${diagnosisController.text}');
    print('ICD-10: ${icdCodeController.text}');
    print('Notes: ${notesController.text}');
  }
}