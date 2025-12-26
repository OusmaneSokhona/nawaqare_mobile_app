import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_profile_controller.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/doctor_widgets/profile_widgets/doctor_health_space_grid.dart';
import 'package:patient_app/widgets/doctor_widgets/profile_widgets/document_item_widget.dart';
import 'package:patient_app/widgets/doctor_widgets/profile_widgets/profile_completion_loading.dart';

class DoctorDocuments extends StatelessWidget {
  DoctorDocuments({super.key});

  final DoctorProfileController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: ClipOval(
              child: Image.asset(
                controller.user.value.profileImageUrl,
                width: 100.w,
                height: 100.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              controller.user.value.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
          Center(
            child: Text(
              '${AppStrings.lastUpdate.tr}: ${controller.user.value.lastUpdate}',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 52.w),
            child: ElevatedButton(
              onPressed: (){
                controller.editDocumentsInfo();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                AppStrings.reuploadExpiredDocument.tr,
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ),
          10.verticalSpace,
          const ProfileCompletionLoading(),
          15.verticalSpace,
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                DocumentItemWidget(
                  documentName: AppStrings.nationalIdentityDocument.tr,
                  documentStatus: AppStrings.uploadedStatus.tr,
                ),
                15.verticalSpace,
                DocumentItemWidget(
                  documentName: AppStrings.medicalDiploma.tr,
                  documentStatus: AppStrings.pendingReviewStatus.tr,
                ),
                15.verticalSpace,
                DocumentItemWidget(
                  documentName: AppStrings.registrationCertificate.tr,
                  documentStatus: AppStrings.uploadedStatus.tr,
                ),
                15.verticalSpace,
                DocumentItemWidget(
                  documentName: AppStrings.professionalPhoto.tr,
                  documentStatus: AppStrings.rejectedStatus.tr,
                ),
                15.verticalSpace,
                DocumentItemWidget(
                  documentName: AppStrings.liabilityInsuranceProof.tr,
                  documentStatus: AppStrings.expiredStatus.tr,
                ),
                15.verticalSpace,
                DocumentItemWidget(
                  documentName: AppStrings.bankDetailsProof.tr,
                  documentStatus: AppStrings.uploadedStatus.tr,
                  showDivider: false,
                ),
                7.verticalSpace,
                Container(
                  padding:  EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: AppColors.orange.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child:  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(
                        Icons.error_outline,
                        color: AppColors.orange,
                        size: 24,
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Text(
                          AppStrings.encryptionBanner.tr,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: const Color(0xFF333333),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Text(
            AppStrings.actions.tr,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 10.h),
          DoctorHealthSpaceGrid(profileController: controller),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}