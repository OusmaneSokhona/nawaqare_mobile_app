import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';

class MedicalRecordWidgets extends StatelessWidget {
  const MedicalRecordWidgets({super.key});

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding:  EdgeInsets.only(top: 14.h, bottom: 8.h, left: 1.w, right: 16.w),
      child: Text(
        title,
        style:  TextStyle(
          fontSize: 21.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildMedicationCard() {
    TextStyle textStyle = TextStyle(fontSize: 14.sp, color: Colors.black87);
    TextStyle detailStyle = TextStyle(fontSize: 13.sp, color:AppColors.lightGrey);

    return Container(
      width: 1.sw,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.lightGrey.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(9.sp)
      ),
      padding: EdgeInsets.symmetric(horizontal:16.sp,vertical: 20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppStrings.currentMedication.tr,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          Text(
            'Amoxicillin 500mg',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          const SizedBox(height: 4.0),
          Text(
            '1 tablet, twice daily after meals',
            style: textStyle,
          ),
          const SizedBox(height: 12.0),
          Text(
            '${AppStrings.refillUntil.tr} Oct 15, 2025',
            style: detailStyle,
          ),
          const SizedBox(height: 4.0),
          Text(
            '${AppStrings.lastUpdated.tr}: 12 Sept 2025',
            style: detailStyle,
          ),
          Divider(
            height: 20.h,
            thickness: 0.5.sp,
            color: AppColors.lightGrey,
          ),
          Text(
            AppStrings.allergy.tr,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          10.verticalSpace,
          Text(
            'Influenza',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          5.verticalSpace,
          Row(
            children: <Widget>[
              Icon(Icons.description, size: 16, color: AppColors.primaryColor),
              SizedBox(width: 4),
              Text(
                'Skin_Test_2024.pdf',
                style: TextStyle(fontSize: 13.sp, color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          5.verticalSpace,
          Text(
            '12/sep/2025',
            style: TextStyle(fontSize: 13.0, color: Colors.grey.shade600),
          ),
          Divider(
            height: 20.h,
            thickness: 0.5.sp,
            color: AppColors.lightGrey,
          ),
          Text(
            AppStrings.vaccination.tr,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          3.verticalSpace,
          Text(
            'Pencillin',
            style: textStyle,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(flex: 3, child: Text(AppStrings.reaction.tr, style: textStyle)),
              Expanded(flex: 2, child: Text(AppStrings.severity.tr, style: textStyle)),
              Expanded(flex: 3, child: Text(AppStrings.dateIdentified.tr, style: textStyle, textAlign: TextAlign.right)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(flex: 3, child: Text("Rash", style: detailStyle)),
              Expanded(flex: 2, child: Text("mild", style: detailStyle)),
              Expanded(flex: 3, child: Text("06/sep/2025", style: detailStyle, textAlign: TextAlign.right)),
            ],
          ),

        ],
      ),
    );
  }

  Widget _buildVitalRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          Text(
            value,
            style:  TextStyle(fontSize: 14.sp, color: Colors.black87),
          ),
        ],
      ),
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
            children: <Widget>[
              Icon(Icons.phone_in_talk, size: 17.sp, color:AppColors.primaryColor),
              SizedBox(width: 6),
              Text(
                AppStrings.remoteConsultation.tr,
                style: TextStyle(fontSize: 13.0, color:AppColors.lightGrey, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(height: 4.0),
          Text(
            'Monday, Oct 11:00-12:00 AM',
            style: TextStyle(fontSize: 13.sp, color: AppColors.lightGrey),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                AppStrings.diagnosis.tr,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black),
              ),
              Text(
                'ID: (ICD-10)',
                style: TextStyle(fontSize: 13.0, color: Colors.grey.shade600),
              ),
            ],
          ),
          SizedBox(height: 4.0),
          Text(
            'Migraine without aura',
            style: TextStyle(fontSize: 14.sp, color: Colors.black87),
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

  Widget _buildVitalIndicators() {
    return Container(
      width: 1.sw,
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGrey.withOpacity(0.2)),
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.sp)
      ),
      padding: EdgeInsets.symmetric(horizontal:16.sp,vertical: 16.sp,),
      child: Column(
        children: <Widget>[
          _buildVitalRow(AppStrings.height.tr, '165 cm'),
          const Divider(height: 1, color: Color(0xFFE0E0E0)),
          _buildVitalRow(AppStrings.weight.tr, '60 kg'),
          const Divider(height: 1, color: Color(0xFFE0E0E0)),
          _buildVitalRow(AppStrings.bmi.tr, '22.0'),
          const Divider(height: 1, color: Color(0xFFE0E0E0)),
          _buildVitalRow(AppStrings.bloodPressure.tr, '120/80 mmHg'),
          const Divider(height: 1, color: Color(0xFFE0E0E0)),
          _buildVitalRow(AppStrings.heartRate.tr, '72 bpm'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildSectionTitle(AppStrings.medicalHistory.tr),
        _buildMedicationCard(),
        _buildSectionTitle(AppStrings.medicalVitals.tr),
        _buildVitalIndicators(),
        _buildSectionTitle(AppStrings.medicalVitals.tr),
        _buildDiagnosisCard(),
        10.verticalSpace,
        CustomButton(borderRadius: 15, text: AppStrings.addFollowUp.tr, onTap: (){}),
        10.verticalSpace,
        CustomButton(borderRadius: 15, text: AppStrings.viewLastReport.tr, onTap: (){},bgColor: AppColors.inACtiveButtonColor,fontColor: Colors.black,),
        30.verticalSpace,
      ],
    );
  }
}