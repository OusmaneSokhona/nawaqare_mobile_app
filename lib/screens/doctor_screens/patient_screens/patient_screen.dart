import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/patient_controller.dart';
import 'package:patient_app/screens/doctor_screens/appointment_screens/doctor_add_appointment_screen.dart';
import 'package:patient_app/screens/doctor_screens/patient_screens/add_appointment_patient_module.dart';
import 'package:patient_app/screens/doctor_screens/patient_screens/add_notes_screen.dart';
import 'package:patient_app/screens/doctor_screens/patient_screens/patient_detail_screen.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_images.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import 'package:patient_app/widgets/doctor_widgets/patient_widgets/patient_filter_bottom_sheet.dart';
import 'package:patient_app/widgets/doctor_widgets/patient_widgets/patient_card_widget.dart';

class PatientScreen extends StatelessWidget {
  PatientScreen({super.key});

  final PatientController patientController = Get.put(PatientController());

  @override
  Widget build(BuildContext context) {
    patientController.fetchPatients();
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
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              70.verticalSpace,
              _buildTopBar(),
              Expanded(
                child: Obx(() {
                  if (patientController.isLoading.value &&
                      patientController.patientSummaries.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (patientController.patientSummaries.isEmpty) {
                    return Center(
                      child: Text(
                        "No Patient Found",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.darkGrey,
                        ),
                      ),
                    );
                  }

                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            10.verticalSpace,
                            Text(
                              AppStrings.patientScreenDesc.tr,
                              style: TextStyle(
                                color: AppColors.lightGrey,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppFonts.jakartaRegular,
                              ),
                            ),
                            20.verticalSpace,
                            _buildSearchAndFilter(),
                            10.verticalSpace,
                            _buildListHeader(),
                            10.verticalSpace,
                          ],
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final patients = patientController.paginatedPatients;

                            if (index >= patients.length) {
                              return null;
                            }

                            final patient = patients[index];

                            return InkWell(
                              onTap: () {
                                Get.to(() => PatientDetailScreen(
                                  patient: patient,
                                ));
                              },
                              child: PatientCardWidget(
                                patientName: patient.fullName,
                                email: patient.email,
                                patientImageUrl: patient.imageUrl,
                                lastAppointmentDate: patient.lastAppointmentDate,
                                lastConsultationType: patient.lastConsultationType,
                                totalAppointments: patient.totalAppointments,
                                totalSpent: patient.totalSpent,
                                patientId: patient.patientId,
                                onScheduleTap: () {
                                 Get.to(AddAppointmentPatientModule(patient: patient));
                                },
                                onAddNoteTap: () {
                                  Get.to(AddNotesScreen(patientId: patient.patientId,));
                                },

                              ),
                            );
                          },
                          childCount: patientController.paginatedPatients.length,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            20.verticalSpace,
                            _buildPagination(),
                            20.verticalSpace,
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
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
          AppStrings.allPatients.tr,
          style: TextStyle(
            color: Colors.black,
            fontSize: 23.sp,
            fontWeight: FontWeight.w800,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        const Spacer(),
        Obx(() => patientController.isLoading.value
            ? SizedBox(
          height: 20.h,
          width: 20.h,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primaryColor,
          ),
        )
            : IconButton(
          onPressed: () => patientController.refreshData(),
          icon: Icon(Icons.refresh, color: AppColors.primaryColor),
        )),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    return CustomTextField(
      prefixIcon: Icons.search,
      hintText: AppStrings.searchPatientHint.tr,
      prefixIconColor: AppColors.darkGrey,
      suffixIcon: Icons.filter_list,
      suffixIconColor: AppColors.darkGrey,
      onChanged: (value) {
        patientController.setSearchQuery(value);
      },
      onSuffixIconTap: () {
        Get.bottomSheet(
          backgroundColor: Colors.white,
          PatientFilterBottomSheet(
            initialStatus: patientController.selectedStatus.value,
            onApply: (String status) {
              patientController.setStatusFilter(status);
              Get.back();
            },
            onReset: () {
              patientController.setStatusFilter(AppStrings.all.tr);
              Get.back();
            },
          ),
          isScrollControlled: true,
        );
      },
    );
  }

  Widget _buildListHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppStrings.mostRecentAppointment.tr,
          style: TextStyle(
            color: Colors.black,
            fontSize: 19.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        Obx(() {
          int count = patientController.totalFilteredCount;
          return Text(
            '$count ${count == 1 ? 'Patient' : 'Patients'}',
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPagination() {
    return Obx(() {
      int totalPages = patientController.totalPages;
      int currentPage = patientController.currentPage.value;

      if (totalPages <= 1) return const SizedBox.shrink();

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _paginationArrow(Icons.arrow_back, () {
            if (currentPage > 1) {
              patientController.previousPage();
            }
          }),
          15.horizontalSpace,
          ...List.generate(totalPages, (index) {
            int page = index + 1;
            return GestureDetector(
              onTap: () => patientController.currentPage.value = page,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: currentPage == page
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
                    color: currentPage == page
                        ? AppColors.primaryColor
                        : Colors.grey,
                  ),
                ),
              ),
            );
          }),
          15.horizontalSpace,
          _paginationArrow(Icons.arrow_forward, () {
            if (currentPage < totalPages) {
              patientController.nextPage();
            }
          }),
        ],
      );
    });
  }

  Widget _paginationArrow(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20.h,
          color: Colors.black,
        ),
      ),
    );
  }
}