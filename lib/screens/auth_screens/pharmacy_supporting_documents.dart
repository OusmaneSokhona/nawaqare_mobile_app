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

class PharmacySupportingDocuments extends StatelessWidget {
  PharmacySupportingDocuments({super.key});

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
              Text(
                AppStrings.uploadInstruction.tr,
                style: TextStyle(color: AppColors.lightGrey),
              ),
              20.verticalSpace,
              ProgressStepper(currentStep: 4, totalSteps: 5),
              15.verticalSpace,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 10,
                    children: [
                      UploadDocumentWidget(
                        selectedFileName: signUpController.selectedLicenseCertificate,
                        pickFile: () {
                          signUpController.pickFile(signUpController.selectedLicenseCertificate);
                        },
                        title: AppStrings.licenseCertificate.tr,
                        centerText: AppStrings.uploadLicense.tr,
                        acceptedFile: AppStrings.acceptedFilesInfo.tr,
                      ),
                      UploadDocumentWidget(
                        selectedFileName: signUpController.selectedTaxClearance,
                        pickFile: () {
                          signUpController.pickFile(signUpController.selectedTaxClearance);
                        },
                        title: AppStrings.taxClearance.tr,
                        centerText: AppStrings.uploadTax.tr,
                        acceptedFile: AppStrings.acceptedFilesInfo.tr,
                      ),
                      UploadDocumentWidget(
                        selectedFileName: signUpController.selectedNocCertificate,
                        pickFile: () {
                          signUpController.pickFile(signUpController.selectedNocCertificate);
                        },
                        title: AppStrings.nocCertificate.tr,
                        centerText: AppStrings.uploadNoc.tr,
                        acceptedFile: AppStrings.acceptedFilesInfo.tr,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.payment.tr,
                          style: TextStyle(
                            fontSize: 19.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: AppFonts.jakartaBold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      UploadDocumentWidget(
                        selectedFileName: signUpController.selectedPharmacyBankVerificationLetter,
                        pickFile: () {
                          signUpController.pickFile(signUpController.selectedPharmacyBankVerificationLetter);
                        },
                        title: AppStrings.bankVerificationLetter.tr,
                        centerText: AppStrings.uploadBankConfirmation.tr,
                        acceptedFile: AppStrings.acceptedFilesInfo.tr,
                      ),
                      UploadDocumentWidget(
                        selectedFileName: signUpController.selectedFileBankPaymentAuthorization,
                        pickFile: () {
                          signUpController.pickFile(signUpController.selectedFileBankPaymentAuthorization);
                        },
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
                  if(signUpController.selectedLicenseCertificate.value==null||
                      signUpController.selectedTaxClearance.value==null||
                      signUpController.selectedNocCertificate.value==null||
                      signUpController.selectedPharmacyBankVerificationLetter.value==null||
                      signUpController.selectedFileBankPaymentAuthorization.value==null

                  ){
                    Get.snackbar(AppStrings.warning.tr, AppStrings.uploadDocument.tr,
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white);
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
}