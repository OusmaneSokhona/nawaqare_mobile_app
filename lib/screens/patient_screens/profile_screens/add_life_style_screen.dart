import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/medical_history_controller.dart';
import 'package:patient_app/widgets/custom_button.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';

class AddLifeStyleScreen extends StatelessWidget {
  AddLifeStyleScreen({super.key});

  final MedicalHistoryController controller = Get.find<MedicalHistoryController>();

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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    AppStrings.addLifestyle.tr,
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
                child: Obx(
                      () => SingleChildScrollView(
                        child: Column(
                          children: [
                            30.verticalSpace,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: controller.categories.keys
                                  .map((categoryKey) => Padding(
                                padding: EdgeInsets.only(bottom: 20.h),
                                child: _buildRadioGroup(
                                  categoryKey.tr,
                                  categoryKey,
                                  controller.categories[categoryKey]!,
                                ),
                              ))
                                  .toList(),
                            ),
                            40.verticalSpace,
                            CustomButton(
                              borderRadius: 15,
                              text: AppStrings.addAndSave.tr,
                              isLoading: controller.isLoading.value,
                              onTap: controller.isLoading.value ? (){} : controller.addLifestyle,
                            ),
                            12.verticalSpace,
                            CustomButton(
                              borderRadius: 15,
                              text: AppStrings.cancel.tr,
                              bgColor: AppColors.inACtiveButtonColor,
                              fontColor: Colors.black,
                              onTap: controller.isLoading.value ? (){} : () => Get.back(),
                            ),
                            60.verticalSpace,
                          ],
                        ),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioGroup(String displayTitle, String categoryKey, List<String> options) {
    return Obx(() {
      final selectedValue = controller.getSelection(categoryKey).value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            displayTitle,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          12.verticalSpace,
          Wrap(
            spacing: 28.w,
            runSpacing: 12.h,
            children: options.map((option) {
              final isSelected = selectedValue == option;
              return GestureDetector(
                onTap: () => controller.updateSelection(categoryKey, option),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 22.w,
                      height: 22.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppColors.primaryColor : Colors.grey.shade400,
                          width: 2.5,
                        ),
                        color: isSelected ? AppColors.primaryColor.withOpacity(0.12) : Colors.transparent,
                      ),
                      child: isSelected
                          ? Center(
                        child: Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      )
                          : const SizedBox.shrink(),
                    ),
                    10.horizontalSpace,
                    Text(
                      option.tr,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: isSelected ? AppColors.primaryColor : Colors.black87,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      );
    });
  }
}