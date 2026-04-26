import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/utils/app_strings.dart';

import '../../../controllers/patient_controllers/appointment_controllers/setting_controller.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final String label;
  final List<String> options;
  final String currentValue;
  final ValueChanged<String?> onChanged;
  final Widget? trailing;
  final Widget? leading;

  const CustomDropdown({
    required this.label,
    required this.options,
    required this.currentValue,
    required this.onChanged,
    this.trailing,
    this.leading,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w500, color: Colors.black87)),
            if (trailing != null) trailing!,
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonFormField<String>(
            value: currentValue,
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: InputBorder.none,
              prefixIcon: leading != null ? Padding(
                padding: const EdgeInsets.only(left: 10),
                child: leading,
              ) : null,
              prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            ),
            icon:  Icon(Icons.keyboard_arrow_down, color: AppColors.lightGrey),
            onChanged: onChanged,
            items: options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: const TextStyle(fontSize: 14)),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}

class AudioVideoSection extends StatelessWidget {
  final SettingsController controller;
  const AudioVideoSection({required this.controller, super.key});

  Widget _buildMicLevelVisualizer() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(10, (index){
        return Padding(
          padding:  EdgeInsets.only(right: 3.w),
          child: Container(
            width: 5.w,
            height: 14.h,
            decoration: BoxDecoration(
              color:  index<5?AppColors.primaryColor:AppColors.lightGrey.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: AppStrings.audioVideoSetup.tr),
        CustomDropdown(
          label: AppStrings.microphone.tr,
          options: controller.microphoneOptions,
          currentValue: controller.microphoneValue.value,
          onChanged: controller.updateMicrophone,
          trailing: _buildMicLevelVisualizer(),
        ),
        CustomDropdown(
          label: AppStrings.speakers.tr,
          options: controller.speakerOptions,
          currentValue: controller.speakerValue.value,
          onChanged: controller.updateSpeaker,
          trailing: TextButton(
            onPressed: () {},
            child: Text(AppStrings.testSpeakers.tr, style: const TextStyle(color: Color(0xFF4285F4), fontSize: 13)),
          ),
        ),
        CustomDropdown(
          label: AppStrings.camera.tr,
          options: controller.cameraOptions,
          currentValue: controller.cameraValue.value,
          onChanged: controller.updateCamera,
          trailing: Text(AppStrings.cameraOff.tr, style: const TextStyle(color: Colors.black54, fontSize: 13)),
        ),
        CustomDropdown(
          label: AppStrings.captionsLanguage.tr,
          options: controller.captionLanguageOptions,
          currentValue: controller.captionLanguageValue.value,
          onChanged: controller.updateCaptionLanguage,
        ),
      ],
    );
  }
}

class ConnectionHealthSection extends StatelessWidget {
  final SettingsController controller;
  const ConnectionHealthSection({required this.controller, super.key});

  Widget _buildMetricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15, color: Colors.black87)),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: AppStrings.connectionHealth.tr),
        Container(
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.sp),
            color: Colors.white,
            border: Border.all(color: AppColors.lightGrey.withOpacity(0.3)),
          ),
          child: Obx(
                ()=> Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMetricRow(AppStrings.bandwidth.tr, controller.bandwidth.value),
                _buildMetricRow(AppStrings.latency.tr, controller.latency.value),
                _buildMetricRow(AppStrings.connectionQuality.tr, controller.connectionQuality.value),
                const SizedBox(height: 15),
                CustomButton(borderRadius: 15, text: AppStrings.runNetworkTest.tr, onTap: controller.runNetworkTest),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DevicePermissionsSection extends StatelessWidget {
  final SettingsController controller;
  const DevicePermissionsSection({required this.controller, super.key});

  Widget _buildPermissionRow(String label, bool isGranted) {
    Color color = isGranted ? Colors.green.shade700 : Colors.red.shade700;
    IconData icon = isGranted ? Icons.check_circle : Icons.cancel;
    String status = isGranted ? AppStrings.granted.tr : AppStrings.blocked.tr;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15, color: Colors.black87)),
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(status, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: color)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: AppStrings.devicePermissions.tr),
        Container(
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.sp),
            color: Colors.white,
            border: Border.all(color: AppColors.lightGrey.withOpacity(0.3)),
          ),
          child: Obx(
                ()=> Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                _buildPermissionRow(AppStrings.cameraAccess.tr, controller.isCameraGranted.value),
                _buildPermissionRow(AppStrings.microphoneAccess.tr, controller.isMicrophoneGranted.value),
                const SizedBox(height: 15),
                CustomButton(borderRadius: 15, text: AppStrings.managePermissions.tr, onTap: controller.managePermissions),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class OtherStepsSection extends StatelessWidget {
  const OtherStepsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:  [
        SectionTitle(title: AppStrings.otherStepsTitle.tr),
        Text(AppStrings.otherStepsSub.tr, style: TextStyle(fontSize: 15.sp, color: Colors.black87)),
      ],
    );
  }
}