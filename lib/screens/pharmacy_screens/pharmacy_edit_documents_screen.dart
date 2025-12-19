import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controllers/sign_up_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/display_field.dart';
import '../../../widgets/profile_picture_widget.dart';
import '../../widgets/upload_document_widget.dart';

class PharmacyEditDocumentsScreen extends GetView<SignUpController> {
  PharmacyEditDocumentsScreen({super.key});
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
                    "Edit Documents",
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
                        pickFile: (){
                          controller.pickFile(controller.selectedLicenseCertificate);
                        },
                        title: "License Certificate",
                        centerText: "Upload your License Certificate",
                        acceptedFile: "Accepted files: PDF, JPEG – max 5MB.",
                      ),
                      UploadDocumentWidget(
                        selectedFileName: controller.selectedTaxClearance,
                        pickFile: (){
                          controller.pickFile(controller.selectedTaxClearance);
                        },
                        title: "Tax Clearance",
                        centerText: "Upload Tax Clearance",
                        acceptedFile: "Accepted files: PDF, JPEG – max 5MB.",
                      ),
                      UploadDocumentWidget(
                        selectedFileName: controller.selectedNocCertificate,
                        pickFile: (){
                          controller.pickFile(controller.selectedNocCertificate);
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
                        selectedFileName: controller.selectedPharmacyBankVerificationLetter,
                        pickFile: (){
                          controller.pickFile(controller.selectedPharmacyBankVerificationLetter);
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
                      30.verticalSpace,
                      CustomButton(borderRadius: 15, text: "Update", onTap: (){}),
                      10.verticalSpace,
                      CustomButton(borderRadius: 15, text: "Cancel", onTap: (){Get.back();},bgColor: AppColors.inACtiveButtonColor,fontColor: Colors.black,),
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
