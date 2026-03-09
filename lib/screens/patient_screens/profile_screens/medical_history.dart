import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/medical_history_controller.dart';
import 'package:patient_app/widgets/custom_button.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/patient_widgets/profile_widgets/current_medicine_list.dart';
import '../../../widgets/patient_widgets/profile_widgets/family_history_list.dart';
import '../../../widgets/patient_widgets/profile_widgets/life_style_card.dart';
import '../../../widgets/patient_widgets/profile_widgets/vaccination_history_list.dart';
import 'add_family_history.dart';
import 'add_life_style_screen.dart';
import 'add_medication_screen.dart';
import 'add_vaccination_screen.dart';
import '../../../utils/app_strings.dart';

class MedicalHistory extends StatelessWidget {
  MedicalHistory({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MedicalHistoryController());

    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.onboardingBackground, AppColors.lightWhite],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    AppStrings.medicalHistory.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              20.verticalSpace,
              Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 7.w,
                      children: [
                        historyType(
                          AppStrings.currentMedication.tr,
                          AppStrings.currentMedication,
                          100,
                          "assets/images/medicine_icon.png",
                        ),
                        historyType(
                          AppStrings.vaccinationHistory.tr,
                          AppStrings.vaccinationHistory,
                          100,
                          "assets/images/injection_icon.png",
                        ),
                        historyType(
                          AppStrings.familyHistory.tr,
                          AppStrings.familyHistory,
                          90,
                          "assets/images/family_icon.png",
                        ),
                        historyType(
                          AppStrings.lifestyle.tr,
                          AppStrings.lifestyle,
                          50,
                          "assets/images/heart_icon.png",
                        ),
                      ],
                    ),
                  ),
                  10.verticalSpace,
                  SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Container(
                      height: 0.69.sh,
                      child: Obx(() {
                        final controller = Get.find<MedicalHistoryController>();

                        if (controller.isLoading.value) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.h),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (controller.historyType.value == AppStrings.currentMedication) {
                          return controller.apiMedicationList.isEmpty
                              ? Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.h),
                              child: Text(
                                'No medications found',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ),
                          )
                              : CurrentMedicineList(
                            list: controller.apiMedicationList,
                          );
                        } else if (controller.historyType.value == AppStrings.vaccinationHistory) {
                          return controller.apiVaccinationList.isEmpty
                              ? Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.h),
                              child: Text(
                                'No vaccinations found',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ),
                          )
                              : VaccinationHistoryList(
                            list: controller.apiVaccinationList,
                          );
                        } else if (controller.historyType.value == AppStrings.familyHistory) {
                          return FamilyHistoryList();
                        } else {
                          return LifestyleCard();
                        }
                      }),
                    ),
                  ),
                  15.verticalSpace,
                  Obx(
                        () => CustomButton(
                      borderRadius: 15,
                      text: Get.find<MedicalHistoryController>().historyType.value == AppStrings.currentMedication
                          ? AppStrings.addMedication.tr
                          : Get.find<MedicalHistoryController>().historyType.value == AppStrings.vaccinationHistory
                          ? AppStrings.addVaccinationHistory.tr
                          : Get.find<MedicalHistoryController>().historyType.value == AppStrings.familyHistory
                          ? AppStrings.addFamilyHistory.tr
                          : AppStrings.addLifeStyle.tr,
                      onTap: () {
                        final controller = Get.find<MedicalHistoryController>();
                        if (controller.historyType.value == AppStrings.currentMedication) {
                          Get.to(() => AddMedicationScreen());
                        } else if (controller.historyType.value == AppStrings.vaccinationHistory) {
                          Get.to(() => AddVaccinationScreen());
                        } else if (controller.historyType.value == AppStrings.familyHistory) {
                          Get.to(() => AddFamilyHistory());
                        } else {
                          Get.to(() => AddLifeStyleScreen());
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget historyType(String title, String value, double width, String icon) {
    return Obx(
          () {
        final controller = Get.find<MedicalHistoryController>();
        return InkWell(
          onTap: () {
            controller.historyType.value = value;
            if (value == AppStrings.currentMedication) {
              controller.fetchMedicationHistory("medications");
            } else if (value == AppStrings.vaccinationHistory) {
              controller.fetchVaccinationHistory("vaccinations");
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Image.asset(
                    icon,
                    height: 10.h,
                    fit: BoxFit.fill,
                    color: controller.historyType.value == value
                        ? AppColors.primaryColor
                        : AppColors.lightGrey,
                  ),
                  2.horizontalSpace,
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: controller.historyType.value == value
                          ? AppColors.primaryColor
                          : AppColors.lightGrey,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              2.verticalSpace,
              controller.historyType.value == value
                  ? Container(
                width: width.w,
                height: 3.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(7.sp),
                ),
              )
                  : SizedBox(),
            ],
          ),
        );
      },
    );
  }
}