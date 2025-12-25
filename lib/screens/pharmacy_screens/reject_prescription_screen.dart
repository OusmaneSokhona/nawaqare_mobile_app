import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/pharmacy_controllers/pharmacy_prescription_controller.dart';
import 'package:patient_app/widgets/patient_widgets/video_call_widgets/setting%20widgets.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_images.dart';
import '../../utils/app_strings.dart';
import '../../widgets/custom_button.dart';

class RejectPrescriptionScreen extends StatelessWidget {
  RejectPrescriptionScreen({super.key});

  // Use Get.find since the controller should already be initialized in the detail screen
  final PharmacyPrescriptionController controller = Get.find<PharmacyPrescriptionController>();

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
                    AppStrings.rejectPrescription.tr,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      10.verticalSpace,
                      Obx(() => CustomDropdown(
                        label: AppStrings.reasons.tr,
                        options: [
                          AppStrings.invalidSignature.tr,
                          AppStrings.invalidMedicine.tr,
                          AppStrings.invalidId.tr,
                        ],
                        currentValue: controller.slectedReasons.value,
                        onChanged: (value) {
                          if (value != null) {
                            controller.slectedReasons.value = value;
                          }
                        },
                      )),
                      20.verticalSpace,
                      Text(
                        AppStrings.message.tr,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontFamily: AppFonts.jakartaBold,
                        ),
                      ),
                      10.verticalSpace,
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: Colors.grey.shade300, width: 1),
                        ),
                        child: TextField(
                          maxLines: 5,
                          onTapOutside: (_) {
                            FocusManager.instance.primaryFocus!.unfocus();
                          },
                          style: TextStyle(fontSize: 14.sp),
                          decoration: InputDecoration(
                            hintText: AppStrings.enterMessageHint.tr,
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                          ),
                        ),
                      ),
                      40.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.confirmRejection.tr,
                        onTap: () {
                          // Add your rejection logic here
                          Get.back();
                        },
                      ),
                      12.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.cancel.tr,
                        onTap: () => Get.back(),
                        bgColor: AppColors.inACtiveButtonColor,
                        fontColor: Colors.black,
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
}