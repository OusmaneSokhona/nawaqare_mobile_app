import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/auth_controllers/sign_up_controller.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_home_controller.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_profile_controller.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/doctor_widgets/profile_widgets/doctor_health_space_grid.dart';
import 'package:patient_app/widgets/doctor_widgets/profile_widgets/document_item_widget.dart';
import 'package:patient_app/widgets/doctor_widgets/profile_widgets/profile_completion_loading.dart';

class DoctorDocuments extends StatelessWidget {
  DoctorDocuments({super.key});
  final DoctorProfileController controller = Get.find();
  final DoctorHomeController homeController = Get.find<DoctorHomeController>();
  final SignUpController signUpController = Get.find<SignUpController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final doctor = homeController.currentUser.value;
      final doctorImage = doctor?.profileImage;
      final doctorTitle = 'Dr. ${doctor?.fullName ?? 'Daniel Lee'}';
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: CircleAvatar(
              radius: 50.h,
              backgroundColor: Colors.white,
              backgroundImage: doctorImage != null && doctorImage.isNotEmpty
                  ? NetworkImage(doctorImage)
                  : const AssetImage("assets/demo_images/home_demo_image.png")
              as ImageProvider,
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  doctorTitle,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2937),
                    fontFamily: AppFonts.jakartaBold,
                  ),
                ),
                5.horizontalSpace,
                Image.asset("assets/images/verified_tick_icon.png", height: 21.sp),
              ],
            ),
          ),
          Center(
            child: Text(
              '${AppStrings.lastUpdate.tr}: 12/Sep/2025',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade500),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 52.w),
            child: ElevatedButton(
              onPressed: controller.editDocumentsInfo,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                5.verticalSpace,
                doctor!.nationalIdentityDocument != null && doctor.nationalIdentityDocument!.isNotEmpty?
                DocumentItemWidget(
                  documentName: AppStrings.nationalIdentityDocument.tr,
                  documentStatus:doctor.nationalIdentityDocument!,
                  onDeleteTap: () async {
                    await signUpController.deleteDoctorDocument("nationalIdentityDocument");
                  },
                ):SizedBox(),
                5.verticalSpace,
                doctor.liabilityInsuranceProof != null && doctor.liabilityInsuranceProof!.isNotEmpty?
                DocumentItemWidget(
                  documentName:AppStrings.liabilityInsuranceProof.tr,
                  documentStatus:doctor.liabilityInsuranceProof!,
                  onDeleteTap: () async {
                    await signUpController.deleteDoctorDocument("liabilityInsuranceProof");
                  },
                ):SizedBox(),
                5.verticalSpace,
                doctor.medicalLicence != null && doctor.medicalLicence!.isNotEmpty?
                DocumentItemWidget(
                  documentName:AppStrings.medicalLicense.tr,
                  documentStatus: doctor.medicalLicence!,
                  onDeleteTap: () async {
                    await signUpController.deleteDoctorDocument("medicalLicence");
                  },
                ):SizedBox(),
                5.verticalSpace,
                doctor.passportOrIdFront != null && doctor.passportOrIdFront!.isNotEmpty?
                DocumentItemWidget(
                  documentName: AppStrings.passportIdFront.tr,
                  documentStatus: doctor.passportOrIdFront!,
                  onDeleteTap: () async {
                    await signUpController.deleteDoctorDocument("passportOrIdFront");
                  },
                ):SizedBox(),
                5.verticalSpace,
                doctor.paymentAuthorization != null && doctor.paymentAuthorization!.isNotEmpty?
                DocumentItemWidget(
                  documentName: AppStrings.paymentAuthorization.tr,
                  documentStatus: doctor.paymentAuthorization!,
                  onDeleteTap: () async {
                    await signUpController.deleteDoctorDocument("paymentAuthorization");
                  },
                ):SizedBox(),
                doctor.cnpd != null && doctor.cnpd!.isNotEmpty?
                    DocumentItemWidget(
                      documentName: AppStrings.cnpdGdprForm.tr,
                      documentStatus: doctor.cnpd!,
                      onDeleteTap: () async {
                        await signUpController.deleteDoctorDocument("cnpd");
                      },
                    ):SizedBox(),
                doctor.certification != null && doctor.certification!.isNotEmpty?
                DocumentItemWidget(
                  documentName: AppStrings.diplomaCertification.tr,
                  documentStatus: doctor.certification!,
                  onDeleteTap: () async {
                    await signUpController.deleteDoctorDocument("certification");
                  },
                ):SizedBox(),
                doctor.bankVerificationLetter!= null && doctor.bankVerificationLetter!.isNotEmpty?
                DocumentItemWidget(
                  documentName: AppStrings.bankVerificationLetter.tr,
                  documentStatus: doctor.bankVerificationLetter!,
                  onDeleteTap: () async {
                    await signUpController.deleteDoctorDocument("bankVerificationLetter");
                  },
                ):SizedBox(),
                7.verticalSpace,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: AppColors.orange.withOpacity(0.3), width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(Icons.error_outline, color: AppColors.orange, size: 24),
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
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
          ),
          SizedBox(height: 10.h),
          DoctorHealthSpaceGrid(profileController: controller),
          const SizedBox(height: 20),
        ],
      );
    });
  }
}