import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_appoinment_controller.dart';
import 'package:patient_app/widgets/patient_widgets/video_call_widgets/setting%20widgets.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/upload_document_widget.dart';

class AddReportScreen extends StatelessWidget {
  AddReportScreen({super.key});

  final DoctorAppointmentController doctorAppointmentController =
  Get.find<DoctorAppointmentController>();

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
              CustomDropdown(
                label: AppStrings.reportType.tr,
                options: doctorAppointmentController.reportTypes,
                currentValue:
                doctorAppointmentController.selectedReportType.value,
                onChanged: (_) {},
              ),
              30.verticalSpace,
              UploadDocumentWidget(
                selectedFileName: doctorAppointmentController.selectedFileName,
                pickFile: () {
                  doctorAppointmentController
                      .pickFile(doctorAppointmentController.selectedFileName);
                },
                title: AppStrings.uploadReport.tr,
                centerText: AppStrings.uploadYourReport.tr,
                acceptedFile: AppStrings.acceptedFilesInfo.tr,
              ),
              30.verticalSpace,
              CustomButton(
                  borderRadius: 15, text: AppStrings.saveReport.tr, onTap: () {}),
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