import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/auth_controllers/sign_up_controller.dart';
import 'package:patient_app/widgets/submit_for_verification_dialog.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_strings.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/progress_stepper.dart';

class ReviewAndSubmission extends GetView<SignUpController> {
  const ReviewAndSubmission({super.key});

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
              80.verticalSpace,
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Image.asset(
                      "assets/images/back_icon.png",
                      height: 32.h,
                      width: 32.w,
                    ),
                  ),
                  7.horizontalSpace,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppStrings.reviewAndSubmission.tr,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: AppFonts.jakartaBold,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),

              20.verticalSpace,
              ProgressStepper(currentStep: 5, totalSteps: 5),
              15.verticalSpace,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InfoCard(title: AppStrings.personalInfo.tr),
                      InfoCard(title: AppStrings.professionalInfo.tr),
                      InfoCard(title: AppStrings.supportingDocuments.tr),
                      ConsentCheckbox(
                        text: AppStrings.consentDataProcessing.tr,
                        state: controller.isPersonalDataChecked,
                        onChanged: controller.togglePersonalData,
                      ),
                      ConsentCheckbox(
                        text: AppStrings.submissionConsentDetails.tr,
                        state: controller.isSubmissionConsentChecked,
                        onChanged: controller.toggleSubmissionConsent,
                      ),
                    ],
                  ),
                ),
              ),

              40.verticalSpace,
              CustomButton(
                borderRadius: 15,
                text: AppStrings.submitForVerification.tr,
                onTap: (){
                  Get.dialog(SubmitForVerificationDialog());
                },
              ),
              50.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;

  const InfoCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      shadowColor: const Color(0x20000000),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF757575),
              size: 24.0,
            ),
          ],
        ),
      ),
    );
  }
}

class ConsentCheckbox extends StatelessWidget {
  final String text;
  final RxBool state;
  final Function(bool?) onChanged;

  const ConsentCheckbox({super.key, required this.text, required this.state, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 24.0,
            width: 24.0,
            child: Obx(
                  () => Checkbox(
                value: state.value,
                onChanged: onChanged,
                activeColor: AppColors.primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14.0,
                color: Color(0xFF4C4C4C),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}