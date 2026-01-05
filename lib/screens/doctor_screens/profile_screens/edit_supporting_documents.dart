import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../../controllers/auth_controllers/sign_up_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/upload_document_widget.dart';

class EditSupportingDocuments extends GetView<SignUpController> {
  const EditSupportingDocuments({super.key});

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
                    AppStrings.editSupportingDocuments.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              Text(AppStrings.uploadInstruction.tr,style:TextStyle(fontSize: 15.sp,fontFamily: AppFonts.jakartaMedium,color:AppColors.lightGrey,fontWeight: FontWeight.w600),),
              20.verticalSpace,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 10,
                    children: [
                      _buildSectionTitle(AppStrings.identityDocuments.tr),
                      UploadDocumentWidget(
                        selectedFileName: controller.selectedFileIdCard,
                        pickFile: () => controller.pickFile(controller.selectedFileIdCard),
                        title: AppStrings.nationalIdentityDocument.tr,
                        centerText: AppStrings.uploadDocument.tr,
                        acceptedFile: AppStrings.acceptedFilesText.tr,
                      ),
                      UploadDocumentWidget(
                        selectedFileName: controller.selectedFilePassport,
                        pickFile: () => controller.pickFile(controller.selectedFilePassport),
                        title: AppStrings.passportOrIdFront.tr,
                        centerText: AppStrings.uploadFrontSide.tr,
                        acceptedFile: AppStrings.acceptedFilesText.tr,
                      ),
                      _buildSectionTitle(AppStrings.credentials.tr),
                      UploadDocumentWidget(
                        selectedFileName: controller.selectedFileMedicalLicense,
                        pickFile: () => controller.pickFile(controller.selectedFileMedicalLicense),
                        title: AppStrings.medicalLicense.tr,
                        centerText: AppStrings.uploadValidLicense.tr,
                        acceptedFile: AppStrings.acceptedFilesText.tr,
                      ),
                      UploadDocumentWidget(
                        selectedFileName: controller.selectedFileDiploma,
                        pickFile: () => controller.pickFile(controller.selectedFileDiploma),
                        title: AppStrings.diplomaCertification.tr,
                        centerText: AppStrings.uploadDiplomaTranscript.tr,
                        acceptedFile: AppStrings.acceptedFilesText.tr,
                      ),
                      _buildSectionTitle(AppStrings.legal.tr),
                      UploadDocumentWidget(
                        selectedFileName: controller.selectedFileInsuranceProof,
                        pickFile: () => controller.pickFile(controller.selectedFileInsuranceProof),
                        title: AppStrings.liabilityInsuranceProof.tr,
                        centerText: AppStrings.uploadInsuranceDocument.tr,
                        acceptedFile: AppStrings.acceptedFilesText.tr,
                      ),
                      UploadDocumentWidget(
                        selectedFileName: controller.selectedFileCnpd,
                        pickFile: () => controller.pickFile(controller.selectedFileCnpd),
                        title: AppStrings.cnpdGdprForm.tr,
                        centerText: AppStrings.attachComplianceForm.tr,
                        acceptedFile: AppStrings.acceptedFilesText.tr,
                      ),
                      _buildSectionTitle(AppStrings.payment.tr),
                      UploadDocumentWidget(
                        selectedFileName: controller.selectedFileBankVerification,
                        pickFile: () => controller.pickFile(controller.selectedFileBankVerification),
                        title: AppStrings.bankVerificationLetter.tr,
                        centerText: AppStrings.uploadBankConfirmation.tr,
                        acceptedFile: AppStrings.acceptedFilesText.tr,
                      ),
                      UploadDocumentWidget(
                        selectedFileName: controller.selectedFileBankPaymentAuthorization,
                        pickFile: () => controller.pickFile(controller.selectedFileBankPaymentAuthorization),
                        title: AppStrings.paymentAuthorization.tr,
                        centerText: AppStrings.attachSignedForm.tr,
                        acceptedFile: AppStrings.acceptedFilesText.tr,
                      ),
                    ],
                  ),
                ),
              ),
              20.verticalSpace,
              CustomButton(
                text: AppStrings.update.tr,
                onTap: () => Get.back(),
                borderRadius: 15,
              ),
              10.verticalSpace,
              CustomButton(
                text: AppStrings.cancel.tr,
                onTap: () => Get.back(),
                borderRadius: 15,
                bgColor: AppColors.inACtiveButtonColor,
                fontColor: Colors.black,
              ),
              30.verticalSpace,
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