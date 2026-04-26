import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_appoinment_controller.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../../widgets/custom_button.dart';

class EditNotesScreen extends StatelessWidget {
  final String appointmentId;

  EditNotesScreen({super.key, required this.appointmentId});

  final DoctorAppointmentController doctorAppointmentController =
  Get.find<DoctorAppointmentController>();

  @override
  Widget build(BuildContext context) {
    doctorAppointmentController.notesController.text = doctorAppointmentController.clinicalNote.value.drNotes;

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
                    AppStrings.editNotes.tr,
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
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppStrings.editNote.tr,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.jakartaBold,
                  ),
                ),
              ),
              10.verticalSpace,
              Container(
                width: 1.sw,
                height: 350.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                  child: TextField(
                    maxLines: null,
                    expands: true,
                    controller: doctorAppointmentController.notesController,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      hintText: AppStrings.enterNotesHint.tr,
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: AppFonts.jakartaRegular,
                    ),
                  ),
                ),
              ),
              30.verticalSpace,
              Obx(() => CustomButton(
                borderRadius: 15,
                text: AppStrings.noteSave.tr,
                isLoading: doctorAppointmentController.isLoading.value,
                onTap: () async {
                  if (doctorAppointmentController.notesController.text.trim().isNotEmpty) {
                    if (doctorAppointmentController.clinicalNote.value.drNotes.isNotEmpty) {
                      await doctorAppointmentController.updateClinicalNotes(
                        appointmentId,
                        doctorAppointmentController.notesController.text.trim(),
                      );
                    } else {
                      await doctorAppointmentController.addClinicalNotes(
                        appointmentId,
                        doctorAppointmentController.notesController.text.trim(),
                      );
                    }
                    doctorAppointmentController.notesText.value = doctorAppointmentController.notesController.text;
                  } else {
                    Get.snackbar(
                      "Warning",
                      "Please enter clinical notes",
                      snackPosition: SnackPosition.BOTTOM,
                      duration: Duration(seconds: 2),
                    );
                  }
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