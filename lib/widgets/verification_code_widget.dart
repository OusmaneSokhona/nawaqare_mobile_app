import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient_app/controllers/forget_password_contorller.dart';
import 'package:patient_app/utils/app_colors.dart';

class VerificationCodeWidget extends StatelessWidget {
  final ForgetPasswordController controller;
  const VerificationCodeWidget({super.key,required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: AspectRatio(
              aspectRatio: 1,
              child: _DigitInputField(
                controller: controller.controllers[index],
                focusNode: controller.focusNodes[index],
                onChanged: (value) => controller.handleCodeChange(index, value),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _DigitInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _DigitInputField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (_) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      cursorColor: AppColors.primaryColor,cursorHeight: 30.h,
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      maxLength: 1,
      buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey.shade100, width: 2),
        ),
      ),
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.blue.shade600,
        fontSize: 32,
        fontWeight: FontWeight.w800,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }
}