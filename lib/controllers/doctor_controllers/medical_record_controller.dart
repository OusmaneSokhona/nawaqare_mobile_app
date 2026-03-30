import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../models/patient_detail_doctor_app.dart';
import '../../services/api_service.dart';
import '../../utils/api_urls.dart';

class MedicalRecordController extends GetxController {
  final ApiService _apiService = ApiService();

  var patientMedicalData = Rxn<PatientMedicalData>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> fetchPatientDetails(String patientId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _apiService.get("${ApiUrls.getPatientDetails}$patientId");

      if (response.data['success'] == true) {
        patientMedicalData.value = PatientMedicalData.fromJson(response.data['data']);
      } else {
        errorMessage.value = response.data['message'] ?? 'Failed to fetch patient details';
      }
    } catch (e) {
      print("Error fetching patient details: ${e.toString()}");
      errorMessage.value = 'Error fetching patient details: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  String getFullName() {
    return patientMedicalData.value?.profile.fullName ?? 'N/A';
  }

  String getHeight() {
    return patientMedicalData.value?.profile.vitals['height'] ?? 'N/A';
  }

  String getWeight() {
    return patientMedicalData.value?.profile.vitals['weight'] ?? 'N/A';
  }

  String getBmi() {
    return patientMedicalData.value?.profile.vitals['bmi']?.toString() ?? 'N/A';
  }

  String getBloodPressure() {
    return patientMedicalData.value?.profile.vitals['bp'] ?? 'N/A';
  }

  String getHeartRate() {
    String heartRate = patientMedicalData.value?.profile.vitals['heartRate'] ?? '';
    return heartRate.isEmpty ? 'N/A' : heartRate;
  }

  String getAllergyName() {
    return patientMedicalData.value?.latestAllergy?.allergenName ?? 'No allergies recorded';
  }

  String getAllergyReaction() {
    return patientMedicalData.value?.latestAllergy?.reaction ?? 'N/A';
  }

  String getAllergySeverity() {
    return patientMedicalData.value?.latestAllergy?.severity ?? 'N/A';
  }

  String getAllergyDateIdentified() {
    if (patientMedicalData.value?.latestAllergy?.dateIdentified != null) {
      return _formatDate(patientMedicalData.value!.latestAllergy!.dateIdentified);
    }
    return 'N/A';
  }

  String getDiagnosis() {
    return patientMedicalData.value?.latestAppointment?.prescriptionDetails?.diagnosis ?? 'No diagnosis available';
  }

  String getDiagnosisNotes() {
    return patientMedicalData.value?.latestAppointment?.notes ?? 'No notes available';
  }

  List<Medication> getMedications() {
    return patientMedicalData.value?.latestAppointment?.prescriptionDetails?.medications ?? [];
  }

  String getPrescriptionNumber() {
    return patientMedicalData.value?.latestAppointment?.prescriptionDetails?.prescriptionNumber ?? 'N/A';
  }

  String getPrescriptionNotes() {
    return patientMedicalData.value?.latestAppointment?.prescriptionDetails?.notes ?? 'No notes';
  }

  String getFollowUpDate() {
    if (patientMedicalData.value?.latestAppointment?.followUp?.scheduledDate != null) {
      return _formatDateTime(patientMedicalData.value!.latestAppointment!.followUp!.scheduledDate);
    }
    return 'No follow-up scheduled';
  }

  String getFollowUpPrice() {
    if (patientMedicalData.value?.latestAppointment?.followUp?.followupPrice != null) {
      return '${patientMedicalData.value!.latestAppointment!.followUp!.followupPrice} PKR';
    }
    return 'N/A';
  }

  String getFollowUpPaymentStatus() {
    return patientMedicalData.value?.latestAppointment?.followUp?.paymentStatus ?? 'N/A';
  }

  String getLastReportUrl() {
    if (patientMedicalData.value?.reports.isNotEmpty == true) {
      return patientMedicalData.value!.reports.last;
    }
    return '';
  }

  bool hasReports() {
    return patientMedicalData.value?.reports.isNotEmpty == true;
  }

  List<String> getAllReports() {
    return patientMedicalData.value?.reports ?? [];
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatDateTime(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}