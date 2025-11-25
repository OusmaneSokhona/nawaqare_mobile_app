import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/profile_controller.dart';
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
class MedicalHistory extends GetView<ProfileController> {
  const MedicalHistory({super.key});

  @override
  Widget build(BuildContext context) {
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
                    "Medical History",
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          spacing: 7.w,
                          children: [
                            historyType(
                              "Current Medication",
                              100,
                              "assets/images/medicine_icon.png",
                            ),
                            historyType(
                              "Vaccination History",
                              100,
                              "assets/images/injection_icon.png",
                            ),
                            historyType(
                              "Family History",
                              90,
                              "assets/images/family_icon.png",
                            ),
                            historyType(
                              "Lifestyle",
                              50,
                              "assets/images/heart_icon.png",
                            ),
                          ],
                        ),
                      ),
                      10.verticalSpace,
                      Obx(
                        () =>
                            controller.historyType.value == "Current Medication"
                                ? CurrentMedicineList(
                                  list: controller.medicalHistoryList,
                                )
                                : controller.historyType.value ==
                                    "Vaccination History"
                                ? VaccinationHistoryList(
                                  list: controller.vaccinationHistoryList,
                                )
                                : controller.historyType.value ==
                                    "Family History"
                                ? FamilyHistoryList()
                                : LifestyleCard(),
                      ),
                      15.verticalSpace,
                      Obx(
                        ()=> CustomButton(
                          borderRadius: 15,
                          text: controller.historyType=="Current Medication"?"Add Medication":controller.historyType=="Vaccination History"?"Add Vaccination History":controller.historyType.value ==
                              "Family History"?"Add Family History":"Add Life Style",
                          onTap: () {
                        if(controller.historyType=="Current Medication"){
                          Get.to(AddMedicationScreen());
                        }else if(controller.historyType=="Vaccination History"){
                          Get.to(AddVaccinationScreen());
                        }else if(controller.historyType.value ==
                            "Family History"){
                          Get.to(AddFamilyHistory());
                        }else{
                          Get.to(AddLifeStyleScreen());
                        };
                          },
                        ),
                      ),
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
  Widget historyType(String title, double width, String icon) {
    return Obx(
      () => InkWell(
        onTap: () {
          controller.historyType.value = title;
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
                  color:
                      controller.historyType.value == title
                          ? AppColors.primaryColor
                          : AppColors.lightGrey,
                ),
                2.horizontalSpace,
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color:
                        controller.historyType.value == title
                            ? AppColors.primaryColor
                            : AppColors.lightGrey,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            2.verticalSpace,
            controller.historyType.value == title
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
      ),
    );
  }
}
