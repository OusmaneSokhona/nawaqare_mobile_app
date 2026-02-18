import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/doctor_screens/patient_screens/add_notes_screen.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import '../../../utils/app_colors.dart';

class NotesWidget extends StatelessWidget {
  final String? patientId;

  const NotesWidget({
    Key? key,
    this.patientId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        _buildNotesList(),
        15.verticalSpace,
        CustomButton(
          borderRadius: 15,
          text: AppStrings.addNewNotes.tr,
          onTap: () {
            Get.to(() => AddNotesScreen(
              patientId: patientId,
            ));
          },
        ),
        30.verticalSpace,
      ],
    );
  }

  Widget _buildNotesList() {
    return Column(
      children: [
        _buildDiagnosisCard(
          'Dr. Sarah Smith',
          'Migraine without aura',
          'Symptoms improving, headache frequency reduced from 5 to 2 times per week. Advised patient to continue current regimen and maintain sleep hygiene',
          '12 Sep 2025',
          'ID: MIG-001',
        ),
        10.verticalSpace,
        _buildDiagnosisCard(
          'Dr. Michael Johnson',
          'Hypertension',
          'Blood pressure reading 130/85. Patient advised to reduce salt intake and continue medication. Follow-up in 2 weeks.',
          '05 Sep 2025',
          'ID: HYP-002',
        ),
        10.verticalSpace,
        _buildDiagnosisCard(
          'Dr. Emily Williams',
          'Seasonal Allergies',
          'Prescribed antihistamines. Patient reported itching and sneezing. Recommended avoiding triggers.',
          '28 Aug 2025',
          'ID: ALG-003',
        ),
      ],
    );
  }

  Widget _buildDiagnosisCard(
      String doctorName,
      String diagnosis,
      String notes,
      String date,
      String id,
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
          // Header with doctor name and actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: [
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
                    onTap: () {
                      _editNote(diagnosis);
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
                      _deleteNote(diagnosis);
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

          // Diagnosis and ID
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
                  id,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Notes
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

          // Date
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

  void _editNote(String diagnosis) {
    Get.to(() => AddNotesScreen(
      patientId: patientId,
      isEditing: true,
      diagnosis: diagnosis,
    ));
  }

  void _deleteNote(String diagnosis) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Delete Note',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete the note for "$diagnosis"?',
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
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Deleted',
                'Note deleted successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
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
}