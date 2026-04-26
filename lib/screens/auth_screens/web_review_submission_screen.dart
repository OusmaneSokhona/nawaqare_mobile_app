import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/auth_controllers/sign_up_controller.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/web_submit_verification_dialog.dart';
import '../../utils/app_fonts.dart';
import '../../widgets/progress_stepper.dart';
import '../../widgets/submit_for_verification_dialog.dart';

class WebReviewSubmissionScreen extends StatelessWidget {
  WebReviewSubmissionScreen({super.key});

  final SignUpController signUpController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: AppColors.webBgColor,
      body: Center(
        child: Container(
          margin: isDesktop ? EdgeInsets.all(20.r) : EdgeInsets.zero,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            children: [
              if (isDesktop) _buildWebSideBanner(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 25.w : 20.w,
                    vertical: 35.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      15.verticalSpace,
                      const ProgressStepper(currentStep: 5, totalSteps: 5),
                      25.verticalSpace,
                      Expanded(
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildReviewAccordion(
                                  title: "Demographic info",
                                  isUploaded: true,
                                ),
                                15.verticalSpace,
                                _buildReviewAccordion(
                                  title: "Professional Info",
                                  isUploaded: true,
                                ),
                                15.verticalSpace,
                                _buildReviewAccordion(
                                  title: "Supporting Documents",
                                  isExpanded: true,
                                  children: [
                                    _buildSubReviewItem("Identity Documents"),
                                    _buildSubReviewItem("Credentials"),
                                    _buildSubReviewItem("Legal"),
                                    _buildSubReviewItem("Payment"),
                                  ],
                                ),
                                25.verticalSpace,
                                _buildConsentSection(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      30.verticalSpace,
                      Center(
                        child: CustomButton(
                          borderRadius: 10,
                          fontSize: 8,
                          text: "Submit for Verification",
                          onTap: () {
                            Get.dialog(WebSubmitVerificationDialog(),barrierDismissible: false);
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

  Widget _buildHeader() {
    return Text(
      AppStrings.docsAndReports.tr,
      style: TextStyle(
        color: Colors.black,
        fontFamily: AppFonts.jakartaBold,
        fontSize: 6.sp,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _buildReviewAccordion({
    required String title,
    bool isUploaded = false,
    bool isExpanded = false,
    List<Widget>? children,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 5.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 8.sp, color: Colors.grey),
              ],
            ),
          ),
          if (!isExpanded && isUploaded)
            Padding(
              padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 12.h),
              child: _buildStatusRow(),
            ),
          if (isExpanded && children != null)
            Padding(
              padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 12.h),
              child: Column(children: children),
            ),
        ],
      ),
    );
  }

  Widget _buildSubReviewItem(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 4.5.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          5.verticalSpace,
          _buildStatusRow(),
        ],
      ),
    );
  }

  Widget _buildStatusRow() {
    return Row(
      children: [
        Icon(Icons.check_box, color: Colors.green, size: 6.sp),
        5.horizontalSpace,
        Text(
          "Uploaded",
          style: TextStyle(fontSize: 4.sp, color: Colors.grey),
        ),
        const Spacer(),
        Icon(Icons.edit_note_outlined, color: Colors.blue, size: 8.sp),
      ],
    );
  }

  Widget _buildConsentSection() {
    return Column(
      children: [
        Obx(() => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15.h,
              width: 15.w,
              child: Checkbox(
                value: signUpController.isPersonalDataChecked.value,
                onChanged: (val) => signUpController.isPersonalDataChecked.value = val!,
                activeColor: AppColors.primaryColor,
side: BorderSide(
  color: AppColors.primaryColor,
  width: 1.5,
),
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: Text(
                "I consent to the processing of my personal data",
                style: TextStyle(fontSize: 4.5.sp, color: Colors.black54),
              ),
            ),
          ],
        )),
        15.verticalSpace,
        Obx(() => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15.h,
              width: 15.w,
              child: Checkbox(
                value: signUpController.isSubmissionConsentChecked.value,
                onChanged: (val) => signUpController.isSubmissionConsentChecked.value = val!,
                activeColor: AppColors.primaryColor,
                side: BorderSide(
                  color: AppColors.primaryColor,
                  width: 1.5,
                ),
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: Text(
                "By submitting, you consent to the processing of your data for professional verification purposes. Your information is securely handled under GDPR and HDS standards.",
                style: TextStyle(fontSize: 4.5.sp, color: Colors.black54),
              ),
            ),
          ],
        )),
      ],
    );
  }

  Widget _buildWebSideBanner() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          bottomLeft: Radius.circular(20.r),
        ),
        image: const DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage("assets/images/web_sign_in_image.png"),
        ),
      ),
      height: 1.sh,
      width: 0.45.sw,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 75.h),
        child: Column(
          children: [
            Text(
              "Welcome to Nawacare",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.w700),
            ),
            10.verticalSpace,
            Text(
              "Your central workspace to manage patients, appointments, and care.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 6.sp, color: Colors.white),
            ),
            const Spacer(),
            Text(
              "Efficient Care, Simplified",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10.sp, color: Colors.white, fontWeight: FontWeight.w700),
            ),
            10.verticalSpace,
            Text(
              "Manage consultations, prescriptions, and follow-ups with ease.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 6.sp, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}