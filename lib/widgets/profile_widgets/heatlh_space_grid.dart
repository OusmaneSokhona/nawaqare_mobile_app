import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/profile_screens/allergies_screen.dart';
import 'package:patient_app/screens/profile_screens/blood_type.dart';
import 'package:patient_app/screens/profile_screens/medical_history.dart';
import 'package:patient_app/screens/profile_screens/privacy_security.dart';
import 'package:patient_app/screens/profile_screens/update_password.dart';
import 'package:patient_app/widgets/profile_widgets/language_dialogs.dart';

import '../../controllers/profile_controller.dart';
import 'health_space_card.dart';
class HeatlhSpaceGrid extends StatelessWidget {
  final ProfileController profileController;
  const HeatlhSpaceGrid({super.key,required this.profileController});

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
          icon: Icons.waving_hand,
          title: 'Allergies',
          onTap: () {profileController.handleHealthSpaceTap(AllergiesScreen());},
        ),
        HealthSpaceCard(
          icon: Icons.medical_services_outlined,
          title: 'Medical History',
          onTap: () {profileController.handleHealthSpaceTap(MedicalHistory());},
        ),
        HealthSpaceCard(
          icon: Icons.update,
          title: 'Update Password',
          onTap: () {
            profileController.handleHealthSpaceTap(UpdatePassword());
          },
        ),
        HealthSpaceCard(
          icon: Icons.water_drop_outlined,
          title: 'Blood Type',
          onTap: () {
            profileController.handleHealthSpaceTap(BloodType());
          },
        ),
        HealthSpaceCard(
          icon: Icons.security,
          title: 'Privacy & Security',
          onTap: () {
            profileController.handleHealthSpaceTap(PrivacySecurity());
          },
        ),
        HealthSpaceCard(
          icon: Icons.translate,
          title: 'Change Language',
          onTap: (){
            Get.dialog(LanguageDialog());
          },
        ),
      ],
    );
  }
}