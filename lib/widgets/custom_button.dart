import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient_app/utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  final int borderRadius;
  final String text;
  final Color bgColor;
  final Color fontColor;
  final VoidCallback onTap;
  final int fontSize;
  final double height;
  const CustomButton({super.key,required this.borderRadius,required this.text, required this.onTap, this.bgColor = AppColors.primaryColor, this.fontSize = 20, this.fontColor = Colors.white,this.height=50});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height.h,
        width: 0.9.sw,
        decoration: BoxDecoration(
          color:bgColor,
          borderRadius: BorderRadius.circular(borderRadius.r??10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,

        child: Text(text,
            style: TextStyle(
              color:fontColor,
              fontSize: fontSize.sp,
              fontWeight: FontWeight.w600,
            )),
      ),
    );
  }
}
