import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controllers/sign_up_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/upload_document_widget.dart';


class EditSupportingDocuments extends GetView<SignUpController> {
  EditSupportingDocuments({super.key});
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
                    "Edit Personal Info",
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
                    spacing: 10,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Identity Documents',
                          style: TextStyle(
                            fontSize: 19.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: AppFonts.jakartaBold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      UploadDocumentWidget(
                        selectedFileName: controller.selectedFileIdCard,
                        pickFile: (){
                          controller.pickFile(controller.selectedFileIdCard);
                        },
                        title: "National Identity Document",
                        centerText: "Upload your Document",
                        acceptedFile: "Accepted files: PDF, JPEG – max 5MB.",
                      ),
                      UploadDocumentWidget(
                        selectedFileName: controller.selectedFilePassport,
                        pickFile: (){
                          controller.pickFile(controller.selectedFilePassport);
                        },
                        title: "Passport or ID Front",
                        centerText: "Upload front side",
                        acceptedFile: "Accepted files: PDF, JPEG – max 5MB.",
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Credentials',
                          style: TextStyle(
                            fontSize: 19.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: AppFonts.jakartaBold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      UploadDocumentWidget(
                        selectedFileName: controller.selectedFileMedicalLicense,
                        pickFile: (){
                          controller.pickFile(controller.selectedFileMedicalLicense);
                        },
                        title: "Medical License",
                        centerText: "Upload your valid license",
                        acceptedFile: "Accepted files: PDF, JPEG – max 5MB.",
                      ),
                      UploadDocumentWidget(
                        selectedFileName: controller.selectedFileDiploma,
                        pickFile: (){
                          controller.pickFile(controller.selectedFileDiploma);
                        },
                        title: "Diploma / Certification",
                        centerText: "Upload diploma or transcript",
                        acceptedFile: "Accepted files: PDF, JPEG – max 5MB.",
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Legal',
                          style: TextStyle(
                            fontSize: 19.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: AppFonts.jakartaBold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      UploadDocumentWidget(
                        selectedFileName: controller.selectedFileInsuranceProof,
                        pickFile: (){
                          controller.pickFile(controller.selectedFileInsuranceProof);
                        },
                        title: "Liability Insurance Proof",
                        centerText: "Upload insurance document",
                        acceptedFile: "Accepted files: PDF, JPEG – max 5MB.",
                      ),
                      UploadDocumentWidget(
                        selectedFileName: controller.selectedFileCnpd,
                        pickFile: (){
                          controller.pickFile(controller.selectedFileCnpd);
                        },
                        title: "CNPD / GDPR Form",
                        centerText: "Attach compliance form",
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
                        selectedFileName: controller.selectedFileBankVerification,
                        pickFile: (){
                          controller.pickFile(controller.selectedFileBankVerification);
                        },
                        title: "Bank Verification Letter",
                        centerText: "Upload bank confirmation",
                        acceptedFile: "Accepted files: PDF, JPEG – max 5MB.",
                      ),
                      UploadDocumentWidget(
                        selectedFileName: controller.selectedFileBankPaymentAuthorization,
                        pickFile: (){
                          controller.pickFile(controller.selectedFileBankPaymentAuthorization);
                        },
                        title: "Payment Authorization",
                        centerText: "Attach signed form",
                        acceptedFile: "Accepted files: PDF, JPEG – max 5MB.",
                      ),
                    ],
                  ),
                ),
              ),
              20.verticalSpace,
              CustomButton(
                text: "Update",
                onTap: (){
                  Get.back();
                },
                borderRadius: 15,
              ),
              10.verticalSpace,
              CustomButton(
                text: "Cancel",
                onTap: (){
                  Get.back();
                },
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
  void _showDatePicker(BuildContext context) async {
    final List<DateTime?>? dates = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.single,
        selectedDayHighlightColor: Colors.blue,
        centerAlignModePicker: true,
      ),
      dialogSize: const Size(325, 400),
      value: [controller.selectedDate],
      // Current date value
      borderRadius: BorderRadius.circular(15),
    );
  }
  static Widget buildDropdownField({
    required String title,
    required List<String> items,
    required Rx<String?> selectedValue,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0, left: 10.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Obx(
                () => DropdownButtonFormField<String>(
              value: selectedValue.value,
              decoration: InputDecoration(
                contentPadding:  EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              isExpanded: true,
              icon:  Icon(Icons.keyboard_arrow_down, color: AppColors.darkGrey),
              style: TextStyle(fontSize: 16.sp, color: Colors.black),
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
