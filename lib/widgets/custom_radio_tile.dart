import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient_app/utils/app_colors.dart';

class CustomRadioTile extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isCircle;
  final double fontSize;
  final VoidCallback onTap;

  const CustomRadioTile({
    super.key,
    required this.text,
    required this.isSelected,
    this.fontSize=18,
    this.isCircle=true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = isSelected ? AppColors.primaryColor : Colors.grey.shade600;
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                shape: isCircle?BoxShape.circle:BoxShape.rectangle,
                border: Border.all(
                  color: primaryColor,
                  width: 2.5,
                ),
                color:  isCircle?Colors.white:isSelected?primaryColor:Colors.transparent,
              ),
              alignment: Alignment.center,
              child: isSelected
                  ? isCircle?Container(
                width: 8.0,
                height: 8.0,
                decoration:  BoxDecoration(
                  shape: isCircle?BoxShape.circle:BoxShape.rectangle,
                  color: primaryColor,
                ),
              ):Icon(Icons.check,color: Colors.white,size:17.sp,)
                  : null, ),
            const SizedBox(width: 12.0),
            Text(
              text,
              style: TextStyle(
                fontSize: fontSize.sp,
                color: Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



