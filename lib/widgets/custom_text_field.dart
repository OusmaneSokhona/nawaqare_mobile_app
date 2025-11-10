import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTapEye;
  final bool isPasswordField;
  final bool isEnabled;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.hintText = '',
    this.controller,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.validator,
    this.onChanged,
    this.isEnabled = false,
     this.onTapEye ,
    this.isPasswordField = false,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1E88E5); // Example primary color
    const Color fillColor = Colors.white;
    const double borderRadius = 12.0;

    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text(
              labelText,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextFormField(
              onTapOutside: (_){
                FocusManager.instance.primaryFocus?.unfocus();
              },
              controller: controller,
              keyboardType: keyboardType,
              validator: validator,
              onChanged: onChanged,
              obscureText: isEnabled,
              style: const TextStyle(fontSize: 16.0, color: Colors.black),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: prefixIcon != null
                    ? Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 10.0),
                  child: Icon(
                    prefixIcon,
                    color: primaryColor,
                    size: 24.0,
                  ),
                )
                    : null,
                suffixIcon: isPasswordField
                    ? Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: InkWell(
                    onTap: () {
                     onTapEye!();
                    },
                    child: Icon(
                      isEnabled?Icons.visibility:Icons.visibility_off,
                      color: Colors.grey,
                      size: 24.0,
                    ),
                  ),
                )
                    : null,
                contentPadding: prefixIcon != null
                    ? null // Let Flutter calculate padding if icon is present
                    : const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                filled: true,
                fillColor: fillColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide.none, // Removes the standard border
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide.none,
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
        ],
      ),
    );
  }
}