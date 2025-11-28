import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_prescription_controller.dart';
import 'package:patient_app/screens/doctor_screens/prescription_screens/add_new_prescription.dart';
import 'package:patient_app/screens/doctor_screens/prescription_screens/add_new_template.dart';
import 'package:patient_app/screens/doctor_screens/prescription_screens/edit_template_screen.dart';
import 'package:patient_app/screens/doctor_screens/prescription_screens/template_details_screen.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/doctor_widgets/prescription_widgets/doctor_prescription_card.dart';
import 'package:patient_app/widgets/doctor_widgets/prescription_widgets/prescription_filter_bottom_sheet.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/doctor_widgets/prescription_widgets/template_card.dart';

class DoctorPrescriptionScreen extends StatelessWidget {
  DoctorPrescriptionScreen({super.key});

  DoctorPrescriptionController doctorPrescriptionController = Get.put(
    DoctorPrescriptionController(),
  );

  @override
  Widget build(BuildContext context) {
    print(doctorPrescriptionController.prescriptionType.value);
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
                    "Prescription",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Obx(
                        () =>
                            doctorPrescriptionController
                                        .prescriptionType
                                        .value ==
                                    "activePrescription"
                                ? Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Manage Active Prescriptions And Reusable Templates",
                                    style: TextStyle(
                                      color: AppColors.lightGrey,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: AppFonts.jakartaMedium,
                                    ),
                                  ),
                                )
                                : SizedBox(),
                      ),
                      10.verticalSpace,
                      Container(
                        height: 55.h,
                        width: 1.sw,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14.sp),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => InkWell(
                                onTap: () {
                                  doctorPrescriptionController
                                      .prescriptionType
                                      .value = "activePrescription";
                                },
                                child: Container(
                                  height: 55.h,
                                  width: 0.455.sw,
                                  decoration: BoxDecoration(
                                    color:
                                        doctorPrescriptionController
                                                    .prescriptionType
                                                    .value ==
                                                "activePrescription"
                                            ? AppColors.primaryColor
                                            : Colors.white,
                                    borderRadius: BorderRadius.circular(14.sp),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Active Prescriptions(${doctorPrescriptionController.prescriptions.length})",
                                    style: TextStyle(
                                      color:
                                          doctorPrescriptionController
                                                      .prescriptionType
                                                      .value ==
                                                  "activePrescription"
                                              ? Colors.white
                                              : Colors.black,
                                      fontSize: 11.5.sp,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: AppFonts.jakartaMedium,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Obx(
                              () => InkWell(
                                onTap: () {
                                  doctorPrescriptionController
                                      .prescriptionType
                                      .value = "prescriptionTemplate";
                                },
                                child: Container(
                                  height: 55.h,
                                  width: 0.455.sw,
                                  decoration: BoxDecoration(
                                    color:
                                        doctorPrescriptionController
                                                    .prescriptionType
                                                    .value ==
                                                "prescriptionTemplate"
                                            ? AppColors.primaryColor
                                            : Colors.white,
                                    borderRadius: BorderRadius.circular(14.sp),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Prescriptions Templates",
                                    style: TextStyle(
                                      color:
                                          doctorPrescriptionController
                                                      .prescriptionType
                                                      .value ==
                                                  "prescriptionTemplate"
                                              ? Colors.white
                                              : Colors.black,
                                      fontSize: 11.5.sp,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: AppFonts.jakartaMedium,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      15.verticalSpace,
                      Obx(
                        ()=> CustomTextField(
                          hintText: doctorPrescriptionController.prescriptionType.value=="activePrescription"?"Search by patient name...":"Search by template name...",
                          prefixIcon: Icons.search,
                          suffixIcon: doctorPrescriptionController.prescriptionType.value=="activePrescription"?Icons.filter_list:null,
                          suffixIconColor: AppColors.primaryColor,
                          prefixIconColor: AppColors.darkGrey,
                          onSuffixIconTap: () {
                            _showFilterSheet(context);
                          },
                        ),
                      ),
                      10.verticalSpace,
                      Obx(
                        () =>
                            doctorPrescriptionController
                                        .prescriptionType
                                        .value ==
                                    "activePrescription"
                                ? Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "${doctorPrescriptionController.prescriptions.length} Active Prescriptions Found",
                                    style: TextStyle(
                                      color: AppColors.darkGrey,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: AppFonts.jakartaMedium,
                                    ),
                                  ),
                                )
                                : SizedBox(),
                      ),
                      Obx(
                        () =>
                            doctorPrescriptionController
                                        .prescriptionType
                                        .value ==
                                    "activePrescription"
                                ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.only(
                                    bottom: 20.h,
                                  ),
                                  itemCount:
                                      doctorPrescriptionController
                                          .prescriptions
                                          .length,
                                  itemBuilder: (context, index) {
                                    return DoctorPrescriptionCard(
                                      onTap: () {
                                        doctorPrescriptionController.viewDetail(
                                          doctorPrescriptionController
                                              .prescriptions[index],
                                        );
                                      },
                                      isActive: true,
                                      prescription:
                                          doctorPrescriptionController
                                              .prescriptions[index],
                                    );
                                  },
                                )
                                : ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(
                                    top: 5.h,
                                    bottom: 20.h,
                                  ),
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    return TemplateCard(
                                      title: 'Hypertension Basic Set',
                                      category: 'Cardiology',
                                      details:
                                          'Includes: Lisinopril 10mg, 30 days, daily dose.',
                                      lastUpdate: '12/Sep/2025',
                                      onEdit: (){
                                        Get.to(EditTemplateScreen());
                                      },
                                      onUse: (){
                                        Get.to(TemplateDetailsScreen());
                                      },
                                    );
                                  },
                                ),
                      ),
                      10.verticalSpace,
                      Obx(
                        () =>
                            doctorPrescriptionController
                                        .prescriptionType
                                        .value ==
                                    "activePrescription"
                                ? CustomButton(
                                  borderRadius: 15,
                                  text: "Add Prescription",
                                  onTap: () {
                                    Get.to(AddNewPrescription());
                                  },
                                )
                                : CustomButton(
                                  borderRadius: 15,
                                  text: "Add New Template",
                                  onTap: () {
                                    Get.to(AddNewTemplate());
                                  },
                                ),
                      ),
                      30.verticalSpace,
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

  void _showFilterSheet(BuildContext context) {
    const String currentStatus = 'Active';

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return PrescriptionFilterBottomSheet(
          initialStatus: currentStatus,
          onApply: () {
            Get.back();
          },
          onReset: () {
            Get.back();
          },
        );
      },
    );
  }
}
