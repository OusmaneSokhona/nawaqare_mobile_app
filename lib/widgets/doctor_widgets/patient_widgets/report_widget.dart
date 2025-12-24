import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';

class ReportWidget extends StatelessWidget {
  const ReportWidget({super.key});

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
        CustomButton(borderRadius: 15, text: AppStrings.addNewReports.tr, onTap: (){}),
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
            Row(
              children: [
                Icon(iconData, color: Colors.blue.shade700, size: 19.sp),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    decorationColor: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            Spacer(),

            Icon(
              Icons.visibility_outlined,
              color:AppColors.primaryColor,
              size: 21.sp,
            ),
            Icon(
              Icons.delete_outline,
              color: AppColors.red,
              size: 21.sp,
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Icon(Icons.check, color: Colors.green.shade600, size: 20),
            const SizedBox(width: 8),
            Text(
              date,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
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
              padding: const EdgeInsets.symmetric(vertical: 16.0),
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
              padding: const EdgeInsets.symmetric(vertical: 16.0),
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
          ],
        ),
      ),
    );
  }
}