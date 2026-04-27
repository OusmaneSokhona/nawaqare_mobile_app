import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/pharmacy_controllers/pharmacy_dispensing_controller.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';

class SubstitutionScreen extends StatefulWidget {
  final String prescriptionId;
  final PrescriptionLine originalLine;

  const SubstitutionScreen({
    super.key,
    required this.prescriptionId,
    required this.originalLine,
  });

  @override
  State<SubstitutionScreen> createState() => _SubstitutionScreenState();
}

class _SubstitutionScreenState extends State<SubstitutionScreen> {
  late TextEditingController substitutedDrugController;
  late TextEditingController substitutedDciController;
  bool patientConsented = false;

  final PharmacyDispensingController controller = Get.find();

  @override
  void initState() {
    super.initState();
    substitutedDrugController = TextEditingController();
    substitutedDciController = TextEditingController();
  }

  @override
  void dispose() {
    substitutedDrugController.dispose();
    substitutedDciController.dispose();
    super.dispose();
  }

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
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                70.verticalSpace,
                // Bouton retour
                InkWell(
                  onTap: () => Get.back(),
                  child: Icon(Icons.arrow_back, size: 25.sp),
                ),
                20.verticalSpace,
                // Titre
                Text(
                  'Substitution de Médicament',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 23.sp,
                    fontWeight: FontWeight.w800,
                    fontFamily: AppFonts.jakartaBold,
                  ),
                ),
                10.verticalSpace,
                Text(
                  'Remplacez un médicament par un générique équivalent',
                  style: TextStyle(
                    color: AppColors.lightGrey,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                20.verticalSpace,
                // Cartes d'information
                _buildInfoCard(
                  'Médicament Original',
                  widget.originalLine.drugName,
                  'DCI: ${widget.originalLine.dci}',
                  Colors.blue.shade50,
                ),
                15.verticalSpace,
                // Flèche de substitution
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Column(
                      children: [
                        Icon(
                          Icons.arrow_downward,
                          color: AppColors.primaryColor,
                          size: 28.sp,
                        ),
                        Text(
                          'Substitution',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                15.verticalSpace,
                // Formulaire de substitution
                _buildSubstitutionForm(),
                20.verticalSpace,
                // Checkbox consentement
                _buildConsentCheckbox(),
                30.verticalSpace,
                // Bouton d'application
                _buildApplyButton(),
                20.verticalSpace,
                // Info
                _buildInfoSection(),
                30.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String mainText, String subText, Color bgColor) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10.sp),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.lightGrey,
            ),
          ),
          8.verticalSpace,
          Text(
            mainText,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          5.verticalSpace,
          Text(
            subText,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.lightGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubstitutionForm() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.sp),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormField(
            label: 'Médicament substitué',
            hintText: 'Nom du générique...',
            controller: substitutedDrugController,
          ),
          15.verticalSpace,
          _buildFormField(
            label: 'DCI générique',
            hintText: 'DCI du médicament substitué...',
            controller: substitutedDciController,
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required String hintText,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGrey,
          ),
        ),
        8.verticalSpace,
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 12.sp,
              color: AppColors.lightGrey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.sp),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 12.h,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConsentCheckbox() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(10.sp),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Row(
        children: [
          Checkbox(
            value: patientConsented,
            onChanged: (value) {
              setState(() {
                patientConsented = value ?? false;
              });
            },
            activeColor: AppColors.primaryColor,
          ),
          Expanded(
            child: Text(
              'Le patient a consenti à la substitution',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.amber.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplyButton() {
    return Obx(
      () => SizedBox(
        width: 1.sw,
        height: 50.h,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: patientConsented && substitutedDrugController.text.isNotEmpty
                ? AppColors.primaryColor
                : Colors.grey.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.sp),
            ),
          ),
          onPressed: (!patientConsented || substitutedDrugController.text.isEmpty)
              ? null
              : () => _applySubstitution(),
          child: controller.isSaving.value
              ? SizedBox(
                  height: 20.h,
                  width: 20.h,
                  child: const CircularProgressIndicator(color: Colors.white),
                )
              : Text(
                  'Appliquer la Substitution',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: patientConsented && substitutedDrugController.text.isNotEmpty
                        ? Colors.white
                        : AppColors.lightGrey,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info, color: AppColors.primaryColor, size: 18.sp),
              8.horizontalSpace,
              Text(
                'Information',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          8.verticalSpace,
          Text(
            'La substitution sera visible au patient et au médecin prescripteur. Assurez-vous que le médicament substitué est thérapeutiquement équivalent.',
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.primaryColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _applySubstitution() async {
    if (substitutedDrugController.text.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez entrer le nom du médicament',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (!patientConsented) {
      Get.snackbar(
        'Erreur',
        'Le consentement du patient est obligatoire',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final success = await controller.applySubstitution(
      widget.prescriptionId,
      widget.originalLine.id,
      substitutedDrugController.text,
      substitutedDciController.text,
      patientConsented,
    );

    if (success) {
      Get.back();
    }
  }
}
