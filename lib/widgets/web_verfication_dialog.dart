import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_images.dart';
import 'package:patient_app/widgets/custom_button.dart';

import '../controllers/auth_controllers/verfication_controller.dart';

class WebVerficationDialog extends StatelessWidget {
  const WebVerficationDialog({super.key});


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerificationController());

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      backgroundColor: Colors.white,
      child: Container(
        width: 0.6.sw,
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            20.verticalSpace,
            Text("A 6-Digit Code Has Been Sent To Whatsapp", style: TextStyle(fontSize: 6.sp, color: Colors.black87)),
            Text("+33 3 6 12 34 56 78", style: TextStyle(fontSize: 6.sp, fontFamily: AppFonts.jakartaBold, fontWeight: FontWeight.w800)),
            15.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) => _buildOtpBox(controller, index)),
            ),
            15.verticalSpace,
            Center(
              child: Obx(() => Column(
                children: [
                  Text(controller.timerText, style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.w800)),
                  Text("Code expires in 01:00", style: TextStyle(fontSize: 5.sp, color: Colors.red)),
                ],
              )),
            ),
            25.verticalSpace,
            CustomButton(text: "Confirms", onTap: () {
              controller.verifyAndNavigate();
            }, fontSize: 6, borderRadius: 10),
            15.verticalSpace,
            _buildResendSection(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Verification", style: TextStyle(fontFamily: AppFonts.jakartaBold, fontSize: 10.sp, fontWeight: FontWeight.w800)),
        InkWell(onTap: () => Get.back(), child: Icon(Icons.cancel, color: AppColors.primaryColor, size: 10.sp))
      ],
    );
  }

  Widget _buildOtpBox(VerificationController controller, int index) {
    return SizedBox(
      width: 15.w, // Adjusted for better web proportion
      height: 45.h,
      child: TextField(
        controller: controller.controllers[index],
        focusNode: controller.focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        cursorHeight: 15.h,
        maxLength: 1,
        style: TextStyle(
          fontSize: 8.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          counterText: "",
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
          ),
        ),
        onChanged: (value) => controller.handleInput(value, index),
      ),
    );
  }
  Widget _buildResendSection(VerificationController controller) {
    return Center(
      child: Column(
        children: [
          InkWell(
            onTap: () => controller.startTimer(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppImages.whatsAppGreenIcon, height: 12.sp),
                8.horizontalSpace,
                Text("Re-send To Whatsapp", style: TextStyle(fontSize: 5.sp, color: Colors.black, fontWeight: FontWeight.w500,decoration: TextDecoration.underline)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}