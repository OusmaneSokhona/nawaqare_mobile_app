import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/pharmacy_screens/pharmacy_edit_personal_info.dart';
import 'package:patient_app/screens/pharmacy_screens/pharmacy_payment_setting_screen.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/patient_widgets/profile_widgets/health_space_card.dart';
import 'package:patient_app/widgets/pharmacy_widgets/pharmacy_health_space_grid.dart';

import '../../../controllers/patient_controllers/profile_controller.dart';
import '../../utils/app_fonts.dart';
import '../patient_widgets/profile_widgets/info_row.dart';

class PharmacyPersonalInfo extends StatelessWidget {
  PharmacyPersonalInfo({super.key});
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
          16.verticalSpace,
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
          20.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 88.w),
            child: ElevatedButton(
              onPressed: () => Get.to(() => PharmacyEditPersonalInfo()),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(AppStrings.editPersonalInfo.tr, style: TextStyle(fontSize: 14.sp)),
            ),
          ),
          30.verticalSpace,
          _buildInfoSection(),
          30.verticalSpace,
          _buildDigitalSignatureCard(),
          10.verticalSpace,
          Text(
            AppStrings.securitySettings.tr,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          10.verticalSpace,
          PharmacyHealthSpaceGrid(profileController: controller),
          10.verticalSpace,
          HealthSpaceCard(
            icon: "assets/images/payment_setting_icon.png",
            title: AppStrings.paymentSetting.tr,
            onTap: () => Get.to(() =>  PharmacyPaymentSettingScreen()),
          ),
          10.verticalSpace,
          _buildSecuritySection(),
          20.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
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
          InfoRow(label: AppStrings.fullName.tr, value: controller.user.value.name),
          InfoRow(label: AppStrings.registrationId.tr, value: '#123RT56'),
          InfoRow(label: AppStrings.email.tr, value: controller.user.value.email),
          InfoRow(label: AppStrings.phone.tr, value: controller.user.value.phone),
          InfoRow(label: AppStrings.city.tr, value: 'Lahore'),
          InfoRow(label: AppStrings.areaLocality.tr, value: "Johar Town"),
          InfoRow(label: AppStrings.operatingHours.tr, value: "5pm-10am"),
          InfoRow(
            label: AppStrings.address.tr,
            value: controller.user.value.address.replaceAll('\n', ' '),
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildDigitalSignatureCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.digitalSignatureTitle.tr,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            fontFamily: AppFonts.jakartaBold,
            color: const Color(0xFF2D3142),
          ),
        ),
        16.verticalSpace,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE8E8E8), width: 1.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      AppStrings.digitalSignatureHint.tr,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.jakartaBold,
                        color: const Color(0xFF2D3142),
                      ),
                    ),
                  ),
                  _buildIconAction(Icons.edit_outlined, Colors.blue, () {}),
                  8.horizontalSpace,
                  _buildIconAction(Icons.delete_outline, Colors.redAccent, () {}),
                ],
              ),
              4.verticalSpace,
              Row(
                children: [
                  Icon(Icons.check, color: Colors.green, size: 16.sp),
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
    );
  }

  Widget _buildIconAction(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Icon(icon, color: color, size: 22.sp),
    );
  }

  Widget _buildSecuritySection() {
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
              const ImageIcon(
                AssetImage("assets/images/delete_account_icon.png"),
                color: Colors.blue,
                size: 30,
              ),
              16.horizontalSpace,
              Expanded(
                child: Text(
                  AppStrings.authentication2FA.tr,
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
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD).withOpacity(0.5),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Text(
            AppStrings.anonymizationNote.tr,
            style: TextStyle(
              color: const Color(0xFF1976D2),
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}