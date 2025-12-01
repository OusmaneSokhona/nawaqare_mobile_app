import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_profile_controller.dart';
import 'package:patient_app/screens/doctor_screens/profile_screens/my_services_screen.dart';
import '../../../screens/patient_screens/profile_screens/privacy_security.dart';
import '../../../screens/patient_screens/profile_screens/update_password.dart';
import '../../patient_widgets/profile_widgets/health_space_card.dart';
import '../../patient_widgets/profile_widgets/language_dialogs.dart';

class DoctorHealthSpaceGrid extends StatelessWidget {
  final DoctorProfileController profileController;
  const DoctorHealthSpaceGrid({super.key,required this.profileController});

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
          title: 'My Services',
          onTap: () {
            profileController.handleHealthSpaceTap(MyServicesScreen());
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
          icon: Icons.update,
          title: 'Update Password',
          onTap: () {
            profileController.handleHealthSpaceTap(UpdatePassword());
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