import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/widgets/custom_button.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../../widgets/custom_text_field.dart';

class EditMedicalVitals extends StatelessWidget {
  EditMedicalVitals({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.onboardingBackground, Colors.white,],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal:20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              70.verticalSpace,
              Row(
                children: [
                  InkWell(
                    onTap: (){
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
                    AppStrings.medicalVitals.tr,
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
                      15.verticalSpace,
                      CustomTextField(labelText: AppStrings.height.tr, hintText: "165cm"),
                      10.verticalSpace,
                      CustomTextField(labelText: AppStrings.weight.tr, hintText: "60kg"),
                      10.verticalSpace,
                      CustomTextField(labelText: AppStrings.bmi.tr, hintText: "22.0"),
                      10.verticalSpace,
                      CustomTextField(
                        labelText: AppStrings.bloodPressure.tr,
                        hintText: "120/80 mmHg",
                      ),
                      10.verticalSpace,
                      CustomTextField(
                        labelText: AppStrings.heartRate.tr,
                        hintText: "72bpm",
                      ),
                      30.verticalSpace,
                      CustomButton(borderRadius: 15, text: AppStrings.submit.tr, onTap: (){}),
                      10.verticalSpace,
                      CustomButton(borderRadius: 15, text: AppStrings.cancel.tr, onTap: (){Get.back();},bgColor: AppColors.inACtiveButtonColor,fontColor: Colors.black,),
                      40.verticalSpace,
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
}