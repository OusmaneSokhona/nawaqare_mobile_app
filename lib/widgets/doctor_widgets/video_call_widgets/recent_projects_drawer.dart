import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/appointment_controllers/video_call_controller.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/custom_text_field.dart';

import '../../../utils/app_fonts.dart';

class RecentProjectsDrawer extends GetView<VideoCallController> {
  const RecentProjectsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.9,
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Container(
            width: 0.8.sw,
            height: 1.sh,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.onboardingBackground, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 60.h, left: 18.w, right: 10.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Projects',
                      style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    20.verticalSpace,
                    _buildMedicalRecordsCard(context),
                    30.verticalSpace,
                    CustomButton(borderRadius: 15, text: "Upload New Report", onTap: (){}),
                    30.verticalSpace,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 12.w,
            top: 55.h,
            child: Container(
              height: 40.h,
              width: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_forward_outlined,
                  color: Colors.white,
                  size: 20.sp,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildRecordTile(BuildContext context, IconData iconData, String title, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            Icon(Icons.visibility_outlined, color: Colors.blue.shade500, size: 21.sp),
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
              'Blood Test',
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
              'Chest X-ray',
              'Jan 2025',
            ),
            40.verticalSpace,
          ],
        ),
      ),
    );
  }
}
