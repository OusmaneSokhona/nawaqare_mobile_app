import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_colors.dart';

class VerificationCodeWidget extends StatelessWidget {
  final GetxController controller;
  const VerificationCodeWidget({super.key,required this.controller});

  @override
  Widget build(BuildContext context) {
    // Cast the controller to dynamic to safely access shared properties
    // (controllers, focusNodes, handleCodeChange) that exist on both SignUpController and ForgetPasswordController.
    final dynamic verifiedController = controller;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: AspectRatio(
              aspectRatio: 1,
              child: _DigitInputField(
                // Accessing properties via the dynamic variable
                controller: verifiedController.controllers[index],
                focusNode: verifiedController.focusNodes[index],
                onChanged: (value) => verifiedController.handleCodeChange(index, value),
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