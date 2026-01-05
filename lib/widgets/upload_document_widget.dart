import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../utils/app_fonts.dart';
import '../utils/app_strings.dart';

class UploadDocumentWidget extends StatelessWidget {
  final Rx<String?> selectedFileName;
  final String title;
  final Function pickFile;
  final String centerText;
  final String acceptedFile;

  const UploadDocumentWidget({
    super.key,
    required this.selectedFileName,
    required this.pickFile,
    required this.title,
    required this.centerText,
    required this.acceptedFile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title, // This should be passed as AppStrings.someTitle.tr from parent
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.jakartaMedium,
              color: Colors.black87,
            ),
          ),
        ),
        3.verticalSpace,
        InkWell(
          onTap: () => pickFile(),
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Obx(() {
              // Check if there is actually a valid string present
              final String? fileName = selectedFileName.value;

              // Logic: It's empty if it's null, OR if it matches your "No file" strings
              final bool isFileEmpty = fileName == null ||
                  fileName == AppStrings.noFileSelected ||
                  fileName == AppStrings.fileSelectionCancelled;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 40.h,
                    color: Colors.blue.shade700,
                  ),
                  12.verticalSpace,
                  Text(
                    isFileEmpty ? centerText : fileName!, // Safe now because we checked for null
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: AppFonts.jakartaMedium,
                    ),
                  ),
                  if (!isFileEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Text(
                        AppStrings.tapToSelectNewFile.tr,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey,
                          fontFamily: AppFonts.jakartaRegular,
                        ),
                      ),
                    ),
                ],
              );
            }),
          ),
        ),
        3.verticalSpace,
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            acceptedFile, // This should be passed as AppStrings.someAcceptedType.tr from parent
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w300,
              fontFamily: AppFonts.jakartaRegular,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ],
    );
  }
}