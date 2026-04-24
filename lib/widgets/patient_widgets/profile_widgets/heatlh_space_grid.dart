import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/home_controller.dart';
import 'package:patient_app/screens/patient_screens/profile_screens/consultation_screen.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../../controllers/patient_controllers/profile_controller.dart';
import '../../../screens/auth_screens/sign_in_screen.dart';
import '../../../screens/patient_screens/profile_screens/allergies_screen.dart';
import '../../../screens/patient_screens/profile_screens/blood_type.dart';
import '../../../screens/patient_screens/profile_screens/medical_history.dart';
import '../../../screens/patient_screens/profile_screens/privacy_security.dart';
import '../../../screens/patient_screens/profile_screens/update_password.dart';
import '../../../utils/app_bindings.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/locat_storage.dart';
import 'health_space_card.dart';
import 'language_dialogs.dart';

class HeatlhSpaceGrid extends StatelessWidget {
  final ProfileController profileController;
  HomeController homeController = Get.find();
   HeatlhSpaceGrid({super.key, required this.profileController});

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
          title: AppStrings.allergies.tr,
          onTap: () {
            profileController.handleHealthSpaceTap( AllergiesScreen());
          },
        ),
        HealthSpaceCard(
          icon: "assets/images/medical_history_icon.png",
          title: AppStrings.medicalHistory.tr,
          onTap: () {
            profileController.handleHealthSpaceTap( MedicalHistory());
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
          icon: "assets/images/blood_type.png",
          title: AppStrings.bloodType.tr,
          onTap: () {
            profileController.handleHealthSpaceTap( BloodType(blood:homeController.currentUser.value!.patientData!.bloodGroup!,));
          },
        ),
        HealthSpaceCard(
          icon: "assets/images/privacy_security_icon.png",
          title: AppStrings.privacySecurity.tr,
          onTap: () {
            profileController.handleHealthSpaceTap( PrivacySecurity());
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
          icon: "assets/images/consultation_plan_icon.png",
          title: AppStrings.consultationPlan.tr,
          onTap: () {
            profileController.handleHealthSpaceTap( ConsultationScreen());
          },
        ),
        HealthSpaceCard(
          icon: "assets/images/log_out_icon.png",
          title: AppStrings.logOut.tr,
          color: AppColors.red,
          textColor: AppColors.red,
          onTap: () async {
            Get.offAll( SignInScreen(), binding: AppBinding());
            LocalStorageUtils.deleteUser();
             Get.deleteAll(force: true);

          },
        ),
      ],
    );
  }
}