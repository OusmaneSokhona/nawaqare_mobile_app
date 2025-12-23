import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/profile_controller.dart';
import '../../../widgets/custom_button.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';

class AddLifeStyleScreen extends GetView<ProfileController> {
  const AddLifeStyleScreen({super.key});

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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      30.verticalSpace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: controller.categories.keys
                            .map((category) => Padding(
                          padding: EdgeInsets.only(bottom:5.h),
                          child: _buildRadioGroup(
                            category.tr, // Translate category title
                            controller.categories[category]!,
                          ),
                        ))
                            .toList(),
                      ),
                      20.verticalSpace,
                      CustomButton(borderRadius: 15, text: AppStrings.addAndSave.tr, onTap: (){}),
                      10.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.cancel.tr,
                        onTap: (){Get.back();},
                        bgColor: AppColors.inACtiveButtonColor,
                        fontColor: Colors.black,
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

  Widget _buildRadioGroup(String title, List<String> options) {
    return Obx(() {
      final selectedValue = controller.getSelection(title).value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          4.verticalSpace,
          Wrap(
            spacing: 0,
            children: options
                .map(
                  (option) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio<String>(
                    value: option,
                    groupValue: selectedValue,
                    onChanged: (String? value) {
                      if (value != null) {
                        controller.updateSelection(title, value);
                      }
                    },
                    activeColor: Colors.blue.shade700,
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.updateSelection(title, option);
                    },
                    child: Text(
                      option.tr, // Translate the option labels (e.g., Never, Regularly)
                      style: TextStyle(fontSize: 13.sp),
                    ),
                  ),
                ],
              ),
            )
                .toList(),
          ),
        ],
      );
    });
  }
}