import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/medical_record_controller.dart';
import 'package:patient_app/controllers/doctor_controllers/report_controller.dart';
import 'package:patient_app/screens/doctor_screens/appointment_screens/doctor_follow_up_screen.dart';
import 'package:patient_app/screens/document_view_screen.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';

import '../../../models/patient_detail_doctor_app.dart';

class MedicalRecordWidgets extends StatelessWidget {
  final String? patientId;
ReportController reportController = Get.put(ReportController());
   MedicalRecordWidgets({
    Key? key,
    this.patientId,
  }) : super(key: key);

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 14.h, bottom: 8.h, left: 1.w, right: 16.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 21.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildMedicationCard(MedicalRecordController controller) {
    TextStyle textStyle = TextStyle(fontSize: 14.sp, color: Colors.black87);
    TextStyle detailStyle = TextStyle(fontSize: 13.sp, color: AppColors.lightGrey);
    List<Medication> medications = controller.getMedications();

    return Container(
      width: 1.sw,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(9.sp),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppStrings.currentMedication.tr,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          if (medications.isNotEmpty) ...[
            for (var medication in medications) ...[
              SizedBox(height: 12.h),
              Text(
                medication.name,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '${medication.dosage}, ${medication.frequency}',
                style: textStyle,
              ),
              SizedBox(height: 12.h),
              Text(
                '${AppStrings.refillUntil.tr} ${_formatDate(medication.refillDate)}',
                style: detailStyle,
              ),
              Divider(
                height: 20.h,
                thickness: 0.5.sp,
                color: AppColors.lightGrey,
              ),
            ],
          ] else ...[
            SizedBox(height: 12.h),
            Text(
              'No medications prescribed',
              style: textStyle,
            ),
            Divider(
              height: 20.h,
              thickness: 0.5.sp,
              color: AppColors.lightGrey,
            ),
          ],
          Text(
            AppStrings.allergy.tr,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          10.verticalSpace,
          Text(
            controller.getAllergyName(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          5.verticalSpace,
          Row(
            children: <Widget>[
              Icon(Icons.description, size: 16.sp, color: AppColors.primaryColor),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  'Allergy Record',
                  style: TextStyle(fontSize: 13.sp, color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          5.verticalSpace,
          Text(
            controller.getAllergyDateIdentified(),
            style: TextStyle(fontSize: 13.0, color: Colors.grey.shade600),
          ),
          Divider(
            height: 20.h,
            thickness: 0.5.sp,
            color: AppColors.lightGrey,
          ),
          Text(
            AppStrings.vaccination.tr,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          3.verticalSpace,
          Text(
            controller.getAllergyName(),
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
              Expanded(flex: 3, child: Text(controller.getAllergyReaction(), style: detailStyle)),
              Expanded(flex: 2, child: Text(controller.getAllergySeverity(), style: detailStyle)),
              Expanded(flex: 3, child: Text(controller.getAllergyDateIdentified(), style: detailStyle, textAlign: TextAlign.right)),
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
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14.sp, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosisCard(MedicalRecordController controller) {
    return Container(
      width: 1.sw,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8.sp),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.phone_in_talk, size: 17.sp, color: AppColors.primaryColor),
              SizedBox(width: 6.w),
              Text(
                AppStrings.remoteConsultation.tr,
                style: TextStyle(
                  fontSize: 13.0,
                  color: AppColors.lightGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'Last Consultation',
            style: TextStyle(fontSize: 13.sp, color: AppColors.lightGrey),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                AppStrings.diagnosis.tr,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Text(
                controller.getPrescriptionNumber(),
                style: TextStyle(fontSize: 13.0, color: Colors.grey.shade600),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            controller.getDiagnosis(),
            style: TextStyle(fontSize: 14.sp, color: Colors.black87),
          ),
          SizedBox(height: 16.h),
          Text(
            AppStrings.diagnosisNotes.tr,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            controller.getDiagnosisNotes(),
            style: TextStyle(fontSize: 14.0, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalIndicators(MedicalRecordController controller) {
    return Container(
      width: 1.sw,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.2)),
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.sp),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 16.sp),
      child: Column(
        children: <Widget>[
          _buildVitalRow(AppStrings.height.tr, controller.getHeight()),
          const Divider(height: 1, color: Color(0xFFE0E0E0)),
          _buildVitalRow(AppStrings.weight.tr, controller.getWeight()),
          const Divider(height: 1, color: Color(0xFFE0E0E0)),
          _buildVitalRow(AppStrings.bmi.tr, controller.getBmi()),
          const Divider(height: 1, color: Color(0xFFE0E0E0)),
          _buildVitalRow(AppStrings.bloodPressure.tr, controller.getBloodPressure()),
          const Divider(height: 1, color: Color(0xFFE0E0E0)),
          _buildVitalRow(AppStrings.heartRate.tr, controller.getHeartRate()),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final MedicalRecordController controller = Get.put(MedicalRecordController());

    if (patientId != null) {
      controller.fetchPatientDetails(patientId!);
    }

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          ),
        );
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.errorMessage.value,
                style: TextStyle(color: Colors.red, fontSize: 14.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              CustomButton(
                text: 'Retry',
                onTap: () {
                  if (patientId != null) {
                    controller.fetchPatientDetails(patientId!);
                  }
                },
                height: 40.h, borderRadius: 15,
              ),
            ],
          ),
        );
      }

      if (controller.patientMedicalData.value == null) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildSectionTitle(AppStrings.medicalHistory.tr),
          _buildMedicationCard(controller),
          _buildSectionTitle(AppStrings.medicalVitals.tr),
          _buildVitalIndicators(controller),
          _buildSectionTitle(AppStrings.diagnosis.tr),
          _buildDiagnosisCard(controller),
          10.verticalSpace,
          CustomButton(
            borderRadius: 15,
            text: AppStrings.addFollowUp.tr,
            onTap: () {
              print("Navigating to follow-up screen with appointment ID: ${controller.patientMedicalData.value!.latestAppointment!.id}");
              Get.to(DoctorFollowupScreen(appointmentId: controller.patientMedicalData.value!.latestAppointment!.id));
            },
          ),
          10.verticalSpace,
          CustomButton(
            borderRadius: 15,
            text: AppStrings.viewLastReport.tr,
            onTap: () async {
              reportController.patientId = patientId!;
              await  reportController.fetchReports();
              if(reportController.reports.isEmpty){
                Get.snackbar(
                  'No Reports',
                  'No reports found for this patient.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.inACtiveButtonColor,
                  colorText: Colors.black,
                );
                return;
              }
              Get.to(DocumentViewerScreen(documentUrl: reportController.reports.first.file, fileName: reportController.reports.first.name));
            },
            bgColor: AppColors.inACtiveButtonColor,
            fontColor: Colors.black,
          ),
          30.verticalSpace,
        ],
      );
    });
  }
}