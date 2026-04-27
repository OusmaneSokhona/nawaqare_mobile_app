import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/doctor_controllers/medical_certificate_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_button.dart';

class MedicalCertificateScreen extends StatelessWidget {
  final String consultationId;

  MedicalCertificateScreen({super.key, required this.consultationId});

  late final MedicalCertificateController controller =
      Get.put(MedicalCertificateController(consultationId: consultationId));

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
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              70.verticalSpace,
              _buildHeader(),
              20.verticalSpace,
              Expanded(
                child: Obx(
                  () => controller.isLoading.value
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              if (controller.certificates.isEmpty)
                                _buildEmptyState(),
                              if (controller.certificates.isNotEmpty)
                                _buildCertificatesList(),
                              30.verticalSpace,
                              CustomButton(
                                borderRadius: 15,
                                text: "New Document",
                                onTap: () => _showNewDocumentBottomSheet(),
                              ),
                              30.verticalSpace,
                            ],
                          ),
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
    return Row(
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Medical Certificates",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 23.sp,
                  fontWeight: FontWeight.w800,
                  fontFamily: AppFonts.jakartaBold,
                ),
              ),
              5.verticalSpace,
              Text(
                "Generate and manage official documents",
                style: TextStyle(
                  color: AppColors.lightGrey,
                  fontSize: 12.sp,
                  fontFamily: AppFonts.jakartaRegular,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 50.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.document_scanner_outlined,
            size: 80.sp,
            color: AppColors.lightGrey,
          ),
          20.verticalSpace,
          Text(
            "No Documents Yet",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.jakartaBold,
            ),
          ),
          10.verticalSpace,
          Text(
            "Create medical certificates, sick leaves, or attestations",
            style: TextStyle(
              color: AppColors.lightGrey,
              fontSize: 13.sp,
              fontFamily: AppFonts.jakartaRegular,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCertificatesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Documents",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        15.verticalSpace,
        ...controller.certificates.map((cert) => _buildCertificateCard(cert)).toList(),
      ],
    );
  }

  Widget _buildCertificateCard(MedicalCertificate cert) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.getCertificateTypeLabel(cert.type),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.jakartaBold,
                      ),
                    ),
                    5.verticalSpace,
                    if (cert.type == 'SICK_LEAVE' && cert.durationDays != null)
                      Text(
                        "Duration: ${cert.durationDays} days",
                        style: TextStyle(
                          color: AppColors.darkGrey,
                          fontSize: 12.sp,
                          fontFamily: AppFonts.jakartaRegular,
                        ),
                      ),
                  ],
                ),
              ),
              10.horizontalSpace,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: controller.getCertificateTypeColor(cert.type).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  cert.isSigned == true ? "Signed" : "Draft",
                  style: TextStyle(
                    color: cert.isSigned == true ? AppColors.green : AppColors.orange,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.jakartaBold,
                  ),
                ),
              ),
            ],
          ),
          15.verticalSpace,
          Container(
            width: 1.sw,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.lightWhite,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.inACtiveButtonColor),
            ),
            child: Text(
              cert.content,
              style: TextStyle(
                color: AppColors.darkGrey,
                fontSize: 12.sp,
                fontFamily: AppFonts.jakartaRegular,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (cert.isSigned == true && cert.signedAt != null)
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: AppColors.green,
                    size: 16.sp,
                  ),
                  8.horizontalSpace,
                  Text(
                    "Signed by ${cert.signedByDoctor ?? 'Doctor'} on ${_formatDate(cert.signedAt)}",
                    style: TextStyle(
                      color: AppColors.green,
                      fontSize: 11.sp,
                      fontFamily: AppFonts.jakartaRegular,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showNewDocumentBottomSheet() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.r),
            topRight: Radius.circular(25.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "New Document",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    fontFamily: AppFonts.jakartaBold,
                  ),
                ),
                20.verticalSpace,
                _buildDropdownField(
                  label: "Document Type",
                  value: controller.typeController.value.toString().split('.').last,
                  items: ['MEDICAL_CERTIFICATE', 'SICK_LEAVE', 'ATTESTATION'],
                  onChanged: (value) {
                    final docType = CertificateType.values.firstWhere(
                      (e) => e.toString().split('.').last == value,
                      orElse: () => CertificateType.MEDICAL_CERTIFICATE,
                    );
                    controller.typeController.value = docType;
                  },
                ),
                15.verticalSpace,
                _buildTextField(
                  label: "Content",
                  controller: controller.contentController,
                  hint: "Enter the full text of the certificate",
                  maxLines: 6,
                ),
                15.verticalSpace,
                Obx(
                  () {
                    if (controller.typeController.value == CertificateType.SICK_LEAVE) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField(
                            label: "Duration (days)",
                            controller: controller.durationController,
                            hint: "Number of days",
                            maxLines: 1,
                          ),
                          15.verticalSpace,
                        ],
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
                Obx(
                  () => Row(
                    children: [
                      Checkbox(
                        value: controller.isSignedCheckbox.value,
                        onChanged: (value) {
                          controller.isSignedCheckbox.value = value ?? false;
                        },
                        activeColor: AppColors.primaryColor,
                      ),
                      Expanded(
                        child: Text(
                          "I confirm I am signing this document as Dr [name]",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13.sp,
                            fontFamily: AppFonts.jakartaRegular,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (controller.errorMessage.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 15.h),
                    child: Container(
                      width: 1.sw,
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: AppColors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: AppColors.red),
                      ),
                      child: Text(
                        controller.errorMessage.value,
                        style: TextStyle(
                          color: AppColors.red,
                          fontSize: 12.sp,
                          fontFamily: AppFonts.jakartaRegular,
                        ),
                      ),
                    ),
                  ),
                25.verticalSpace,
                Obx(
                  () => CustomButton(
                    borderRadius: 15,
                    text: "Sign & Generate",
                    isLoading: controller.isSaving.value,
                    onTap: () async {
                      final success = await controller.createAndSignCertificate();
                      if (success) {
                        Get.back();
                      }
                    },
                  ),
                ),
                12.verticalSpace,
                CustomButton(
                  borderRadius: 15,
                  text: "Cancel",
                  onTap: () => Get.back(),
                  bgColor: AppColors.inACtiveButtonColor,
                  fontColor: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        10.verticalSpace,
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightWhite,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.inACtiveButtonColor),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              underline: const SizedBox(),
              items: items.map((String val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(
                    _formatDropdownValue(val),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: AppFonts.jakartaRegular,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        10.verticalSpace,
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightWhite,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.inACtiveButtonColor),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: AppColors.lightGrey,
                  fontSize: 13.sp,
                  fontFamily: AppFonts.jakartaRegular,
                ),
              ),
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: AppFonts.jakartaRegular,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDropdownValue(String value) {
    return value.replaceAll('_', ' ').replaceAllMapped(RegExp(r'(?:^|_)([a-z])'), (match) {
      return match.group(1)?.toUpperCase() ?? '';
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "Unknown";
    return "${date.day}/${date.month}/${date.year}";
  }
}
