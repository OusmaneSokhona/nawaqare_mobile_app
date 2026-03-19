
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

  final DoctorPrescriptionController controller = Get.put(
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
                            () => controller.prescriptionType.value == "activePrescription"
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
                            : const SizedBox(),
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
                            Obx(() => _buildTab("activePrescription",
                                "${AppStrings.activePrescriptionsDoctor.tr}(${controller.prescriptions.length})")),
                            Obx(() => _buildTab("prescriptionTemplate",
                                "${AppStrings.prescriptionTemplates.tr}(${controller.templates.length})")),
                          ],
                        ),
                      ),
                      15.verticalSpace,
                      Obx(
                            () => CustomTextField(
                          hintText: controller.prescriptionType.value == "activePrescription"
                              ? AppStrings.searchByPatient.tr
                              : AppStrings.searchByTemplate.tr,
                          prefixIcon: Icons.search,
                          suffixIcon: controller.prescriptionType.value == "activePrescription"
                              ? Icons.filter_list
                              : null,
                          suffixIconColor: AppColors.primaryColor,
                          prefixIconColor: AppColors.darkGrey,
                          onChanged: (value) {
                            if (controller.prescriptionType.value == "activePrescription") {
                              controller.searchQuery.value = value;
                            } else {
                              controller.searchTemplates(value);
                            }
                          },
                          onSuffixIconTap: () => _showFilterSheet(context),
                        ),
                      ),
                      10.verticalSpace,
                      Obx(
                            () {
                          if (controller.isLoading.value) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (controller.errorMessage.isNotEmpty) {
                            return Center(
                              child: Column(
                                children: [
                                  Text(
                                    controller.errorMessage.value,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                  ElevatedButton(
                                    onPressed: controller.fetchAllPrescriptions,
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                      Obx(
                            () => controller.prescriptionType.value == "activePrescription"
                            ? Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${controller.filteredCount} ${AppStrings.activePrescriptionsFound.tr}",
                            style: TextStyle(
                              color: AppColors.darkGrey,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppFonts.jakartaMedium,
                            ),
                          ),
                        )
                            : const SizedBox(),
                      ),
                      Obx(
                            () {
                          if (controller.prescriptionType.value == "activePrescription") {
                            if (controller.paginatedPrescriptions.isEmpty) {
                              return Center(
                                child: Column(
                                  children: [
                                    50.verticalSpace,
                                    Icon(
                                      Icons.receipt_long_outlined,
                                      size: 80.sp,
                                      color: Colors.grey[400],
                                    ),
                                    20.verticalSpace,
                                    Text(
                                      'No prescriptions found',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    10.verticalSpace,
                                    Text(
                                      controller.searchQuery.value.isNotEmpty
                                          ? 'Try adjusting your search or filters'
                                          : 'No prescriptions available',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                    if (controller.searchQuery.value.isNotEmpty ||
                                        controller.selectedStatus.value != 'All')
                                      Padding(
                                        padding: EdgeInsets.only(top: 20.h),
                                        child: CustomButton(
                                          text: 'Clear Filters',
                                          onTap: controller.resetAllFilters,
                                          height: 40.h,
                                       borderRadius: 15,
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }

                            var list = controller.paginatedPrescriptions;
                            return Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.only(bottom: 20.h),
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    return DoctorPrescriptionCard(
                                      onTap: () => controller.viewDetail(list[index]),
                                      isActive: true,
                                      prescription: list[index],
                                    );
                                  },
                                ),
                                if (controller.totalPages > 1) _buildPagination(),
                              ],
                            );
                          } else {
                            var templateList = controller.paginatedTemplates;
                            if (templateList.isEmpty) {
                              return Center(
                                child: Column(
                                  children: [
                                    50.verticalSpace,
                                    Icon(
                                      Icons.description_outlined,
                                      size: 80.sp,
                                      color: Colors.grey[400],
                                    ),
                                    20.verticalSpace,
                                    Text(
                                      'No templates found',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(top: 5.h, bottom: 20.h),
                                  physics: const NeverScrollableScrollPhysics(),
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
                                if (controller.totalPages > 1) _buildPagination(),
                              ],
                            );
                          }
                        },
                      ),
                      10.verticalSpace,
                      Obx(
                            () => CustomButton(
                          borderRadius: 15,
                          text: controller.prescriptionType.value == "activePrescription"
                              ? AppStrings.addPrescription.tr
                              : AppStrings.addNewTemplate.tr,
                          onTap: () {
                            if (controller.prescriptionType.value == "activePrescription") {
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
        controller.prescriptionType.value = type;
        controller.currentPage.value = 1;
        if (type == "activePrescription") {
          controller.applyFiltersAndSearch();
        }
      },
      child: Container(
        height: 55.h,
        width: 0.455.sw,
        decoration: BoxDecoration(
          color: controller.prescriptionType.value == type
              ? AppColors.primaryColor
              : Colors.white,
          borderRadius: BorderRadius.circular(14.sp),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: controller.prescriptionType.value == type
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
            if (controller.currentPage.value > 1) {
              controller.currentPage.value--;
            }
          }),
          15.horizontalSpace,
          ...List.generate(controller.totalPages, (index) {
            int page = index + 1;
            return GestureDetector(
              onTap: () => controller.currentPage.value = page,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: controller.currentPage.value == page
                      ? AppColors.primaryColor.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  "$page",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: AppFonts.jakartaMedium,
                    fontWeight: FontWeight.w600,
                    color: controller.currentPage.value == page
                        ? AppColors.primaryColor
                        : Colors.grey,
                  ),
                ),
              ),
            );
          }),
          15.horizontalSpace,
          _paginationArrow(Icons.arrow_forward, () {
            if (controller.currentPage.value < controller.totalPages) {
              controller.currentPage.value++;
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
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 20.h, color: Colors.black),
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
          initialStatus: controller.selectedStatus.value,
          onApply: () => Get.back(),
          onReset: () => Get.back(),
        );
      },
    );
  }
}