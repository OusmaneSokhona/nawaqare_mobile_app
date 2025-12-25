import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/pharmacy_screens/pharmacy_edit_legal_information.dart';
import 'package:patient_app/widgets/patient_widgets/profile_widgets/health_space_card.dart';
import 'package:patient_app/widgets/pharmacy_widgets/pharmacy_health_space_grid.dart';
import 'package:patient_app/utils/app_strings.dart';

import '../../../controllers/patient_controllers/profile_controller.dart';
import '../../utils/app_fonts.dart';
import '../../widgets/patient_widgets/profile_widgets/info_row.dart';


class LegalInformation extends StatelessWidget{
  LegalInformation({super.key});
  ProfileController controller=Get.put(ProfileController());
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
                Get.to(PharmacyEditLegalInformation());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child:  Text(AppStrings.editLegalInfo.tr, style: TextStyle(fontSize: 14.sp)),
            ),
          ),
          const SizedBox(height: 30),
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
                InfoRow(label: AppStrings.licenseNumber.tr, value: "LIC-20493"),
                InfoRow(label: AppStrings.issuingAuthority.tr, value: 'Punjab Pharmacy Council'),
                InfoRow(label: AppStrings.issueDate.tr, value:"15/Oct/2023"),
                InfoRow(label: AppStrings.expiryDate.tr, value: "15/Oct/2023"),
                InfoRow(label: AppStrings.businessRegNo.tr, value: 'BRN-99821'),
                InfoRow(label: AppStrings.registeredName.tr, value: "Alex Martin Healthcare (Pvt) Ltd",showDivider: false,),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(12.sp),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9C4).withOpacity(0.8),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFFFF59D), width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/images/alert_icon.png", height: 35.sp),
                12.horizontalSpace,
                Expanded(
                  child: Text(
                    AppStrings.licenseExpiryWarning.tr,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D3142),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildDigitalSignatureCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.digitalSignatureCert.tr,
          style: TextStyle(
            fontSize: 21.sp,
            fontWeight: FontWeight.w700,
            fontFamily: AppFonts.jakartaBold,
            color:  const Color(0xFF2D3142),
          ),
        ),
        16.verticalSpace,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color:  const Color(0xFFE8E8E8),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          AppStrings.dragSelectFile.tr,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppFonts.jakartaBold,
                            color: const Color(0xFF2D3142),
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.edit_outlined,
                            color: Colors.blue,
                            size: 22.sp,
                          ),
                        ),
                        8.horizontalSpace,
                        InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                            size: 22.sp,
                          ),
                        ),
                      ],
                    ),
                    4.verticalSpace,
                    Row(
                      children: [
                        Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 16.sp,
                        ),
                        4.horizontalSpace,
                        Text(
                          AppStrings.verified.tr,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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