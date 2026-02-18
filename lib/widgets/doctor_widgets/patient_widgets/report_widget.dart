import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';

class ReportWidget extends StatelessWidget {
  final String? patientId;

  const ReportWidget({
    Key? key,
    this.patientId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            AppStrings.medicalReports.tr,
            style: TextStyle(fontSize: 21.sp, fontWeight: FontWeight.w600),
          ),
        ),
        10.verticalSpace,
        _buildMedicalRecordsCard(context),
        20.verticalSpace,
        CustomButton(
          borderRadius: 15,
          text: AppStrings.addNewReports.tr,
          onTap: () {
            _showAddReportDialog();
          },
        ),
        30.verticalSpace,
      ],
    );
  }

  Widget _buildRecordTile(
      BuildContext context,
      IconData iconData,
      String title,
      String date,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(iconData, color: Colors.blue.shade700, size: 19.sp),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        decorationColor: Colors.blue.shade700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    _viewReport(title);
                  },
                  child: Icon(
                    Icons.visibility_outlined,
                    color: AppColors.primaryColor,
                    size: 21.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                InkWell(
                  onTap: () {
                    _showDeleteConfirmation(title);
                  },
                  child: Icon(
                    Icons.delete_outline,
                    color: AppColors.red,
                    size: 21.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green.shade600, size: 16.sp),
            const SizedBox(width: 8),
            Text(
              date,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMedicalRecordsCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.sp),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildRecordTile(
              context,
              Icons.science_outlined,
              AppStrings.bloodTest.tr,
              'Jan 2025',
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Divider(
                height: 0,
                thickness: 1,
                color: Colors.grey.shade300,
              ),
            ),
            _buildRecordTile(
              context,
              Icons.description_outlined,
              AppStrings.chestXray.tr,
              'Jan 2025',
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Divider(
                height: 0,
                thickness: 1,
                color: Colors.grey.shade300,
              ),
            ),
            _buildRecordTile(
              context,
              Icons.medical_services_outlined,
              'MRI Scan',
              'Dec 2024',
            ),
          ],
        ),
      ),
    );
  }

  void _viewReport(String reportTitle) {
    Get.snackbar(
      'Viewing Report',
      'Opening $reportTitle',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primaryColor,
      colorText: Colors.white,
    );
  }

  void _showDeleteConfirmation(String reportTitle) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Delete Report',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete $reportTitle?',
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Deleted',
                'Report deleted successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddReportDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Add New Report',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Report Title',
                hintText: 'e.g., Blood Test Report',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'Date',
                hintText: 'Select date',
                suffixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'Notes',
                hintText: 'Enter any additional notes',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 10.h),
            ElevatedButton.icon(
              onPressed: () {
                // Upload file
              },
              icon: Icon(Icons.upload_file),
              label: Text('Upload File'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.black,
                minimumSize: Size(1.sw, 45.h),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Success',
                'Report added successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.green,
                colorText: Colors.white,
              );
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}