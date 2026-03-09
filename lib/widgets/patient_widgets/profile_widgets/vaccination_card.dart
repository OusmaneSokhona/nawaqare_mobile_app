import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/models/vaccination_history_model.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:url_launcher/url_launcher.dart';

class VaccinationCard extends StatelessWidget {
  final Function onTap;
  final VaccinationHistoryModel vaccinationHistoryModel;

  const VaccinationCard({
    required this.vaccinationHistoryModel,
    super.key,
    required this.onTap
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "active":
        return AppColors.primaryColor;
      case "pending":
        return AppColors.orange;
      case "expired":
        return AppColors.red;
      case "completed":
        return AppColors.green;
      default:
        return Colors.grey;
    }
  }

  String _getLocalizedStatus(String status) {
    switch (status.toLowerCase()) {
      case "active":
        return AppStrings.active.tr;
      case "pending":
        return AppStrings.pending.tr;
      case "expired":
        return AppStrings.expired.tr;
      case "completed":
        return AppStrings.completed.tr;
      default:
        return status;
    }
  }

  Widget _buildStatusChip(String status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        _getLocalizedStatus(status),
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _launchCertificate() async {
    if (vaccinationHistoryModel.certificate != null &&
        vaccinationHistoryModel.certificate!.isNotEmpty) {
      final Uri url = Uri.parse(vaccinationHistoryModel.certificate!);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        Get.snackbar('Error', 'Could not open certificate',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vaccinationHistoryModel.vaccineName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    if (vaccinationHistoryModel.certificate != null)
                      GestureDetector(
                        onTap: _launchCertificate,
                        child: Row(
                          children: [
                            Icon(
                              Icons.insert_drive_file,
                              size: 14.sp,
                              color: AppColors.primaryColor,
                            ),
                            4.horizontalSpace,
                            Expanded(
                              child: Text(
                                'View Certificate',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.primaryColor,
                                  decoration: TextDecoration.underline,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Text(
                        'No certificate',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.lightGrey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                  ],
                ),
              ),
              10.horizontalSpace,
              _buildStatusChip(vaccinationHistoryModel.status),
            ],
          ),
          const Divider(),
          Text(
            "${AppStrings.lastUpdatedLabel.tr} ${vaccinationHistoryModel.lastUpdated}",
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.darkGrey,
            ),
          ),
        ],
      ),
    );
  }
}