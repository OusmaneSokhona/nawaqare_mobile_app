import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/doctor_widgets/patient_widgets/add_reports_dialog.dart';

import '../../../controllers/doctor_controllers/report_controller.dart';

class ReportWidget extends StatelessWidget {
  final String? patientId;
  final String? doctorId;

   ReportWidget({
    Key? key,
    this.patientId,
    this.doctorId,
  }) : super(key: key);
  final ReportController controller = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
controller.patientId=patientId??"";
controller.fetchReports();
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
        Obx(() {
          if (controller.isLoading.value && controller.reports.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.errorMessage.value.isNotEmpty) {
            return Center(
              child: Column(
                children: [
                  Text(
                    controller.errorMessage.value,
                    style: TextStyle(color: Colors.red, fontSize: 14.sp),
                  ),
                  SizedBox(height: 10.h),
                  CustomButton(
                    text: 'Retry',
                    onTap: () => controller.fetchReports(),
                   borderRadius: 15,
                    height: 40.h,
                  ),
                ],
              ),
            );
          }

          if (controller.reports.isEmpty) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: Column(
                children: [
                  Icon(
                    Icons.folder_open_outlined,
                    size: 60.sp,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'No reports found',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return _buildMedicalRecordsCard(context, controller);
        }),
        20.verticalSpace,
        CustomButton(
          borderRadius: 15,
          text: AppStrings.addNewReports.tr,
          onTap: () {
           Get.dialog(AddReportDialog(controller: controller, patientId: patientId!));
          },
        ),
        30.verticalSpace,
      ],
    );
  }

  Widget _buildRecordTile(
      BuildContext context,
      ReportController controller,
      Report report,
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
                  Icon(
                    controller.getIconForCategory(report.category),
                    color: Colors.blue.shade700,
                    size: 19.sp,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      report.name,
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
                    controller.viewReport(report);
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
                    _showDeleteConfirmation(controller, report);
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
              controller.formatDate(report.createdAt),
              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMedicalRecordsCard(
      BuildContext context,
      ReportController controller,
      ) {
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
          children: List.generate(
            controller.reports.length,
                (index) {
              final report = controller.reports[index];
              return Column(
                children: [
                  _buildRecordTile(context, controller, report),
                  if (index < controller.reports.length - 1)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Divider(
                        height: 0,
                        thickness: 1,
                        color: Colors.grey.shade300,
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(ReportController controller, Report report) {
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
          'Are you sure you want to delete ${report.name}?',
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
              controller.deleteReport(report.id);
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

}