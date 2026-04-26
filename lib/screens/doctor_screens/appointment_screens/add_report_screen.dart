import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/report_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/patient_widgets/video_call_widgets/setting widgets.dart';
import '../../../widgets/upload_document_widget.dart';

class AddReportScreen extends StatelessWidget {
  AddReportScreen({super.key, required this.patientId, required this.doctorId});

  final String patientId;
  final String doctorId;
  final ReportController reportController = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    reportController.initialize(patientId, doctorId);

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
              Row(
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
                    AppStrings.addReport.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              30.verticalSpace,
              Obx(() => CustomDropdown(
                label: AppStrings.reportType.tr,
                options: const ['Blood Test', 'X-Ray', 'MRI', 'CT Scan', 'Ultrasound', 'Other'],
                currentValue: reportController.selectedReportType.value,
                onChanged: (value) {
                  reportController.selectedReportType.value = value!;
                },
              )),
              30.verticalSpace,
              UploadDocumentWidget(
                selectedFileName: reportController.selectedFileName,
                pickFile: () {
                  reportController.pickFile();
                },
                title: AppStrings.uploadReport.tr,
                centerText: AppStrings.uploadYourReport.tr,
                acceptedFile: AppStrings.acceptedFilesInfo.tr,
              ),
              30.verticalSpace,
              Obx(() => CustomButton(
                borderRadius: 15,
                text: AppStrings.saveReport.tr,
                isLoading: reportController.isLoading.value,
                onTap: () {
                  if (reportController.selectedReportType.value.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'Please select a report type',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  reportController.addReportWithFile(
                    patientId: patientId,
                    name: reportController.selectedFileName.value?.split('/').last ?? 'report',
                    category: reportController.selectedReportType.value,
                  );
                },
              )),
              10.verticalSpace,
              CustomButton(
                borderRadius: 15,
                text: AppStrings.cancel.tr,
                onTap: () {
                  Get.back();
                },
                bgColor: AppColors.inACtiveButtonColor,
                fontColor: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}