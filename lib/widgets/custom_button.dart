import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient_app/main.dart';
import 'package:patient_app/utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  final int borderRadius;
  final String text;
  final Color bgColor;
  final Color fontColor;
  final VoidCallback onTap;
  final int fontSize;
  final double height;
  final IconData? icon;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.borderRadius,
    required this.text,
    required this.onTap,
    this.bgColor = AppColors.primaryColor,
    this.fontSize = 18,
    this.fontColor = Colors.white,
    this.height = 50,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: height.h,
        width: isWeb ? 0.6.sw : 0.9.sw,
        decoration: BoxDecoration(
          color: isLoading ? bgColor.withOpacity(0.7) : bgColor,
          borderRadius: BorderRadius.circular((borderRadius.r) ?? 10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: isLoading
            ? SizedBox(
          height: 20.h,
          width: 20.h,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: fontColor,
          ),
        )
            : (icon != null
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24.sp,
              color: fontColor,
            ),
            5.horizontalSpace,
            Text(
              text,
              style: TextStyle(
                color: fontColor,
                fontSize: fontSize.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        )
            : Text(
          text,
          style: TextStyle(
            color: fontColor,
            fontSize: fontSize.sp,
            fontWeight: FontWeight.w600,
          ),
        )),
      ),
    );
  }
}