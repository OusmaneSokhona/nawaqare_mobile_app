import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/auth_screens/review_and_submission.dart';
import 'package:patient_app/widgets/upload_document_widget.dart';
import '../../controllers/auth_controllers/sign_up_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_strings.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/progress_stepper.dart';

class SupportingDocuments extends StatelessWidget {
  SupportingDocuments({super.key});

  final SignUpController signUpController = Get.find();

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
                    onTap: () => Get.back(),
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
                      AppStrings.docsAndReports.tr,
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
              ProgressStepper(currentStep: 4, totalSteps: 5),
              15.verticalSpace,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 10,
                    children: [
                      _buildSectionTitle(AppStrings.identityDocuments.tr),
                      UploadDocumentWidget(
                        selectedFileName: signUpController.selectedFileIdCard,
                        pickFile:
                            () => signUpController.pickFile(
                              signUpController.selectedFileIdCard,
                            ),
                        title: AppStrings.nationalIdDoc.tr,
                        centerText: AppStrings.uploadDocument.tr,
                        acceptedFile: AppStrings.acceptedFilesInfo.tr,
                      ),
                      UploadDocumentWidget(
                        selectedFileName: signUpController.selectedFilePassport,
                        pickFile:
                            () => signUpController.pickFile(
                              signUpController.selectedFilePassport,
                            ),
                        title: AppStrings.passportIdFront.tr,
                        centerText: AppStrings.uploadFrontSide.tr,
                        acceptedFile: AppStrings.acceptedFilesInfo.tr,
                      ),

                      _buildSectionTitle(AppStrings.credentials.tr),
                      UploadDocumentWidget(
                        selectedFileName:
                            signUpController.selectedFileMedicalLicense,
                        pickFile:
                            () => signUpController.pickFile(
                              signUpController.selectedFileMedicalLicense,
                            ),
                        title: AppStrings.medicalLicense.tr,
                        centerText: AppStrings.uploadValidLicense.tr,
                        acceptedFile: AppStrings.acceptedFilesInfo.tr,
                      ),
                      UploadDocumentWidget(
                        selectedFileName: signUpController.selectedFileDiploma,
                        pickFile:
                            () => signUpController.pickFile(
                              signUpController.selectedFileDiploma,
                            ),
                        title: AppStrings.diplomaCertification.tr,
                        centerText: AppStrings.uploadDiplomaTranscript.tr,
                        acceptedFile: AppStrings.acceptedFilesInfo.tr,
                      ),

                      _buildSectionTitle(AppStrings.legal.tr),
                      UploadDocumentWidget(
                        selectedFileName:
                            signUpController.selectedFileInsuranceProof,
                        pickFile:
                            () => signUpController.pickFile(
                              signUpController.selectedFileInsuranceProof,
                            ),
                        title: AppStrings.liabilityInsuranceProof.tr,
                        centerText: AppStrings.uploadInsuranceDoc.tr,
                        acceptedFile: AppStrings.acceptedFilesInfo.tr,
                      ),
                      UploadDocumentWidget(
                        selectedFileName: signUpController.selectedFileCnpd,
                        pickFile:
                            () => signUpController.pickFile(
                              signUpController.selectedFileCnpd,
                            ),
                        title: AppStrings.cnpdGdprForm.tr,
                        centerText: AppStrings.attachComplianceForm.tr,
                        acceptedFile: AppStrings.acceptedFilesInfo.tr,
                      ),

                      _buildSectionTitle(AppStrings.payment.tr),
                      UploadDocumentWidget(
                        selectedFileName:
                            signUpController.selectedFileBankVerification,
                        pickFile:
                            () => signUpController.pickFile(
                              signUpController.selectedFileBankVerification,
                            ),
                        title: AppStrings.bankVerificationLetter.tr,
                        centerText: AppStrings.uploadBankConfirmation.tr,
                        acceptedFile: AppStrings.acceptedFilesInfo.tr,
                      ),
                      UploadDocumentWidget(
                        selectedFileName:
                            signUpController
                                .selectedFileBankPaymentAuthorization,
                        pickFile:
                            () => signUpController.pickFile(
                              signUpController
                                  .selectedFileBankPaymentAuthorization,
                            ),
                        title: AppStrings.paymentAuthorization.tr,
                        centerText: AppStrings.attachSignedForm.tr,
                        acceptedFile: AppStrings.acceptedFilesInfo.tr,
                      ),
                    ],
                  ),
                ),
              ),

              40.verticalSpace,
              CustomButton(
                borderRadius: 15,
                text: AppStrings.continueText.tr,
                onTap: () {
                  if(signUpController.selectedFileIdCard.value==null ||
                      signUpController.selectedFilePassport.value==null ||
                  signUpController.selectedFileMedicalLicense.value==null ||
                      signUpController.selectedFileDiploma.value==null ||
                      signUpController.selectedFileInsuranceProof.value==null ||
                      signUpController.selectedFileCnpd.value==null ||
                      signUpController.selectedFileBankPaymentAuthorization.value==null ||
                      signUpController.selectedFileBankVerification.value==null){
                    Get.snackbar(
                      AppStrings.warning.tr,
                      AppStrings.pleaseUploadDocument.tr,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  Get.to(ReviewAndSubmission());
                },
              ),
              50.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 19.sp,
          fontWeight: FontWeight.w700,
          fontFamily: AppFonts.jakartaBold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
