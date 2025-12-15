import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/auth_screens/review_and_submission.dart';
import 'package:patient_app/widgets/patient_widgets/profile_widgets/success_dialog.dart';
import 'package:patient_app/widgets/upload_document_widget.dart';
import '../../controllers/auth_controllers/sign_up_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/progress_stepper.dart';

class PharmacySupportingDocuments extends StatelessWidget {
  PharmacySupportingDocuments({super.key});

  SignUpController signUpController = Get.find();

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
                      "Documents & Reports",
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
              Text("Upload valid, clear documents for verification. Only PDF/JPEG are accepted.",style: TextStyle(color: AppColors.lightGrey),),
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
                        pickFile: (){
                          signUpController.pickFile(signUpController.selectedLicenseCertificate);
                        },
                        title: "License Certificate",
                        centerText: "Upload your License Certificate",
                        acceptedFile: "Accepted files: PDF, JPEG – max 5MB.",
                      ),
                      UploadDocumentWidget(
                        selectedFileName: signUpController.selectedTaxClearance,
                        pickFile: (){
                          signUpController.pickFile(signUpController.selectedTaxClearance);
                        },
                        title: "Tax Clearance",
                        centerText: "Upload Tax Clearance",
                        acceptedFile: "Accepted files: PDF, JPEG – max 5MB.",
                      ),
                      UploadDocumentWidget(
                        selectedFileName: signUpController.selectedNocCertificate,
                        pickFile: (){
                          signUpController.pickFile(signUpController.selectedNocCertificate);
                        },
                        title: "Noc Certificate",
                        centerText: "Upload your Noc Certificate",
                        acceptedFile: "Accepted files: PDF, JPEG – max 5MB.",
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Payment',
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
                        pickFile: (){
                          signUpController.pickFile(signUpController.selectedPharmacyBankVerificationLetter);
                        },
                        title: "Bank Verification Letter",
                        centerText: "Upload bank confirmation",
                        acceptedFile: "Accepted files: PDF, JPEG – max 5MB.",
                      ),
                      UploadDocumentWidget(
                        selectedFileName: signUpController.selectedFileBankPaymentAuthorization,
                        pickFile: (){
                          signUpController.pickFile(signUpController.selectedFileBankPaymentAuthorization);
                        },
                        title: "Payment Authorization",
                        centerText: "Attach signed form",
                        acceptedFile: "Accepted files: PDF, JPEG – max 5MB.",
                      ),
                    ],
                  ),
                ),
              ),

              40.verticalSpace,
              CustomButton(
                borderRadius: 15,
                text: "Continue",
                onTap: (){
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
