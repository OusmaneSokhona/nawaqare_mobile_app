import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patient_app/models/prscription_model.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_button.dart';

class DoctorPrescriptionDetailScreen extends StatelessWidget {
  final PrescriptionModel prescriptionModel;

  DoctorPrescriptionDetailScreen({super.key, required this.prescriptionModel});

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
        text = AppStrings.activeStatus.tr;
        break;
      case PrescriptionStatus.expirySoon:
        text = AppStrings.expirySoonStatus.tr;
        break;
      case PrescriptionStatus.expired:
        text = AppStrings.expiredStatus.tr;
        break;
      case PrescriptionStatus.completed:
        text = AppStrings.completedStatus.tr;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
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
                    AppStrings.prescriptionDetail.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
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
                                    fontSize: 18.sp,
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
                                        fontSize: 12.sp,
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
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 33.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.prescriptionIdLabel.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13.sp,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              AppStrings.dateOfIssue.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13.sp,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              AppStrings.validUntil.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13.sp,
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
                              "#12345678678",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13.sp,
                                color: AppColors.lightGrey,
                              ),
                            ),
                            Text(
                              "12/Sep/2025",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13.sp,
                                color: AppColors.lightGrey,
                              ),
                            ),
                            Text(
                              "12/Nov/2025",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13.sp,
                                color: AppColors.lightGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      5.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.diagnosis.tr,
                          style: TextStyle(
                            fontFamily: AppFonts.jakartaBold,
                            fontSize: 18.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        width: 1.sw,
                        padding: EdgeInsets.all(12.sp),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.lightGrey.withOpacity(0.2),
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Migraine without aura',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.lightGrey,
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.notes.tr,
                          style: TextStyle(
                            fontFamily: AppFonts.jakartaBold,
                            fontSize: 18.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
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
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 0.65.sw,
                                height: 100.h,
                                child: Text(
                                  'Symptoms improving, headache frequency reduced from 5 to 2 times per week. Advised patient to continue current regimen and maintain sleep hygiene',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.lightGrey,
                                  ),
                                ),
                              ),
                              Image.asset(
                                "assets/images/edit_icon.png",
                                height: 20.h,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppStrings.prescriptionDoctor.tr + "s",
                              style: TextStyle(
                                fontFamily: AppFonts.jakartaBold,
                                fontSize: 18.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Spacer(),
                          Image.asset(
                            "assets/images/chat_icon.png",
                            height: 25.sp,
                            color: AppColors.primaryColor,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Amoxicillin 500mg',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  AppStrings.dosageInstruction.tr,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  ' 1 tablet, twice daily after meals',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.lightGrey,
                                  ),
                                ),
                              ],
                            ),
                            8.verticalSpace,
                            Text(
                              'Refill until Oct 15,2025',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.electronicSign.tr,
                          style: TextStyle(
                            fontFamily: AppFonts.jakartaBold,
                            fontSize: 19.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Dr.sarah',
                          style: GoogleFonts.notoSans(
                            textStyle:  TextStyle(
                              fontSize: 27.sp,
                              color: Colors.black54,
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
                              AppStrings.digitalNoteLabel.tr,
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                AppStrings.digitalNoteSub.tr,
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 14.sp,
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
                        text: AppStrings.sendToPatient.tr,
                        onTap: () {},
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