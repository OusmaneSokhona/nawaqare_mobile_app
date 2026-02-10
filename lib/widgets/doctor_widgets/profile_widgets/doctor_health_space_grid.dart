import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_profile_controller.dart';
import 'package:patient_app/screens/auth_screens/web_sign_in_screen.dart';
import 'package:patient_app/screens/doctor_screens/profile_screens/my_services_screen.dart';
import 'package:patient_app/screens/doctor_screens/time_slot_screen.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../../main.dart';
import '../../../screens/auth_screens/sign_in_screen.dart';
import '../../../screens/patient_screens/profile_screens/privacy_security.dart';
import '../../../screens/patient_screens/profile_screens/update_password.dart';
import '../../../utils/app_bindings.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/locat_storage.dart';
import '../../patient_widgets/profile_widgets/delete_account_dialog.dart';
import '../../patient_widgets/profile_widgets/health_space_card.dart';
import '../../patient_widgets/profile_widgets/language_dialogs.dart';

class DoctorHealthSpaceGrid extends StatelessWidget {
  final DoctorProfileController profileController;
  const DoctorHealthSpaceGrid({super.key, required this.profileController});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.9,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        HealthSpaceCard(
          icon: "assets/images/my_services_icon.png",
          title: AppStrings.myServices.tr,
          onTap: () {
            profileController.handleHealthSpaceTap(MyServicesScreen());
          },
        ),
        HealthSpaceCard(
          icon: "assets/images/privacy_security_icon.png",
          title: AppStrings.privacySecurity.tr,
          onTap: () {
            profileController.handleHealthSpaceTap(PrivacySecurity());
          },
        ),
        HealthSpaceCard(
          icon: "assets/images/update_password_icon.png",
          title: AppStrings.updatePassword.tr,
          onTap: () {
            profileController.handleHealthSpaceTap(UpdatePassword());
          },
        ),
        HealthSpaceCard(
          icon: "assets/images/language_icon.png",
          title: AppStrings.changeLanguage.tr,
          onTap: () {
            Get.dialog(LanguageDialog());
          },
        ),
        HealthSpaceCard(
          icon: "assets/images/calender_icon.png",
          title: AppStrings.calendar.tr,
          onTap: () {
            Get.to(TimeSlotScreen());
          },
        ),
        HealthSpaceCard(
          icon: "assets/images/log_out_icon.png",
          title: AppStrings.logout.tr,
          color: AppColors.red,
          textColor: AppColors.red,
          onTap: () {
            LocalStorageUtils.deleteUser();
            isWeb?Get.offAll(WebSignInScreen(), binding: AppBinding()):
            Get.offAll(SignInScreen(), binding: AppBinding());
          },
        ),
        HealthSpaceCard(
          icon: "assets/images/delete_account_icon.png",
          title: AppStrings.deleteAccount.tr,
          onTap: () {
            Get.dialog(DeleteAccountDialog());
          },
          color: AppColors.red,
          textColor: AppColors.red,
        ),
      ],
    );
  }
}