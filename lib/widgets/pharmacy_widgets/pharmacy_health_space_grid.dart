import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/patient_screens/profile_screens/consultation_screen.dart';
import '../../../controllers/patient_controllers/profile_controller.dart';
import '../../../screens/auth_screens/sign_in_screen.dart';
import '../../../screens/patient_screens/profile_screens/allergies_screen.dart';
import '../../../screens/patient_screens/profile_screens/blood_type.dart';
import '../../../screens/patient_screens/profile_screens/medical_history.dart';
import '../../../screens/patient_screens/profile_screens/privacy_security.dart';
import '../../../screens/patient_screens/profile_screens/update_password.dart';
import '../../../utils/app_bindings.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/shared_prefrence.dart';
import '../patient_widgets/profile_widgets/health_space_card.dart';
import '../patient_widgets/profile_widgets/language_dialogs.dart';
class PharmacyHealthSpaceGrid extends StatelessWidget {
  final ProfileController profileController;
  const PharmacyHealthSpaceGrid({super.key,required this.profileController});

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
          icon: "assets/images/allergies_icon.png",
          title: 'Access Log',
          onTap: () {},
        ),
        HealthSpaceCard(
          icon: "assets/images/privacy_security_icon.png",
          title: 'Privacy & Security',
          onTap: () {profileController.handleHealthSpaceTap(PrivacySecurity());},
        ),
        HealthSpaceCard(
          icon: "assets/images/update_password_icon.png",
          title: 'Update Password',
          onTap: () {
            profileController.handleHealthSpaceTap(UpdatePassword());
          },
        ),
        HealthSpaceCard(
          icon: "assets/images/language_icon.png",
          title: 'Change Language',
          onTap: (){
            Get.dialog(LanguageDialog());
          },
        ),

        HealthSpaceCard(
          icon: "assets/images/log_out_icon.png",
          title: 'Log Out',
          color: AppColors.red,
          textColor: AppColors.red,
          onTap: (){
            LocalStorageUtils.deleteUser();
            Get.offAll(SignInScreen(),binding: AppBinding());
          },
        ),
        HealthSpaceCard(
          icon: "assets/images/delete_account_icon.png",
          title: 'Delete Account',
          color: AppColors.red,
          textColor: AppColors.red,
          onTap: (){
            LocalStorageUtils.deleteUser();
            Get.offAll(SignInScreen(),binding: AppBinding());
          },
        ),
      ],
    );
  }
}