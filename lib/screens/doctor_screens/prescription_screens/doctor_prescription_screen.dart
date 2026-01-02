import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_prescription_controller.dart';
import 'package:patient_app/screens/doctor_screens/prescription_screens/add_new_prescription.dart';
import 'package:patient_app/screens/doctor_screens/prescription_screens/add_new_template.dart';
import 'package:patient_app/screens/doctor_screens/prescription_screens/edit_template_screen.dart';
import 'package:patient_app/screens/doctor_screens/prescription_screens/template_details_screen.dart';
import 'package:patient_app/utils/app_strings.dart';
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

  final DoctorPrescriptionController doctorPrescriptionController = Get.put(
    DoctorPrescriptionController(),
  );

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
                    onTap: () => Get.back(),
                    child: Image.asset(
                      AppImages.backIcon,
                      height: 33.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    AppStrings.prescriptionDoctor.tr,
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
                            () => doctorPrescriptionController.prescriptionType.value == "activePrescription"
                            ? Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppStrings.managePrescriptionSub.tr,
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
                            Obx(() => _buildTab("activePrescription", "${AppStrings.activePrescriptionsDoctor.tr}(${doctorPrescriptionController.prescriptions.length})")),
                            Obx(() => _buildTab("prescriptionTemplate", "${AppStrings.prescriptionTemplates.tr}(${doctorPrescriptionController.templates.length})")),
                          ],
                        ),
                      ),
                      15.verticalSpace,
                      Obx(
                            () => CustomTextField(
                          hintText: doctorPrescriptionController.prescriptionType.value == "activePrescription"
                              ? AppStrings.searchByPatient.tr
                              : AppStrings.searchByTemplate.tr,
                          prefixIcon: Icons.search,
                          suffixIcon: doctorPrescriptionController.prescriptionType.value == "activePrescription"
                              ? Icons.filter_list
                              : null,
                          suffixIconColor: AppColors.primaryColor,
                          prefixIconColor: AppColors.darkGrey,
                          onSuffixIconTap: () => _showFilterSheet(context),
                        ),
                      ),
                      10.verticalSpace,
                      Obx(
                            () => doctorPrescriptionController.prescriptionType.value == "activePrescription"
                            ? Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${doctorPrescriptionController.prescriptions.length} ${AppStrings.activePrescriptionsFound.tr}",
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
                            () {
                          if (doctorPrescriptionController.prescriptionType.value == "activePrescription") {
                            var list = doctorPrescriptionController.paginatedPrescriptions;
                            return Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.only(bottom: 20.h),
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    return DoctorPrescriptionCard(
                                      onTap: () => doctorPrescriptionController.viewDetail(list[index]),
                                      isActive: true,
                                      prescription: list[index],
                                    );
                                  },
                                ),
                                _buildPagination(),
                              ],
                            );
                          } else {
                            var templateList = doctorPrescriptionController.paginatedTemplates;
                            return Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(top: 5.h, bottom: 20.h),
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: templateList.length,
                                  itemBuilder: (context, index) {
                                    return TemplateCard(
                                      title: 'Hypertension Basic Set',
                                      category: 'Cardiology',
                                      details: 'Includes: Lisinopril 10mg, 30 days, daily dose.',
                                      lastUpdate: '12/Sep/2025',
                                      onEdit: () => Get.to(EditTemplateScreen()),
                                      onUse: () => Get.to(TemplateDetailsScreen()),
                                    );
                                  },
                                ),
                                _buildPagination(),
                              ],
                            );
                          }
                        },
                      ),
                      10.verticalSpace,
                      Obx(
                            () => CustomButton(
                          borderRadius: 15,
                          text: doctorPrescriptionController.prescriptionType.value == "activePrescription"
                              ? AppStrings.addPrescription.tr
                              : AppStrings.addNewTemplate.tr,
                          onTap: () {
                            if (doctorPrescriptionController.prescriptionType.value == "activePrescription") {
                              Get.to(AddNewPrescription());
                            } else {
                              Get.to(AddNewTemplate());
                            }
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

  Widget _buildTab(String type, String label) {
    return InkWell(
      onTap: () {
        doctorPrescriptionController.prescriptionType.value = type;
        doctorPrescriptionController.currentPage.value = 1;
      },
      child: Container(
        height: 55.h,
        width: 0.455.sw,
        decoration: BoxDecoration(
          color: doctorPrescriptionController.prescriptionType.value == type
              ? AppColors.primaryColor
              : Colors.white,
          borderRadius: BorderRadius.circular(14.sp),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: doctorPrescriptionController.prescriptionType.value == type
                ? Colors.white
                : Colors.black,
            fontSize: 10.5.sp,
            fontWeight: FontWeight.w700,
            fontFamily: AppFonts.jakartaMedium,
          ),
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Obx(
          () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _paginationArrow(Icons.arrow_back, () {
            if (doctorPrescriptionController.currentPage.value > 1) {
              doctorPrescriptionController.currentPage.value--;
            }
          }),
          15.horizontalSpace,
          ...List.generate(doctorPrescriptionController.totalPages, (index) {
            int page = index + 1;
            return GestureDetector(
              onTap: () => doctorPrescriptionController.currentPage.value = page,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  "$page",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: AppFonts.jakartaMedium,
                    fontWeight: FontWeight.w600,
                    color: doctorPrescriptionController.currentPage.value == page
                        ? AppColors.primaryColor
                        : Colors.grey,
                  ),
                ),
              ),
            );
          }),
          15.horizontalSpace,
          _paginationArrow(Icons.arrow_forward, () {
            if (doctorPrescriptionController.currentPage.value < doctorPrescriptionController.totalPages) {
              doctorPrescriptionController.currentPage.value++;
            }
          }),
        ],
      ),
    );
  }

  Widget _paginationArrow(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 17.h, color: Colors.black),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return PrescriptionFilterBottomSheet(
          initialStatus: 'Active',
          onApply: () => Get.back(),
          onReset: () => Get.back(),
        );
      },
    );
  }
}