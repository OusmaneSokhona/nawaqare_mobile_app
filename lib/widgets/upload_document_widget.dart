import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../utils/app_fonts.dart';

class UploadDocumentWidget extends StatelessWidget {
  Rx<String?> selectedFileName = Rx<String?>('No file selected');
  final String title;
  final Function pickFile;
  final String centerText;
  final String acceptedFile;

   UploadDocumentWidget({
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
            '$title',
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
          onTap: () {
            pickFile();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
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
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 40,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    selectedFileName.value == 'No file selected' ||
                            selectedFileName.value == 'File selection cancelled'
                        ? '$centerText'
                        : selectedFileName.value!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  if (selectedFileName.value !=
                          'No file selected' &&
                      selectedFileName.value !=
                          'File selection cancelled')
                    const Text(
                      'Tap to select a new file',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                ],
              ),
            ),
          ),
        ),
        3.verticalSpace,
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "$acceptedFile",
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w300,
              fontFamily: AppFonts.jakartaRegular,
            ),
          ),
        ),
      ],
    );
  }
}
