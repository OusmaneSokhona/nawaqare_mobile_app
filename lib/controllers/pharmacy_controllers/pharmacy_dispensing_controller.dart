import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/client/api_client.dart';
import 'package:patient_app/utils/nest_api_urls.dart';

/// Model pour une ligne de prescription
class PrescriptionLine {
  final String id;
  final String drugName;
  final String dci;
  final String dosage;
  final String frequency;
  final int quantityPrescribed;
  int quantityToDeliver;
  String deliveryStatus; // 'deliver', 'partial', 'not_available'
  String? pharmacistNotes;

  PrescriptionLine({
    required this.id,
    required this.drugName,
    required this.dci,
    required this.dosage,
    required this.frequency,
    required this.quantityPrescribed,
    this.quantityToDeliver = 0,
    this.deliveryStatus = 'deliver',
    this.pharmacistNotes,
  });

  factory PrescriptionLine.fromJson(Map<String, dynamic> json) {
    return PrescriptionLine(
      id: json['id']?.toString() ?? '',
      drugName: json['drugName']?.toString() ?? '',
      dci: json['dci']?.toString() ?? '',
      dosage: json['dosage']?.toString() ?? '',
      frequency: json['frequency']?.toString() ?? '',
      quantityPrescribed: json['quantityPrescribed'] as int? ?? 0,
      quantityToDeliver: json['quantityDelivered'] as int? ?? 0,
    );
  }
}

/// Model pour une prescription complète
class PharmacyPrescriptionDetail {
  final String id;
  final String patientId;
  final String patientName;
  final String doctorName;
  final DateTime prescriptionDate;
  final List<PrescriptionLine> lines;
  final List<String>? allergies;
  final String? status;

  PharmacyPrescriptionDetail({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.doctorName,
    required this.prescriptionDate,
    required this.lines,
    this.allergies,
    this.status,
  });

  factory PharmacyPrescriptionDetail.fromJson(Map<String, dynamic> json) {
    return PharmacyPrescriptionDetail(
      id: json['id']?.toString() ?? '',
      patientId: json['patientId']?.toString() ?? '',
      patientName: json['patientName']?.toString() ?? '',
      doctorName: json['doctorName']?.toString() ?? '',
      prescriptionDate: DateTime.parse(json['prescriptionDate']?.toString() ?? DateTime.now().toString()),
      lines: (json['prescriptionLines'] as List?)
          ?.map((line) => PrescriptionLine.fromJson(line as Map<String, dynamic>))
          .toList() ?? [],
      allergies: (json['allergies'] as List?)?.cast<String>(),
      status: json['status']?.toString(),
    );
  }
}

class PharmacyDispensingController extends GetxController {
  final ApiClient apiClient = ApiClient();
  final TextEditingController reasonController = TextEditingController();

  final Rx<PharmacyPrescriptionDetail?> prescriptionDetail = Rx<PharmacyPrescriptionDetail?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxString errorMessage = ''.obs;

  /// Charge les détails d'une prescription
  Future<void> loadPrescriptionDetail(String prescriptionId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiClient.dio.get(
        NestApiUrls.baseUrl + NestApiUrls.getPharmacyPrescriptionDetail(prescriptionId),
      );

      if (response.statusCode == 200) {
        prescriptionDetail.value = PharmacyPrescriptionDetail.fromJson(response.data);
      }
    } on DioException catch (e) {
      errorMessage.value = e.message ?? 'Erreur lors du chargement';
    } catch (e) {
      errorMessage.value = 'Erreur: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Complète la délivrance d'une prescription
  Future<bool> confirmDispensingComplete(String prescriptionId) async {
    try {
      isSaving.value = true;
      errorMessage.value = '';

      final lines = prescriptionDetail.value?.lines ?? [];
      final lineData = lines.map((line) {
        return {
          'prescriptionLineId': line.id,
          'quantityDelivered': line.quantityToDeliver,
          if (line.pharmacistNotes != null && line.pharmacistNotes!.isNotEmpty)
            'pharmacistNotes': line.pharmacistNotes,
        };
      }).toList();

      final response = await apiClient.dio.post(
        NestApiUrls.baseUrl + NestApiUrls.dispensePrescription(prescriptionId),
        data: {'lines': lineData},
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Succès',
          'Prescription livrée avec succès',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      }
      return false;
    } on DioException catch (e) {
      errorMessage.value = e.message ?? 'Erreur lors de la sauvegarde';
      Get.snackbar(
        'Erreur',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } catch (e) {
      errorMessage.value = 'Erreur: ${e.toString()}';
      Get.snackbar(
        'Erreur',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  /// Délivrance partielle d'une prescription
  Future<bool> confirmPartialDispensingComplete(String prescriptionId) async {
    try {
      isSaving.value = true;
      errorMessage.value = '';

      final lines = prescriptionDetail.value?.lines ?? [];
      final lineData = lines.where((line) => line.quantityToDeliver > 0).map((line) {
        return {
          'prescriptionLineId': line.id,
          'quantityDelivered': line.quantityToDeliver,
          if (line.pharmacistNotes != null && line.pharmacistNotes!.isNotEmpty)
            'pharmacistNotes': line.pharmacistNotes,
        };
      }).toList();

      final response = await apiClient.dio.post(
        NestApiUrls.baseUrl + NestApiUrls.partiallyDispensePrescription(prescriptionId),
        data: {'lines': lineData},
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Succès',
          'Délivrance partielle enregistrée',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      }
      return false;
    } on DioException catch (e) {
      errorMessage.value = e.message ?? 'Erreur lors de la sauvegarde';
      Get.snackbar(
        'Erreur',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  /// Rejette une prescription
  Future<bool> rejectPrescription(String prescriptionId, String reason) async {
    try {
      isSaving.value = true;
      errorMessage.value = '';

      final response = await apiClient.dio.post(
        NestApiUrls.baseUrl + NestApiUrls.rejectPrescription(prescriptionId),
        data: {'reason': reason},
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Succès',
          'Prescription rejetée',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      }
      return false;
    } on DioException catch (e) {
      errorMessage.value = e.message ?? 'Erreur lors du rejet';
      Get.snackbar(
        'Erreur',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  /// Effectue une substitution de médicament
  Future<bool> applySubstitution(
    String prescriptionId,
    String originalLineId,
    String substitutedDrugName,
    String substitutedDci,
    bool patientConsented,
  ) async {
    try {
      isSaving.value = true;
      errorMessage.value = '';

      final response = await apiClient.dio.post(
        NestApiUrls.baseUrl + NestApiUrls.substitutePrescription(prescriptionId),
        data: {
          'originalLineId': originalLineId,
          'substitutedDrugName': substitutedDrugName,
          'substitutedDci': substitutedDci,
          'patientConsented': patientConsented,
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Succès',
          'Substitution appliquée avec succès',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Recharger la prescription pour voir les changements
        await loadPrescriptionDetail(prescriptionId);
        return true;
      }
      return false;
    } on DioException catch (e) {
      errorMessage.value = e.message ?? 'Erreur lors de la substitution';
      Get.snackbar(
        'Erreur',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }
}
