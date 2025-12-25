import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/pharmacy_screens/pharmacy_prescription_detail_screen.dart';
import 'package:patient_app/widgets/custom_button.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_images.dart';
import '../../utils/app_strings.dart';

class UploadPrescriptionScreen extends StatelessWidget {
  const UploadPrescriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.onboardingBackground, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              70.verticalSpace,
              _buildHeader(),
              10.verticalSpace,
              Text(
                AppStrings.uploadGuideline.tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black87,
                  fontFamily: AppFonts.jakartaMedium,
                ),
              ),
              20.verticalSpace,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _scanPrescriptionArea(),
                      _orDivider(),
                      _uploadPrescriptionArea(),
                      30.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.continueText.tr,
                        onTap: () {
                          Get.to(() => PharmacyPrescriptionDetailScreen());
                        },
                      ),
                      20.verticalSpace,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        InkWell(
          onTap: () => Get.back(),
          child: Image.asset(
            AppImages.backIcon,
            height: 33.h,
            fit: BoxFit.fill,
          ),
        ),
        10.horizontalSpace,
        Text(
          AppStrings.uploadPrescription.tr,
          style: TextStyle(
            color: Colors.black,
            fontSize: 23.sp,
            fontWeight: FontWeight.w800,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
      ],
    );
  }

  Widget _scanPrescriptionArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.scanPrescription.tr,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        10.verticalSpace,
        Container(
          height: 180.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Center(
            child: ImageIcon(
              AssetImage("assets/images/scan_icon_prescription.png"),
              size: 80,
              color: AppColors.primaryColor,
            ),
          ),
        ),
        8.verticalSpace,
        Center(
          child: Text(
            AppStrings.scanGuideline.tr,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _orDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Text(
        AppStrings.or.tr,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _uploadPrescriptionArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.uploadPrescription.tr,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        10.verticalSpace,
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(30.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              const ImageIcon(
                AssetImage("assets/images/upload_icon.png"),
                size: 40,
                color: AppColors.primaryColor,
              ),
              5.verticalSpace,
              Text(
                AppStrings.dragAndDrop.tr,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              10.verticalSpace,
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                ),
                child: Text(
                  AppStrings.selectFile.tr,
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        8.verticalSpace,
        Text(
          AppStrings.acceptedFilesNote.tr,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}