import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/widgets/patient_widgets/profile_widgets/health_space_card.dart';
import 'package:patient_app/widgets/pharmacy_widgets/pharmacy_health_space_grid.dart';

import '../../../controllers/patient_controllers/profile_controller.dart';
import '../../utils/app_fonts.dart';
import '../patient_widgets/profile_widgets/heatlh_space_grid.dart';
import '../patient_widgets/profile_widgets/info_row.dart';


class PharmacyPersonalInfo extends StatelessWidget{
  PharmacyPersonalInfo({super.key});
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
          Center(
            child: Text(
              "Alex Martin Pharmacy",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
          Center(
            child: Text(
              'Last update: ${controller.user.value.lastUpdate}',
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
              onPressed: controller.editPersonalInfo,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child:  Text('Edit Personal Info', style: TextStyle(fontSize: 14.sp)),
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
                InfoRow(label: 'Full Name', value: controller.user.value.name),
                const InfoRow(label: 'Registration ID', value: '#123RT56'),
                InfoRow(label: 'Email', value: controller.user.value.email),
                InfoRow(label: 'Phone', value: controller.user.value.phone),
                const InfoRow(label: 'City', value: 'Lahore'),
                InfoRow(label: 'Area/Locality', value: "Johar Town"),
                InfoRow(label: 'Operating Hour', value: "5pm-10am"),
                InfoRow(label: 'Address', value: controller.user.value.address.replaceAll('\n', ' '),showDivider: false,),
              ],
            ),
          ),
          const SizedBox(height: 30),
          buildDigitalSignatureCard(),
          10.verticalSpace,
          const Text(
            'Security Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 10.h),
          PharmacyHealthSpaceGrid(profileController: controller),
          10.verticalSpace,
          HealthSpaceCard(icon: "assets/images/payment_setting_icon.png", title: "Payment Setting", onTap: (){}),
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
          "Digital Signature Certificate",
          style: TextStyle(
            fontSize: 21.sp,
            fontWeight: FontWeight.w700,
            fontFamily: AppFonts.jakartaBold,
            color:  Color(0xFF2D3142),
          ),
        ),
        16.verticalSpace,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color:  Color(0xFFE8E8E8),
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
                          "Drag or select file (.p12 / .cer)",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppFonts.jakartaBold,
                            color: const Color(0xFF2D3142),
                          ),
                        ),
                        Spacer(),
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
                          "Verified",
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
              ImageIcon(AssetImage("assets/images/delete_account_icon.png"), color: Colors.blue, size: 30.sp),
              16.horizontalSpace,
              Expanded(
                child: Text(
                  "2FA Authentication",
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
            "All patient data is anonymized via PatientID tokens",
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