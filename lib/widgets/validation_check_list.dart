import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../utils/app_strings.dart';
import '../utils/app_fonts.dart';

class ValidationChecklist extends StatelessWidget {
  final List<ValidationRule> rules;

  const ValidationChecklist({super.key, required this.rules});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.0.h, left: 8.0.w, right: 8.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.passwordRequirementHeader.tr,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.jakartaMedium,
              color: Colors.black54,
            ),
          ),
          8.verticalSpace,
          ...rules.map((rule) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0.h),
              child: Row(
                children: [
                  Icon(
                    rule.isValid ? Icons.check_box : Icons.check_box_outline_blank,
                    color: rule.isValid ? const Color(0xFF4CAF50) : Colors.grey.shade400,
                    size: 20.sp,
                  ),
                  8.horizontalSpace,
                  Expanded(
                    child: Text(
                      rule.text, // Passed as AppStrings.someRule.tr from the controller
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: AppFonts.jakartaRegular,
                        color: rule.isValid ? Colors.black87 : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class ValidationRule {
  final String text;
  final bool isValid;
  ValidationRule({required this.text, required this.isValid});
}