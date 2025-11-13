import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';

class CategoryButton extends StatelessWidget {
  final String title;
  final String icon;
  final Color color;
  Function? onTap;

   CategoryButton({
    required this.title,
    required this.icon,
    required this.color,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap!();
      },
      borderRadius: BorderRadius.circular(16.0),
      child: Column(
        children: [
          Container(
            width: 90.w,
            height: 75.h,
            padding: EdgeInsets.all(18.sp),
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
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontFamily: AppFonts.jakartaMedium
            ),
          ),
        ],
      ),
    );
  }
}