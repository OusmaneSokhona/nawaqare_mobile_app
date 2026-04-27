import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/pharmacy_controllers/pharmacy_dispensing_controller.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';

class PharmacyDispensingScreen extends StatelessWidget {
  final String prescriptionId;

  PharmacyDispensingScreen({
    super.key,
    required this.prescriptionId,
  });

  final PharmacyDispensingController controller = Get.put(
    PharmacyDispensingController(),
  );

  @override
  Widget build(BuildContext context) {
    // Charge les détails de la prescription au montage
    controller.loadPrescriptionDetail(prescriptionId);

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
        child: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
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
                        // Header clair d'accès
                        _buildAccessHeader(),
                        20.verticalSpace,
                        // Titre
                        Text(
                          'Délivrance de Prescription',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 23.sp,
                            fontWeight: FontWeight.w800,
                            fontFamily: AppFonts.jakartaBold,
                          ),
                        ),
                        10.verticalSpace,
                        // Info patient
                        _buildPatientInfo(),
                        20.verticalSpace,
                        // Section Alertes de sécurité
                        if ((controller.prescriptionDetail.value?.allergies ?? []).isNotEmpty)
                          _buildSafetyAlerts(),
                        20.verticalSpace,
                        // Lignes de prescription
                        _buildPrescriptionLines(),
                        20.verticalSpace,
                        // Bouton principal
                        _buildConfirmButton(),
                        15.verticalSpace,
                        // Bouton rejet
                        _buildRejectButton(),
                        20.verticalSpace,
                        // Footer
                        _buildFooter(),
                        30.verticalSpace,
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildAccessHeader() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.sp),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Access scope: Prescriptions only',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGrey,
            ),
          ),
          5.verticalSpace,
          Text(
            'Consent: Granted | Source: NawaQare',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.lightGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientInfo() {
    final prescription = controller.prescriptionDetail.value;
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informations Patient',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          10.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildInfoRow('Patient:', prescription?.patientName ?? '-'),
              ),
              Expanded(
                child: _buildInfoRow('ID:', prescription?.patientId ?? '-'),
              ),
            ],
          ),
          8.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildInfoRow('Prescripteur:', prescription?.doctorName ?? '-'),
              ),
              Expanded(
                child: _buildInfoRow(
                  'Date:',
                  prescription?.prescriptionDate.toString().split(' ')[0] ?? '-',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.lightGrey,
          ),
        ),
        3.verticalSpace,
        Text(
          value,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildSafetyAlerts() {
    final allergies = controller.prescriptionDetail.value?.allergies ?? [];
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(10.sp),
        border: Border.all(color: Colors.red.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning, color: Colors.red, size: 20.sp),
              8.horizontalSpace,
              Text(
                'Alertes de Sécurité',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          10.verticalSpace,
          ...allergies.map((allergy) => Padding(
            padding: EdgeInsets.only(bottom: 5.h),
            child: Text(
              '• Allergie: $allergy',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.red.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildPrescriptionLines() {
    final lines = controller.prescriptionDetail.value?.lines ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lignes de Prescription (${lines.length})',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        12.verticalSpace,
        ...lines.asMap().entries.map((entry) {
          int index = entry.key;
          PrescriptionLine line = entry.value;
          return _buildPrescriptionLineCard(index, line);
        }),
      ],
    );
  }

  Widget _buildPrescriptionLineCard(int index, PrescriptionLine line) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.sp),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec nom et dosage
          Text(
            line.drugName,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          5.verticalSpace,
          Text(
            'DCI: ${line.dci} | Dosage: ${line.dosage} | Fréquence: ${line.frequency}',
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.lightGrey,
            ),
          ),
          10.verticalSpace,
          Divider(color: Colors.grey.shade300),
          10.verticalSpace,
          // Quantité prescrite et à livrer
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quantité prescrite:',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.lightGrey,
                      ),
                    ),
                    3.verticalSpace,
                    Text(
                      '${line.quantityPrescribed}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quantité à livrer:',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.lightGrey,
                      ),
                    ),
                    3.verticalSpace,
                    SizedBox(
                      height: 36.h,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '0',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.sp),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                        ),
                        onChanged: (value) {
                          line.quantityToDeliver = int.tryParse(value) ?? 0;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          12.verticalSpace,
          // Statut de délivrance
          Row(
            children: [
              Expanded(
                child: _buildDeliveryStatusButton(
                  'Livrer',
                  line.deliveryStatus == 'deliver',
                  () {
                    line.deliveryStatus = 'deliver';
                  },
                ),
              ),
              8.horizontalSpace,
              Expanded(
                child: _buildDeliveryStatusButton(
                  'Partielle',
                  line.deliveryStatus == 'partial',
                  () {
                    line.deliveryStatus = 'partial';
                  },
                ),
              ),
              8.horizontalSpace,
              Expanded(
                child: _buildDeliveryStatusButton(
                  'Non dispo',
                  line.deliveryStatus == 'not_available',
                  () {
                    line.deliveryStatus = 'not_available';
                  },
                ),
              ),
            ],
          ),
          10.verticalSpace,
          // Champ notes pharmaciste
          TextField(
            decoration: InputDecoration(
              hintText: 'Notes du pharmacien (optionnel)',
              hintStyle: TextStyle(fontSize: 11.sp, color: AppColors.lightGrey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.sp),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 8.h,
              ),
            ),
            maxLines: 2,
            onChanged: (value) {
              line.pharmacistNotes = value;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryStatusButton(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(6.sp),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.darkGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Obx(
      () => SizedBox(
        width: 1.sw,
        height: 50.h,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.sp),
            ),
          ),
          onPressed: controller.isSaving.value
              ? null
              : () => _showConfirmDispensingDialog(),
          child: controller.isSaving.value
              ? SizedBox(
                  height: 20.h,
                  width: 20.h,
                  child: const CircularProgressIndicator(color: Colors.white),
                )
              : Text(
                  'Confirmer la Délivrance',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildRejectButton() {
    return SizedBox(
      width: 1.sw,
      height: 50.h,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.sp),
          ),
        ),
        onPressed: () => _showRejectDialog(),
        child: Text(
          'Rejeter la Prescription',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.red,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8.sp),
      ),
      child: Text(
        'Pharmacies only access prescriptions and safety alerts required for dispensing. Medical diagnoses and notes are not accessible.',
        style: TextStyle(
          fontSize: 11.sp,
          color: AppColors.lightGrey,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  void _showConfirmDispensingDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Confirmer la Délivrance',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Cette action sera enregistrée dans le dossier médical national.',
          style: TextStyle(fontSize: 13.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Annuler', style: TextStyle(color: AppColors.lightGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            onPressed: () async {
              final success = await controller.confirmDispensingComplete(prescriptionId);
              if (success) {
                Get.back(); // Fermer le dialog
                Get.back(); // Retourner à l'écran précédent
              }
            },
            child: const Text(
              'Confirmer',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Rejeter la Prescription',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Raison du rejet (obligatoire):',
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
            ),
            10.verticalSpace,
            TextField(
              controller: controller.reasonController,
              decoration: InputDecoration(
                hintText: 'Entrez la raison...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.sp),
                ),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Annuler', style: TextStyle(color: AppColors.lightGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
            ),
            onPressed: () async {
              if (controller.reasonController.text.isEmpty) {
                Get.snackbar(
                  'Erreur',
                  'Veuillez entrer une raison',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }

              final success = await controller.rejectPrescription(
                prescriptionId,
                controller.reasonController.text,
              );

              if (success) {
                Get.back(); // Fermer le dialog
                Get.back(); // Retourner à l'écran précédent
              }
            },
            child: const Text(
              'Rejeter',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
