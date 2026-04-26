import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controllers/sign_up_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../../widgets/custom_button.dart';
import '../../widgets/upload_document_widget.dart';

class PharmacyEditDocumentsScreen extends GetView<SignUpController> {
  const PharmacyEditDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.onboardingBackground,
              Colors.white,
            ],
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
                    AppStrings.editDocuments.tr,
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
                      UploadDocumentWidget(
                        selectedFileName: controller.selectedLicenseCertificate,
                        pickFile: () {
                          controller.pickFile(controller.selectedLicenseCertificate);
                        },
                        title: AppStrings.licenseCertificate.tr,
                        centerText: AppStrings.uploadLicenseCertificate.tr,
                        acceptedFile: AppStrings.acceptedFilesHint.tr,
                      ),
                      UploadDocumentWidget(
                        selectedFileName: controller.selectedTaxClearance,
                        pickFile: () {
                          controller.pickFile(controller.selectedTaxClearance);
                        },
                        title: AppStrings.taxClearance.tr,
                        centerText: AppStrings.uploadTaxClearance.tr,
                        acceptedFile: AppStrings.acceptedFilesHint.tr,
                      ),
                      UploadDocumentWidget(
                        selectedFileName: controller.selectedNocCertificate,
                        pickFile: () {
                          controller.pickFile(controller.selectedNocCertificate);
                        },
                        title: AppStrings.nocCertificate.tr,
                        centerText: AppStrings.uploadNocCertificate.tr,
                        acceptedFile: AppStrings.acceptedFilesHint.tr,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.paymentSetting.tr, // Reusing payment setting string
                          style: TextStyle(
                            fontSize: 19.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: AppFonts.jakartaBold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      UploadDocumentWidget(
                        selectedFileName: controller.selectedPharmacyBankVerificationLetter,
                        pickFile: () {
                          controller.pickFile(controller.selectedPharmacyBankVerificationLetter);
                        },
                        title: AppStrings.bankVerificationLetter.tr,
                        centerText: AppStrings.uploadBankConfirmation.tr,
                        acceptedFile: AppStrings.acceptedFilesHint.tr,
                      ),
                      UploadDocumentWidget(
                        selectedFileName: controller.selectedFileBankPaymentAuthorization,
                        pickFile: () {
                          controller.pickFile(controller.selectedFileBankPaymentAuthorization);
                        },
                        title: AppStrings.paymentAuthorization.tr,
                        centerText: AppStrings.attachSignedForm.tr,
                        acceptedFile: AppStrings.acceptedFilesHint.tr,
                      ),
                      30.verticalSpace,
                      CustomButton(
                          borderRadius: 15,
                          text: AppStrings.update.tr,
                          onTap: () {}
                      ),
                      10.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.cancel.tr,
                        onTap: () { Get.back(); },
                        bgColor: AppColors.inACtiveButtonColor,
                        fontColor: Colors.black,
                      ),
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