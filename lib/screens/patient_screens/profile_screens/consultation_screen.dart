import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/consultation_controller.dart';
import 'package:patient_app/screens/patient_screens/profile_screens/consultation_details_screen.dart';
import 'package:patient_app/widgets/patient_widgets/profile_widgets/consultation_card.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';

class ConsultationScreen extends StatelessWidget {
  ConsultationScreen({super.key});

  final ConsultationController consultationController = Get.put(ConsultationController());

  @override
  Widget build(BuildContext context) {

    if (MediaQuery.of(context).size.width > 0) {
      ScreenUtil.init(context, designSize: const Size(360, 690));
    }

    final backIconWidget = Image.asset(
      AppImages.backIcon,
      height: 33.h,
      fit: BoxFit.fill,
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.arrow_back, size: 33.h, color: Colors.black);
      },
    );

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
                    child: backIconWidget,
                  ),
                  10.horizontalSpace,
                  Text(
                    AppStrings.myConsultationPlans.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              20.verticalSpace,
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
                          consultationController.orderType.value = AppStrings.activePlan;
                          consultationController.searchQuery.value = '';
                        },
                        child: Container(
                          height: 55.h,
                          width: 0.455.sw,
                          decoration: BoxDecoration(
                            color: consultationController.orderType.value ==
                                AppStrings.activePlan
                                ? AppColors.primaryColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14.sp),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            AppStrings.activePlan.tr,
                            style: TextStyle(
                              color: consultationController.orderType.value ==
                                  AppStrings.activePlan
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 14.5.sp,
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
                          consultationController.orderType.value = AppStrings.planHistory;
                          consultationController.searchQuery.value = '';
                        },
                        child: Container(
                          height: 55.h,
                          width: 0.455.sw,
                          decoration: BoxDecoration(
                            color: consultationController.orderType.value ==
                                AppStrings.planHistory
                                ? AppColors.primaryColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14.sp),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            AppStrings.planHistory.tr,
                            style: TextStyle(
                              color: consultationController.orderType.value ==
                                  AppStrings.planHistory
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 14.5.sp,
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
              20.verticalSpace,
              Container(
                height: 55.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.sp),
                ),
                child: TextField(
                  onTapOutside: (_) {
                    FocusManager.instance.primaryFocus!.unfocus();
                  },
                  onChanged: (value) {
                    consultationController.searchQuery.value = value;
                  },
                  decoration: InputDecoration(
                    hintText: AppStrings.searchConsultationHint.tr,
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[600],
                      size: 24.sp,
                    ),
                    suffixIcon: Icon(
                      Icons.filter_list_outlined,
                      color: AppColors.darkGrey,
                      size: 24.sp,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 10.w),
                  ),
                ),
              ),
              Obx(
                    () {
                  final filteredList = consultationController.filteredConsultation;

                  if (filteredList.isEmpty) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          AppStrings.noOrdersFound.tr,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }

                  return Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        return ConsultationCard(
                          isCompleted: consultationController.orderType.value == AppStrings.planHistory,
                          onTap: () {
                            Get.to(() => const ConsultationDetailsScreen());
                          },
                          plan: filteredList[index],
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}