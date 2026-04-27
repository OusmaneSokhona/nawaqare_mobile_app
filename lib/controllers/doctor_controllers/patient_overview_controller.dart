import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/api_service.dart';
import '../../../utils/nest_api_urls.dart';

class VitalSigns {
  double? weight; // kg
  double? height; // cm
  int? systolic; // mmHg
  int? diastolic; // mmHg
  int? heartRate; // bpm
  double? temperature; // Celsius
  double? oxygenSaturation; // %

  VitalSigns({
    this.weight,
    this.height,
    this.systolic,
    this.diastolic,
    this.heartRate,
    this.temperature,
    this.oxygenSaturation,
  });

  factory VitalSigns.fromJson(Map<String, dynamic> json) {
    return VitalSigns(
      weight: json['weight']?.toDouble(),
      height: json['height']?.toDouble(),
      systolic: json['systolic'],
      diastolic: json['diastolic'],
      heartRate: json['heartRate'],
      temperature: json['temperature']?.toDouble(),
      oxygenSaturation: json['oxygenSaturation']?.toDouble(),
    );
  }
}

class PatientEvent {
  String type; // CONSULTATION, EMERGENCY, LAB_RESULT, PRESCRIPTION
  String description;
  DateTime date;

  PatientEvent({
    required this.type,
    required this.description,
    required this.date,
  });

  factory PatientEvent.fromJson(Map<String, dynamic> json) {
    return PatientEvent(
      type: json['type'] ?? 'CONSULTATION',
      description: json['description'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
    );
  }
}

class CareTeamMember {
  String name;
  String specialty;
  String role; // PRIMARY, SPECIALIST, SUPPORTING

  CareTeamMember({
    required this.name,
    required this.specialty,
    required this.role,
  });

  factory CareTeamMember.fromJson(Map<String, dynamic> json) {
    return CareTeamMember(
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      role: json['role'] ?? 'PRIMARY',
    );
  }
}

class PatientOverviewData {
  List<String> allergies;
  List<String> currentMedications;
  VitalSigns? vitalSigns;
  List<PatientEvent> lastEvents;
  List<CareTeamMember> consultingDoctors;
  String accessLevel; // Full, Read-only, Emergency
  String accessSource; // Direct, Request, Emergency

  PatientOverviewData({
    required this.allergies,
    required this.currentMedications,
    this.vitalSigns,
    required this.lastEvents,
    required this.consultingDoctors,
    required this.accessLevel,
    required this.accessSource,
  });

  factory PatientOverviewData.fromJson(Map<String, dynamic> json) {
    return PatientOverviewData(
      allergies: List<String>.from(json['allergies'] ?? []),
      currentMedications: List<String>.from(json['currentMedications'] ?? []),
      vitalSigns: json['vitalSigns'] != null ? VitalSigns.fromJson(json['vitalSigns']) : null,
      lastEvents: (json['lastEvents'] as List<dynamic>?)?.map((e) => PatientEvent.fromJson(e)).toList() ?? [],
      consultingDoctors: (json['consultingDoctors'] as List<dynamic>?)?.map((e) => CareTeamMember.fromJson(e)).toList() ?? [],
      accessLevel: json['accessLevel'] ?? 'Full',
      accessSource: json['accessSource'] ?? 'Direct',
    );
  }
}

class PatientOverviewController extends GetxController {
  final ApiService _apiService = ApiService();

  // Data
  final patientOverview = Rx<PatientOverviewData?>(null);
  final isLoading = false.obs;
  final isRequestingAccess = false.obs;
  final errorMessage = ''.obs;
  final accessJustification = TextEditingController();
  final String patientId;

  PatientOverviewController({required this.patientId});

  @override
  void onInit() {
    super.onInit();
    fetchPatientOverview();
  }

  @override
  void onClose() {
    accessJustification.dispose();
    super.onClose();
  }

  /// Fetch patient overview from backend
  Future<void> fetchPatientOverview() async {
    isLoading.value = true;
    try {
      final url = NestApiUrls.getPatientOverview(patientId);
      final response = await _apiService.get(url);

      if (response.statusCode == 200) {
        patientOverview.value = PatientOverviewData.fromJson(response.data);
      }
    } catch (e) {
      print('Fetch patient overview error: $e');
      errorMessage.value = 'Failed to load patient overview';
    } finally {
      isLoading.value = false;
    }
  }

  /// Request access to patient records
  Future<bool> requestAccess() async {
    if (accessJustification.text.trim().isEmpty) {
      errorMessage.value = 'Please provide justification for access';
      return false;
    }

    isRequestingAccess.value = true;
    try {
      // API call to request access
      // POST /api/v1/patients/{patientId}/access-request
      final response = await _apiService.post(
        '${NestApiUrls.apiVersion}/patients/$patientId/access-request',
        data: {
          'justification': accessJustification.text.trim(),
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          "Success",
          "Access request sent to patient",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        accessJustification.clear();
        return true;
      } else {
        errorMessage.value = response.data['message'] ?? 'Failed to request access';
        Get.snackbar("Error", errorMessage.value, backgroundColor: Colors.red);
        return false;
      }
    } catch (e) {
      print('Request access error: $e');
      errorMessage.value = 'An error occurred: $e';
      Get.snackbar("Error", errorMessage.value, backgroundColor: Colors.red);
      return false;
    } finally {
      isRequestingAccess.value = false;
    }
  }

  /// Request emergency access with justification
  Future<bool> requestEmergencyAccess(String justification) async {
    if (justification.trim().isEmpty) {
      errorMessage.value = 'Please provide justification for emergency access';
      return false;
    }

    isRequestingAccess.value = true;
    try {
      // API call to request emergency access
      // POST /api/v1/patients/{patientId}/emergency-access
      final response = await _apiService.post(
        '${NestApiUrls.apiVersion}/patients/$patientId/emergency-access',
        data: {
          'justification': justification.trim(),
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Refresh overview to reflect emergency access
        await fetchPatientOverview();

        Get.snackbar(
          "Success",
          "Emergency access granted",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        return true;
      } else {
        errorMessage.value = response.data['message'] ?? 'Failed to grant emergency access';
        Get.snackbar("Error", errorMessage.value, backgroundColor: Colors.red);
        return false;
      }
    } catch (e) {
      print('Emergency access error: $e');
      errorMessage.value = 'An error occurred: $e';
      Get.snackbar("Error", errorMessage.value, backgroundColor: Colors.red);
      return false;
    } finally {
      isRequestingAccess.value = false;
    }
  }

  /// Get access level badge color
  Color getAccessLevelColor(String accessLevel) {
    switch (accessLevel) {
      case 'Full':
        return const Color(0xFF27AE60); // Green
      case 'Read-only':
        return const Color(0xFFF2994A); // Orange
      case 'Emergency':
        return const Color(0xFFEB4824); // Red
      default:
        return const Color(0xFF828282); // Grey
    }
  }

  /// Get access level badge text
  String getAccessLevelText(String accessLevel) {
    switch (accessLevel) {
      case 'Full':
        return 'Full Access';
      case 'Read-only':
        return 'Read-Only Access';
      case 'Emergency':
        return 'Emergency Access';
      default:
        return accessLevel;
    }
  }

  /// Get event type icon
  IconData getEventIcon(String type) {
    switch (type) {
      case 'CONSULTATION':
        return Icons.calendar_today;
      case 'EMERGENCY':
        return Icons.emergency;
      case 'LAB_RESULT':
        return Icons.science;
      case 'PRESCRIPTION':
        return Icons.medication;
      default:
        return Icons.info;
    }
  }
}
