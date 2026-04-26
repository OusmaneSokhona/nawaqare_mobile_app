import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/pharmacy_screens/pharmacy_access_log_screen.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/patient_widgets/profile_widgets/delete_account_dialog.dart';
import '../../../controllers/patient_controllers/profile_controller.dart';
import '../../../screens/auth_screens/sign_in_screen.dart';
import '../../../screens/patient_screens/profile_screens/privacy_security.dart';
import '../../../screens/patient_screens/profile_screens/update_password.dart';
import '../../../utils/app_bindings.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/locat_storage.dart';
import '../patient_widgets/profile_widgets/health_space_card.dart';
import '../patient_widgets/profile_widgets/language_dialogs.dart';

class PharmacyHealthSpaceGrid extends StatelessWidget {
  final ProfileController profileController;
  const PharmacyHealthSpaceGrid({super.key, required this.profileController});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 2,
      crossAxisSpacing: 16.w,
      mainAxisSpacing: 16.h,
      childAspectRatio: 1.9,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        HealthSpaceCard(
          icon: "assets/images/allergies_icon.png",
          title: AppStrings.accessLog.tr,
          onTap: () => Get.to(() => const PharmacyAccessLogScreen()),
        ),
        HealthSpaceCard(
          icon: "assets/images/privacy_security_icon.png",
          title: AppStrings.privacySecurity.tr,
          onTap: () => profileController.handleHealthSpaceTap(PrivacySecurity()),
        ),
        HealthSpaceCard(
          icon: "assets/images/update_password_icon.png",
          title: AppStrings.updatePassword.tr,
          onTap: () => profileController.handleHealthSpaceTap(UpdatePassword()),
        ),
        HealthSpaceCard(
          icon: "assets/images/language_icon.png",
          title: AppStrings.changeLanguage.tr,
          onTap: () => Get.dialog( LanguageDialog()),
        ),
        HealthSpaceCard(
          icon: "assets/images/log_out_icon.png",
          title: AppStrings.logout.tr,
          color: AppColors.red,
          textColor: AppColors.red,
          onTap: () => _handleLogout(),
        ),
        HealthSpaceCard(
          icon: "assets/images/delete_account_icon.png",
          title: AppStrings.deleteAccount.tr,
          color: AppColors.red,
          textColor: AppColors.red,
          onTap: () => Get.dialog(DeleteAccountDialog()), // Assuming same logic for now
        ),
      ],
    );
  }

  Future<void> _handleLogout() async {
    await Get.deleteAll(force: true);
    LocalStorageUtils.deleteUser();
    Get.offAll(() => SignInScreen(), binding: AppBinding());
  }
}