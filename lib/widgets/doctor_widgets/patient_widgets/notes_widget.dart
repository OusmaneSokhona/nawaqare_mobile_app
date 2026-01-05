import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/doctor_screens/patient_screens/add_notes_screen.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';

import '../../../utils/app_colors.dart';

class NotesWidget extends StatelessWidget {
  const NotesWidget({super.key});

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
        _buildDiagnosisCard(),
        15.verticalSpace,
        CustomButton(borderRadius: 15, text: AppStrings.addNewNotes.tr, onTap: (){
          Get.to(AddNotesScreen());
        }),
        30.verticalSpace,
      ],
    );
  }
  Widget _buildDiagnosisCard() {
    return Container(
      width: 1.sw,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8.sp),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.sp,vertical: 20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                AppStrings.diagnosis.tr,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black),
              ),
              Icon(Icons.description,color: AppColors.primaryColor,size: 20.sp,),
            ],
          ),
          SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Migraine without aura',
                style: TextStyle(fontSize: 14.sp, color: Colors.black87),
              ),
              Text(
                'ID: (ICD-10)',
                style: TextStyle(fontSize: 13.0, color: Colors.grey.shade600),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Text(
            AppStrings.diagnosisNotes.tr,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          const SizedBox(height: 4.0),
          const Text(
            'Symptoms improving, headache frequency reduced from 5 to 2 times per week. Advised patient to continue current regimen and maintain sleep hygiene',
            style: TextStyle(fontSize: 14.0, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}