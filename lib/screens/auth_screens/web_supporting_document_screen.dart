import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/auth_controllers/sign_up_controller.dart';
import 'package:patient_app/screens/auth_screens/web_review_submission_screen.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/upload_document_widget.dart';
import '../../utils/app_fonts.dart';
import '../../widgets/progress_stepper.dart';

class WebSupportingDocumentsScreen extends StatelessWidget {
  WebSupportingDocumentsScreen({super.key});

  final SignUpController signUpController = Get.find();

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
                      const ProgressStepper(currentStep: 4, totalSteps: 5),
                      25.verticalSpace,
                      Expanded(
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSection(
                                  AppStrings.identityDocuments.tr,
                                  [
                                    _buildUploadItem(
                                      signUpController.selectedFileIdCard,
                                      AppStrings.nationalIdDoc.tr,
                                      AppStrings.uploadDocument.tr,
                                    ),
                                    _buildUploadItem(
                                      signUpController.selectedFilePassport,
                                      AppStrings.passportIdFront.tr,
                                      AppStrings.uploadFrontSide.tr,
                                    ),
                                  ],
                                ),
                                20.verticalSpace,
                                _buildSection(
                                  AppStrings.credentials.tr,
                                  [
                                    _buildUploadItem(
                                      signUpController.selectedFileMedicalLicense,
                                      AppStrings.medicalLicense.tr,
                                      AppStrings.uploadValidLicense.tr,
                                    ),
                                    _buildUploadItem(
                                      signUpController.selectedFileDiploma,
                                      AppStrings.diplomaCertification.tr,
                                      AppStrings.uploadDiplomaTranscript.tr,
                                    ),
                                  ],
                                ),
                                20.verticalSpace,
                                _buildSection(
                                  AppStrings.legal.tr,
                                  [
                                    _buildUploadItem(
                                      signUpController.selectedFileInsuranceProof,
                                      AppStrings.liabilityInsuranceProof.tr,
                                      AppStrings.uploadInsuranceDoc.tr,
                                    ),
                                    _buildUploadItem(
                                      signUpController.selectedFileCnpd,
                                      AppStrings.cnpdGdprForm.tr,
                                      AppStrings.attachComplianceForm.tr,
                                    ),
                                  ],
                                ),
                                20.verticalSpace,
                                _buildSection(
                                  AppStrings.payment.tr,
                                  [
                                    _buildUploadItem(
                                      signUpController.selectedFileBankVerification,
                                      AppStrings.bankVerificationLetter.tr,
                                      AppStrings.uploadBankConfirmation.tr,
                                    ),
                                    _buildUploadItem(
                                      signUpController.selectedFileBankPaymentAuthorization,
                                      AppStrings.paymentAuthorization.tr,
                                      AppStrings.attachSignedForm.tr,
                                    ),
                                  ],
                                ),
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
                          text: AppStrings.continueText.tr,
                          onTap: (){
                            Get.to(WebReviewSubmissionScreen());

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

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 5.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.jakartaBold,
            color: Colors.black,
          ),
        ),
        10.verticalSpace,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: items[0]),
            15.horizontalSpace,
            Expanded(child: items[1]),
          ],
        ),
      ],
    );
  }

  Widget _buildUploadItem(Rx<String?> observable, String title, String centerText) {
    return UploadDocumentWidget(
      selectedFileName: observable as dynamic,
      pickFile: () => signUpController.pickFile(observable),
      title: title,
      centerText: centerText,
      acceptedFile: AppStrings.acceptedFilesInfo.tr,
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