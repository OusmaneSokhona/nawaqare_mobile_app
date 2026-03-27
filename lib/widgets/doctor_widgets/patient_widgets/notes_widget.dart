import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:patient_app/screens/doctor_screens/patient_screens/add_notes_screen.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import '../../../controllers/doctor_controllers/notes_controller.dart';
import '../../../utils/app_colors.dart';

class NotesWidget extends StatelessWidget {
  final String? patientId;

  const NotesWidget({
    Key? key,
    this.patientId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NoteController controller = Get.put(NoteController());

    if (patientId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.getNotes(patientId: patientId!);
      });
    }

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            AppStrings.notes.tr,
            style: TextStyle(fontSize: 21.sp, fontWeight: FontWeight.w600),
          ),
        ),
        10.verticalSpace,
        Obx(() => _buildNotesList(controller)),
        15.verticalSpace,
        CustomButton(
          borderRadius: 15,
          text: AppStrings.addNewNotes.tr,
          onTap: () async {
            final result = await Get.to(() => AddNotesScreen(
              patientId: patientId,
            ));
            if (result == true && patientId != null) {
              controller.getNotes(patientId: patientId!);
            }
          },
        ),
        30.verticalSpace,
      ],
    );
  }

  Widget _buildNotesList(NoteController controller) {
    if (controller.isLoadingNotes.value) {
      return Container(
        height: 200.h,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          ),
        ),
      );
    }

    if (controller.notesList.isEmpty) {
      return Container(
        height: 150.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.lightGrey.withOpacity(0.2)),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.note_outlined,
                size: 48.sp,
                color: Colors.grey.shade400,
              ),
              10.verticalSpace,
              Text(
                'No notes available',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                'Tap "Add New Notes" to create one',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.notesList.length,
      itemBuilder: (context, index) {
        final note = controller.notesList[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: _buildDiagnosisCard(
            note.doctorId.fullName,
            note.doctorId.profileImage,
            note.diagnosis,
            note.note,
            note.icdCode,
            _formatDate(note.createdAt),
            note.id,
            controller,
          ),
        );
      },
    );
  }

  Widget _buildDiagnosisCard(
      String doctorName,
      String doctorImage,
      String diagnosis,
      String notes,
      String icdCode,
      String date,
      String noteId,
      NoteController controller,
      ) {
    return Container(
      width: 1.sw,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: [
                   (doctorImage.isEmpty||doctorImage==null)?
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        color: AppColors.primaryColor,
                        size: 14.sp,
                      ),
                    ):
                    CircleAvatar(
                      radius: 14.sp,
                      backgroundImage: NetworkImage(doctorImage),
                      backgroundColor: Colors.transparent,
                      onBackgroundImageError: (_, __) {},
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        doctorName,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      final result = await Get.to(() => AddNotesScreen(
                        patientId: patientId,
                        isEditing: true,
                        noteId: noteId,
                        diagnosis: diagnosis,
                        existingNotes: notes,
                        existingIcdCode: icdCode,
                      ));
                      if (result == true && patientId != null) {
                        controller.getNotes(patientId: patientId!);
                      }
                    },
                    child: Icon(
                      Icons.edit_outlined,
                      color: AppColors.primaryColor,
                      size: 18.sp,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  InkWell(
                    onTap: () {
                      _deleteNote(noteId, diagnosis, controller);
                    },
                    child: Icon(
                      Icons.delete_outline,
                      color: AppColors.red,
                      size: 18.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  diagnosis,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  icdCode,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          Text(
            AppStrings.diagnosisNotes.tr,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            notes,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
          SizedBox(height: 12.h),

          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 14.sp,
                color: AppColors.lightGrey,
              ),
              SizedBox(width: 4.w),
              Text(
                date,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.lightGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _deleteNote(String noteId, String diagnosis, NoteController controller) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Delete Note',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete the note "$diagnosis"?',
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              final result = await controller.deleteNote(noteId: noteId);
              if (result) {
                Get.snackbar(
                  'Success',
                  'Note deleted successfully',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.green,
                  colorText: Colors.white,
                );
              } else {
                Get.snackbar(
                  'Error',
                  controller.errorMessage.value,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }
}