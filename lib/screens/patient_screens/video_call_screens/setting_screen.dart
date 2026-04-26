import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/patient_controllers/appointment_controllers/setting_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_strings.dart'; // Added import
import '../../../widgets/custom_button.dart';
import '../../../widgets/patient_widgets/video_call_widgets/setting widgets.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});

  // Note: It's better to use Get.put in a binding or here if it's the first entry point
  final SettingsController controller = Get.put(SettingsController());

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
                      "assets/images/back_icon.png",
                      height: 22.h,
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    AppStrings.settings.tr, // Localized
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      30.verticalSpace,
                      AudioVideoSection(controller: controller),
                      10.verticalSpace,
                      ConnectionHealthSection(controller: controller),
                      10.verticalSpace,
                      DevicePermissionsSection(controller: controller),
                      10.verticalSpace,
                      Text(
                        'Device Permissions',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      10.verticalSpace,
                      Text(
                        'If You’re Experiencing Call Or Device Issues, Try These Steps:',
                        style: TextStyle(
                          fontSize: 17,
                          color: Color(0xFF3C4043),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      10.verticalSpace,
                      _LinkButton(
                        text: 'Open Troubleshooting Guide',
                        onTap: () {},
                      ),
                      _LinkButton(text: 'Restart Device Test', onTap: () {}),
                      _LinkButton(
                        text: 'Contact Technical Support',
                        onTap: () {},
                      ),
                      10.verticalSpace,
                      // const OtherStepsSection(),
                      // 50.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.lastTested.trParams({
                            'time': '2 ${AppStrings.minutesAgo.tr}',
                          }), // Dynamic localization
                        ),
                      ),
                      20.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.saveSettings.tr, // Localized
                        onTap: () {},
                      ),
                      10.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.restoreDefaults.tr,
                        // Localized
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

class _LinkButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _LinkButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: onTap,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
