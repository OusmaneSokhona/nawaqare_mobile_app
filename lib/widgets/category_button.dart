import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient_app/main.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';

class CategoryButton extends StatelessWidget {
  final String title;
  final String icon;
  final Color color;
  final Function? onTap;

  const CategoryButton({
    required this.title,
    required this.icon,
    required this.color,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isWeb = MediaQuery.of(context).size.width > 600;

    return InkWell(
      onTap: () {
        if (onTap != null) onTap!();
      },
      borderRadius: BorderRadius.circular(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isWeb ? 60.w : 80.w,
            height: isWeb ? 55.h : 70.h,
            padding: EdgeInsets.all(isWeb ? 15.0 : 18.sp),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Image.asset(
              icon,
              color: Colors.white,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: isWeb ? 14.0 : 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontFamily: AppFonts.jakartaMedium),
          ),
        ],
      ),
    );
  }
}