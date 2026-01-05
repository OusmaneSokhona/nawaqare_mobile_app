import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/patient_controller.dart';
import 'package:patient_app/screens/doctor_screens/patient_screens/add_notes_screen.dart';
import 'package:patient_app/screens/doctor_screens/patient_screens/patient_detail_screen.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import 'package:patient_app/widgets/doctor_widgets/patient_widgets/patient_filter_bottom_sheet.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../../widgets/doctor_widgets/patient_widgets/patient_card_widget.dart';

class PatientScreen extends StatelessWidget {
  PatientScreen({super.key});
  final PatientController patientController = Get.put(PatientController());

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
          padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                    AppStrings.allPatients.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
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
                      CustomTextField(
                        prefixIcon: Icons.search,
                        hintText: AppStrings.searchPatientHint.tr,
                        prefixIconColor: AppColors.darkGrey,
                        suffixIcon: Icons.filter_list,
                        suffixIconColor: AppColors.darkGrey,
                        onSuffixIconTap: () {
                          Get.bottomSheet(
                            backgroundColor: Colors.white,
                            PatientFilterBottomSheet(
                              initialStatus: "active",
                              onApply: () {},
                              onReset: () {},
                            ),
                          );
                        },
                      ),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.mostRecentAppointment.tr,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 19.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Obx(
                            () {
                          var list = patientController.paginatedPatients;
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: list.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return PatientCardWidget(
                                patientModel: list[index],
                                onAddNoteTap: () => Get.to(AddNotesScreen()),
                                onFollowUpTap: () {},
                                onScheduleTap: () => Get.to(PatientDetailScreen()),
                              );
                            },
                          );
                        },
                      ),
                      20.verticalSpace,
                      _buildPagination(),
                      20.verticalSpace,
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

  Widget _buildPagination() {
    return Obx(
          () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _paginationArrow(Icons.arrow_back, () {
            if (patientController.currentPage.value > 1) {
              patientController.currentPage.value--;
            }
          }),
          15.horizontalSpace,
          ...List.generate(patientController.totalPages, (index) {
            int page = index + 1;
            return GestureDetector(
              onTap: () => patientController.currentPage.value = page,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  "$page",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: AppFonts.jakartaMedium,
                    fontWeight: FontWeight.w600,
                    color: patientController.currentPage.value == page
                        ? AppColors.primaryColor
                        : Colors.grey,
                  ),
                ),
              ),
            );
          }),
          15.horizontalSpace,
          _paginationArrow(Icons.arrow_forward, () {
            if (patientController.currentPage.value < patientController.totalPages) {
              patientController.currentPage.value++;
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
          size: 17.h,
          color: Colors.black,
        ),
      ),
    );
  }
}