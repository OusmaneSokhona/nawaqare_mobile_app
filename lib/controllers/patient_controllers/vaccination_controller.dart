import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/api_urls.dart';
import 'package:patient_app/services/api_service.dart';

class VaccinationRecord {
  final String id;
  final String vaccineName;
  final DateTime dateGiven;
  final int doseNumber;
  final int totalDoses;
  final DateTime? nextDueDate;
  final String status; // SCHEDULED, COMPLETED, OVERDUE
  final String? administeredBy;

  VaccinationRecord({
    required this.id,
    required this.vaccineName,
    required this.dateGiven,
    required this.doseNumber,
    required this.totalDoses,
    this.nextDueDate,
    required this.status,
    this.administeredBy,
  });

  factory VaccinationRecord.fromJson(Map<String, dynamic> json) {
    return VaccinationRecord(
      id: json['id'] ?? '',
      vaccineName: json['vaccine_name'] ?? '',
      dateGiven: DateTime.parse(json['date_given'] ?? DateTime.now().toIso8601String()),
      doseNumber: json['dose_number'] ?? 1,
      totalDoses: json['total_doses'] ?? 1,
      nextDueDate: json['next_due'] != null ? DateTime.parse(json['next_due']) : null,
      status: json['status'] ?? 'COMPLETED',
      administeredBy: json['administered_by'],
    );
  }

  /// Check if reminder is due soon (within 30 days)
  bool get isReminderDue {
    if (nextDueDate == null) return false;
    final now = DateTime.now();
    final daysUntilDue = nextDueDate!.difference(now).inDays;
    return daysUntilDue >= 0 && daysUntilDue <= 30;
  }

  /// Check if vaccination is overdue
  bool get isOverdue => status == 'OVERDUE';

  /// Check if vaccination is completed
  bool get isCompleted => status == 'COMPLETED';

  /// Check if vaccination is scheduled
  bool get isScheduled => status == 'SCHEDULED';
}

class VaccinationController extends GetxController {
  final ApiService apiService = ApiService();

  // Observables
  RxBool isLoading = false.obs;
  RxBool isRefreshing = false.obs;
  RxString errorMessage = ''.obs;
  RxList<VaccinationRecord> allVaccinations = <VaccinationRecord>[].obs;
  RxList<VaccinationRecord> completedVaccinations = <VaccinationRecord>[].obs;
  RxList<VaccinationRecord> upcomingVaccinations = <VaccinationRecord>[].obs;
  RxString activeTab = 'My Vaccines'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVaccinations();
  }

  /// Fetch vaccinations from backend
  Future<void> fetchVaccinations() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final String baseUrl = ApiUrls.nestBaseUrl;
      final String patientId = 'current_patient_id'; // Replace with actual patient ID from auth

      final String url = '$baseUrl${ApiUrls.patientVaccinationsUrl}$patientId/records/vaccinations';

      final response = await apiService.dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? response.data;
        final vaccinations = data.map((json) => VaccinationRecord.fromJson(json)).toList();

        // Sort by date given (most recent first)
        vaccinations.sort((a, b) => b.dateGiven.compareTo(a.dateGiven));

        allVaccinations.value = vaccinations;

        // Categorize vaccinations
        completedVaccinations.value =
            vaccinations.where((v) => v.isCompleted).toList();
        upcomingVaccinations.value =
            vaccinations.where((v) => v.isScheduled || v.isOverdue).toList();
      } else {
        errorMessage.value = 'Failed to load vaccinations';
      }
    } on DioException catch (e) {
      errorMessage.value = e.message ?? 'Network error';
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh vaccinations (pull to refresh)
  Future<void> refreshVaccinations() async {
    try {
      isRefreshing.value = true;
      await fetchVaccinations();
    } finally {
      isRefreshing.value = false;
    }
  }

  /// Switch between tabs
  void switchTab(String tabName) {
    activeTab.value = tabName;
  }

  /// Download vaccination certificate (mock implementation)
  Future<void> downloadCertificate(String vaccinationId) async {
    try {
      Get.snackbar(
        'Download',
        'Generating vaccination certificate...',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      // TODO: Implement actual certificate download when API is ready
      await Future.delayed(const Duration(seconds: 1));

      Get.snackbar(
        'Success',
        'Certificate downloaded successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to download certificate',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  /// Get status color for vaccination
  String getStatusColor(String status) {
    switch (status) {
      case 'COMPLETED':
        return '#27AE60'; // Green
      case 'SCHEDULED':
        return '#F2994A'; // Orange
      case 'OVERDUE':
        return '#EB4824'; // Red
      default:
        return '#828282'; // Grey
    }
  }

  /// Get status label
  String getStatusLabel(String status) {
    switch (status) {
      case 'COMPLETED':
        return 'Completed';
      case 'SCHEDULED':
        return 'Scheduled';
      case 'OVERDUE':
        return 'Overdue';
      default:
        return 'Unknown';
    }
  }
}

// Import colors for the controller
import 'package:patient_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
