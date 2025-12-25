import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/pharmacy_screens/pharmacy_edit_documents_screen.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/patient_widgets/profile_widgets/health_space_card.dart';
import 'package:patient_app/widgets/pharmacy_widgets/pharmacy_health_space_grid.dart';

import '../../../controllers/patient_controllers/profile_controller.dart';


class PharmacyDocumentScreen extends StatelessWidget{
  PharmacyDocumentScreen({super.key});
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: ClipOval(
              child: Image.asset(
                "assets/images/pharmacy_icon.png",
                width: 100.w,
                height: 100.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              "Alex Martin Pharmacy",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
          Center(
            child: Text(
              '${AppStrings.lastUpdate.tr}: ${controller.user.value.lastUpdate}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 88.w),
            child: ElevatedButton(
              onPressed: (){
                Get.to(PharmacyEditDocumentsScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child:  Text(AppStrings.editDocument.tr, style: TextStyle(fontSize: 14.sp)),
            ),
          ),
          const SizedBox(height: 30),
          buildDocumentVerificationWidget(),
          const SizedBox(height: 30),
          10.verticalSpace,
          Text(
            AppStrings.securitySettings.tr,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 10.h),
          PharmacyHealthSpaceGrid(profileController: controller),
          10.verticalSpace,
          HealthSpaceCard(icon: "assets/images/payment_setting_icon.png", title: AppStrings.paymentSetting.tr, onTap: (){}),
          10.verticalSpace,
          buildSecuritySection(),
          30.verticalSpace,
        ],
      ),
    );
  }

  Widget buildDocumentVerificationWidget() {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDocumentItem(
            title: AppStrings.licenseCertificate.tr,
            date: 'Oct 12, 2025',
            status: AppStrings.underReview.tr,
            statusColor: const Color(0xFFD97706),
            showProgress: true,
            progress: 0.4,
          ),
          const Divider(height: 32, color: Color(0xFFF3F4F6)),
          _buildDocumentItem(
            title: AppStrings.taxClearance.tr,
            date: 'Oct 12, 2025',
            status: AppStrings.validated.tr,
            statusColor: const Color(0xFF166534),
          ),
          const Divider(height: 32, color: Color(0xFFF3F4F6)),
          _buildDocumentItem(
            title: AppStrings.nocCertificate.tr,
            date: 'Oct 12, 2025',
            status: AppStrings.expired.tr,
            statusColor: const Color(0xFFDC2626),
            trailingIcons: true,
          ),
          Divider(
            color: AppColors.lightGrey.withOpacity(0.2),
          ),
          Container(
            padding:  EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(12.sp),
              border: Border.all(color: const Color(0xFFFFEDD5)),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: const Color(0xFFD97706), size: 25.sp),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    AppStrings.hdsStandardNote.tr,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentItem({
    required String title,
    required String date,
    required String status,
    required Color statusColor,
    bool showProgress = false,
    double progress = 0.0,
    bool trailingIcons = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style:  TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            if (trailingIcons)
              Row(
                children: [
                  Icon(Icons.edit_outlined, color:AppColors.primaryColor, size: 20.sp),
                  SizedBox(width: 12.w),
                  Icon(Icons.visibility_outlined, color:AppColors.primaryColor, size: 22.sp),
                ],
              ),
          ],
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
             Icon(Icons.check, color: AppColors.green, size: 16.sp),
            SizedBox(width: 4.w),
            Text(
              '${AppStrings.uploadedOn.tr}: $date',
              style:   TextStyle(
                fontSize: 15.sp,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          status,
          style: TextStyle(
            fontSize: 14.sp,
            color: statusColor,
            decoration: TextDecoration.underline,
            decorationColor: statusColor,
          ),
        ),
        if (showProgress) ...[
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.documentsValidatedProgress.tr,
                style:  TextStyle(fontSize: 13.sp, color: Color(0xFF6B7280)),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style:   TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFDBEAFE),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            ),
          ),
        ],
      ],
    );
  }

  Widget buildSecuritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE8E8E8), width: 1.2),
          ),
          child: Row(
            children: [
              ImageIcon(const AssetImage("assets/images/delete_account_icon.png"), color: Colors.blue, size: 30.sp),
              16.horizontalSpace,
              Expanded(
                child: Text(
                  AppStrings.twoFactorAuth.tr,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2D3142),
                  ),
                ),
              ),
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: true,
                  onChanged: (val) {},
                  activeColor: Colors.white,
                  activeTrackColor: Colors.blue,
                ),
              ),
            ],
          ),
        ),
        12.verticalSpace,
      ],
    );
  }
}