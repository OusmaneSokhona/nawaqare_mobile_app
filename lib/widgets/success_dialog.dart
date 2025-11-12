import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_colors.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                Image.asset(
                  'assets/images/profile_complete_image.png',
                  height: 120,
                  width: 120,
                ),
                const SizedBox(height: 24),

                const Text(
                  'Your Profile Is Completed',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E212B),
                  ),
                ),
                const SizedBox(height: 12),

                const Text(
                  "Profile completed — you're all set to begin your healthcare journey!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Color(0xFF6B7280), // Gray 500 equivalent
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          Positioned(
            top: 10,
            right: 10,
            child: InkWell(
              onTap: (){Get.back();},
              child: Container(
                height: 35.h,
                width: 35.w,
                alignment: Alignment.center,

                decoration: BoxDecoration(color: AppColors.primaryColor,shape: BoxShape.circle),
                child:  Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                  ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}