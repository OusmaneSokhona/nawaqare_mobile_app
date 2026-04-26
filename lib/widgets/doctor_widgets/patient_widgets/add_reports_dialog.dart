import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/doctor_controllers/report_controller.dart';
import '../../../utils/app_colors.dart';

class AddReportDialog extends StatelessWidget {
  final ReportController controller;
  final String patientId;

  const AddReportDialog({
    Key? key,
    required this.controller,
    required this.patientId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add New Report',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    controller.clearSelectedFile();
                    Get.back();
                  },
                  icon: Icon(Icons.close, size: 20.sp),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            TextField(
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Report Title',
                hintText: 'e.g., Blood Test Report',
                prefixIcon: Icon(Icons.description_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              controller: categoryController,
              decoration: InputDecoration(
                labelText: 'Category',
                hintText: 'e.g., Blood Test, X-Ray, MRI',
                prefixIcon: Icon(Icons.category_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Obx(() => InkWell(
              onTap: controller.pickFile,
              child: Container(
                height: 100.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: controller.selectedFileName.value != null ? AppColors.primaryColor : Colors.grey.shade300,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  color: controller.selectedFileName.value != null ? AppColors.primaryColor.withOpacity(0.05) : Colors.grey.shade50,
                ),
                child: controller.selectedFileName.value != null
                    ? Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.insert_drive_file,
                            size: 32.sp,
                            color: AppColors.primaryColor,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            controller.selectedFileName.value!.split('/').last,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 8.w,
                      top: 8.h,
                      child: GestureDetector(
                        onTap: controller.clearSelectedFile,
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 16.sp,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                    : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 32.sp,
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Tap to upload file',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        'PDF, JPG, PNG, GIF',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      controller.clearSelectedFile();
                      Get.back();
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                      if (titleController.text.isNotEmpty &&
                          categoryController.text.isNotEmpty) {
                        controller.addReportWithFile(
                          patientId: patientId,
                          name: titleController.text,
                          category: categoryController.text,
                        );
                      } else {
                        Get.snackbar(
                          'Error',
                          'Please fill all required fields',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : Text(
                      'Add Report',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}