import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/widgets/web_verfication_dialog.dart';
import '../utils/app_images.dart';

class WebForgotPasswordDialog extends StatelessWidget {
  const WebForgotPasswordDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      elevation: 0,
      backgroundColor: AppColors.webBgColor,
      child: Container(
        width:0.6.sw,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontFamily: AppFonts.jakartaBold,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                InkWell(
                  onTap: () => Get.back(),
                  child: Icon(Icons.cancel, color: AppColors.primaryColor, size: 10.sp),
                ),
              ],
            ),
            5.verticalSpace,
            Text(
              "Then Let's Submit Password Reset.",
              style: TextStyle(
                fontSize: 6.sp,
                color: Colors.grey.shade600,
              ),
            ),
            25.verticalSpace,
            _buildVerificationTile(
              icon: "assets/images/mail_icon.png",
              title: "Verification via Email",
              subtitle: "Verify code via email.",
              onTap: () {
                Get.back();
               Get.dialog(WebVerficationDialog(),barrierDismissible: false);
              },
            ),
            15.verticalSpace,
            _buildVerificationTile(
              icon: AppImages.whatsAppIcon,
              title: "Verification via Whatsapp",
              subtitle: "Verify code via Whatsapp.",
              onTap: () {
                Get.back();
                Get.dialog(WebVerficationDialog(),barrierDismissible: false);
              },
            ),
            10.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationTile({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Image.asset(icon, height: 20.h),
            ),
            15.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: AppFonts.jakartaBold,
                      fontSize: 6.5.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 5.sp,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 7.sp, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}