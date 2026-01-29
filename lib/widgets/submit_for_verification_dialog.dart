import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/auth_screens/sign_in_screen.dart';
import 'package:patient_app/utils/app_bindings.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../widgets/custom_button.dart';

class SubmitForVerificationDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const SubmitForVerificationDialog({
    super.key,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0.r)),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.0.w, 30.0.h, 20.0.w, 20.0.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/images/verification_dialog_image.png",
                  height: 110.h,
                ),
                20.verticalSpace,
                Text(
                  AppStrings.submitForVerification.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    fontFamily: AppFonts.jakartaBold,
                  ),
                ),
                10.verticalSpace,
                Text(
                  AppStrings.verificationReceivedMessage.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: const Color(0xFF757575),
                    fontFamily: AppFonts.jakartaMedium,
                  ),
                ),
                30.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomButton(
                        borderRadius: 15,
                        text: AppStrings.confirm.tr,
                        onTap: onConfirm,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}