import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patient_app/models/prscription_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../../widgets/custom_button.dart';
import 'order_summary.dart';

class PrescriptionDetails extends StatelessWidget {
  final PrescriptionModel prescriptionModel;

  PrescriptionDetails({super.key, required this.prescriptionModel});

  Color _getStatusColor(PrescriptionStatus status) {
    switch (status) {
      case PrescriptionStatus.active:
        return AppColors.primaryColor;
      case PrescriptionStatus.expirySoon:
        return AppColors.orange;
      case PrescriptionStatus.expired:
        return AppColors.red;
      case PrescriptionStatus.completed:
        return AppColors.green;
    }
  }

  Widget _buildStatusChip(PrescriptionStatus status) {
    String text;
    switch (status) {
      case PrescriptionStatus.active:
        text = AppStrings.active.tr;
        break;
      case PrescriptionStatus.expirySoon:
        text = AppStrings.expirySoon.tr;
        break;
      case PrescriptionStatus.expired:
        text = AppStrings.expired.tr;
        break;
      case PrescriptionStatus.completed:
        text = AppStrings.completed.tr;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

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
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Image.asset(
                      AppImages.backIcon,
                      height: 33.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    AppStrings.prescriptionDetails.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 21.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              20.verticalSpace,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 85.h,
                        width: 1.sw,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(12.sp),
                        child: Row(
                          children: [
                            Image.asset(prescriptionModel.doctorImageUrl),
                            10.horizontalSpace,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  prescriptionModel.doctorName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.sp,
                                    fontFamily: AppFonts.jakartaBold,
                                    color: Colors.black,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: AppColors.primaryColor,
                                    ),
                                    Text(
                                      "Elite Ortho Clinic, USA",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 11.sp,
                                        fontFamily: AppFonts.jakartaBold,
                                        color: AppColors.lightGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            5.horizontalSpace,
                            _buildStatusChip(prescriptionModel.status),
                          ],
                        ),
                      ),
                      20.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.prescriptionInfo.tr,
                          style: TextStyle(
                            fontFamily: AppFonts.jakartaBold,
                            fontSize: 18.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 33.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.dateOfIssue.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              AppStrings.validUntil.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      5.verticalSpace,
                      Padding(
                        padding: EdgeInsets.only(right: 33.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "12/Sep/2025",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                color: AppColors.lightGrey,
                              ),
                            ),
                            Text(
                              "12/Nov/2025",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                color: AppColors.lightGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      5.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.eligibleTill.tr,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          5.horizontalSpace,
                          Text(
                            "Next 20 days",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16.sp,
                              color: AppColors.lightGrey,
                            ),
                          ),
                        ],
                      ),
                      15.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.diagnosisHistory.tr,
                          style: TextStyle(
                            fontFamily: AppFonts.jakartaBold,
                            fontSize: 18.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Card(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.diagnosis.tr,
                                style:TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              4.verticalSpace,
                              const Text(
                                'Migraine without aura',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              16.verticalSpace,
                              Text(
                                AppStrings.notes.tr,
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,),
                              ),
                              8.verticalSpace,
                              Text(
                                'Symptoms improving, headache frequency reduced from 5 to 2 times per week.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              4.verticalSpace,
                              Text(
                                'Advised patient to continue current regimen and maintain sleep hygiene',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.prescriptionHistory.tr,
                          style: TextStyle(
                            fontFamily: AppFonts.jakartaBold,
                            fontSize: 18.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Card(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppStrings.prescriptions.tr,
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chat_bubble_outline,
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Amoxicillin 500mg',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Morning & Evening – 7 Days',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.lock,
                                    size: 18,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    AppStrings.encryptionNote.tr,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.electronicSign.tr,
                          style: TextStyle(
                            fontFamily: AppFonts.jakartaBold,
                            fontSize: 18.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Drsarah',
                          style: GoogleFonts.dancingScript(
                            textStyle: const TextStyle(
                              fontSize: 40,
                              fontStyle: FontStyle.italic,
                              color: Colors.black87,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.note.tr,
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                AppStrings.digitalSignNote.tr,
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      30.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.getMedicine.tr,
                        onTap: () {
                          Get.to(OrderSummaryScreen());
                        },
                      ),
                      15.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.downloadPdf.tr,
                        onTap: () {},
                        bgColor: AppColors.inACtiveButtonColor,
                        fontColor: Colors.black,
                      ),
                      40.verticalSpace,
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
}