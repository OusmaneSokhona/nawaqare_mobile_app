import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/payment_controller.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_strings.dart';

class CardDateCvvWidget extends StatelessWidget {
  CardDateCvvWidget({super.key});

  final PaymentController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12.r);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppStrings.expirationDate.tr,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  fontFamily: AppFonts.jakartaBold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              InkWell(
                onTap: () => controller.selectDate(context),
                borderRadius: borderRadius,
                child: Container(
                  height: 56.h,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: borderRadius,
                    border: Border.all(
                      color: AppColors.lightGrey.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.primaryColor,
                        size: 20.sp,
                      ),
                      SizedBox(width: 10.w),
                      Obx(
                            () => Text(
                          controller.formattedDate,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppFonts.jakartaMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppStrings.cvv.tr,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  fontFamily: AppFonts.jakartaBold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                height: 56.h,
                child: TextFormField(
                  controller: controller.cvvController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  obscureText: true,
                  obscuringCharacter: '•',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.jakartaMedium,
                    letterSpacing: 2,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                    counterText: "",
                    filled: true,
                    fillColor: Colors.white,
                    hintText: AppStrings.cvvHint.tr,
                    hintStyle: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey.withOpacity(0.5),
                      fontFamily: AppFonts.jakartaRegular,
                    ),
                    prefixIcon: Icon(
                      Icons.security_outlined,
                      color: AppColors.primaryColor,
                      size: 20.sp,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(
                        color: AppColors.lightGrey.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(
                        color: AppColors.lightGrey.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(
                        color: AppColors.primaryColor,
                        width: 1.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(
                        color: AppColors.red,
                        width: 1,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(
                        color: AppColors.red,
                        width: 1.5,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    if (value.length < 3 || value.length > 4) {
                      return 'Invalid';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Numbers only';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}