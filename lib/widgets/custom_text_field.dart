import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient_app/main.dart';
import 'package:patient_app/utils/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final void Function(String)? onChanged;
  final void Function()? onTapEye;
  final void Function()? onSuffixIconTap;
  final bool isPasswordField;
  final bool isEnabled;
  final Widget? validationView;
  final void Function(bool)? onFocusChange;
  final int maxLength;
  final String? Function(String?)? validator;
  final Color suffixIconColor;
  final Color prefixIconColor;
  final String? prefixImageIcon;
  final double? height;
  final Widget? suffixWidget;

  const CustomTextField({
    super.key,
    this.labelText,
    this.hintText = '',
    this.controller,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.isEnabled = false,
    this.onTapEye,
    this.onSuffixIconTap,
    this.maxLength = 14,
    this.isPasswordField = false,
    this.validationView,
    this.onFocusChange,
    this.validator,
    this.suffixIconColor = Colors.black54,
    this.prefixIconColor = AppColors.primaryColor,
    this.prefixImageIcon,
    this.height,
    this.suffixWidget,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = AppColors.primaryColor;
    const Color fillColor = Colors.white;
    const double borderRadius = 12.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Padding(
            padding: EdgeInsets.only(left: isWeb ? 2.w : 8.w, bottom: 8.h),
            child: Text(
              labelText!,
              style: TextStyle(
                fontSize: isWeb ? 5.sp : 16.sp,
                fontWeight: isWeb ? FontWeight.w500 : FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        Container(
          height: height?.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(isWeb ? 0.0 : 0.1),
                spreadRadius: isWeb ? 0.5 : 2,
                blurRadius: isWeb ? 0 : 5,
                offset: Offset(0, isWeb ? 0 : 3),
              ),
            ],
          ),
          child: Focus(
            onFocusChange: onFocusChange,
            child: TextFormField(
              onTapOutside: (_) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              maxLength: maxLength,
              buildCounter: (context, {required currentLength, required maxLength, required isFocused}) =>
              const SizedBox.shrink(),
              controller: controller,
              keyboardType: keyboardType,
              onChanged: onChanged,
              obscureText: isEnabled,
              validator: validator,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(fontSize: isWeb ? 5.sp : 16.sp, color: Colors.black),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: isWeb ? 5.sp : 12.sp,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: (prefixIcon != null || prefixImageIcon != null)
                    ? Padding(
                  padding: EdgeInsets.only(left: isWeb ? 3.w : 15.w, right: 5.w),
                  child: prefixImageIcon != null
                      ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      prefixImageIcon!,
                      height: 15.h,
                      color: prefixIconColor,
                    ),
                  )
                      : Icon(prefixIcon, color: prefixIconColor, size: isWeb ? 6.sp : 24.sp),
                )
                    : null,
                suffixIcon: (suffixWidget != null || isPasswordField || suffixIcon != null)
                    ? _buildSuffixIcon()
                    : null,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: isWeb ? 5.w : 20.w,
                  vertical: height != null ? 0 : 15.h,
                ),
                filled: true,
                fillColor: fillColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide(color: AppColors.lightGrey.withOpacity(0.3), width: 0.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: const BorderSide(color: primaryColor, width: 1.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                ),
              ),
            ),
          ),
        ),
        if (validationView != null) validationView!,
      ],
    );
  }

  Widget _buildSuffixIcon() {
    if (suffixWidget != null) {
      return Padding(
        padding: EdgeInsets.only(right: isWeb ? 6.w : 10.w),
        child: suffixWidget,
      );
    }
    if (suffixIcon != null) {
      return Padding(
        padding: EdgeInsets.only(right: 20.w),
        child: InkWell(
          onTap: onSuffixIconTap ?? () {},
          child: Icon(suffixIcon, color: suffixIconColor, size: 24.sp),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.only(right: isWeb ? 6.w : 15.w),
      child: InkWell(
        onTap: onTapEye,
        child: Icon(
          !isEnabled ? Icons.visibility : Icons.visibility_off,
          color: Colors.grey,
          size: isWeb ? 6.sp : 24.sp,
        ),
      ),
    );
  }
}