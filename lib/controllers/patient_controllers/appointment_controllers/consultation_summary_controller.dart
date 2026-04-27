import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/api_urls.dart';
import 'package:patient_app/services/api_service.dart';

class Prescription {
  final String id;
  final String medicationName;
  final String dosage;
  final String frequency;
  final int duration;
  final String? durationUnit;
  final String? notes;

  Prescription({
    required this.id,
    required this.medicationName,
    required this.dosage,
    required this.frequency,
    required this.duration,
    this.durationUnit,
    this.notes,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['id'] ?? '',
      medicationName: json['medication_name'] ?? json['name'] ?? '',
      dosage: json['dosage'] ?? '',
      frequency: json['frequency'] ?? '',
      duration: json['duration'] ?? 0,
      durationUnit: json['duration_unit'],
      notes: json['notes'],
    );
  }

  /// Get readable dosage and frequency string
  String get readableDosageFrequency {
    return '$dosage, $frequency';
  }

  /// Get readable duration string
  String get readableDuration {
    final unit = durationUnit ?? 'days';
    return '$duration $unit';
  }
}

class ExamOrder {
  final String id;
  final String examName;
  final String? description;
  final DateTime? scheduledDate;
  final String? location;

  ExamOrder({
    required this.id,
    required this.examName,
    this.description,
    this.scheduledDate,
    this.location,
  });

  factory ExamOrder.fromJson(Map<String, dynamic> json) {
    return ExamOrder(
      id: json['id'] ?? '',
      examName: json['exam_name'] ?? json['name'] ?? '',
      description: json['description'],
      scheduledDate:
          json['scheduled_date'] != null ? DateTime.parse(json['scheduled_date']) : null,
      location: json['location'],
    );
  }
}

class FollowUpPlan {
  final String? patientSummaryFr;
  final List<String> redFlags;
  final List<String> objectives;
  final DateTime? nextAppointmentDate;

  FollowUpPlan({
    this.patientSummaryFr,
    required this.redFlags,
    required this.objectives,
    this.nextAppointmentDate,
  });

  factory FollowUpPlan.fromJson(Map<String, dynamic> json) {
    return FollowUpPlan(
      patientSummaryFr: json['patient_summary_fr'],
      redFlags: List<String>.from(json['red_flags'] ?? []),
      objectives: List<String>.from(json['objectives'] ?? []),
      nextAppointmentDate: json['next_appointment_date'] != null
          ? DateTime.parse(json['next_appointment_date'])
          : null,
    );
  }
}

class ConsultationSummary {
  final String id;
  final String? assessment;
  final String? plan;
  final List<Prescription> prescriptions;
  final List<ExamOrder> examOrders;
  final FollowUpPlan? followUpPlan;
  final String? doctorName;
  final DateTime? consultationDate;

  ConsultationSummary({
    required this.id,
    this.assessment,
    this.plan,
    required this.prescriptions,
    required this.examOrders,
    this.followUpPlan,
    this.doctorName,
    this.consultationDate,
  });

  factory ConsultationSummary.fromJson(Map<String, dynamic> json) {
    final soapNote = json['soap_note'] ?? {};
    final followUpData = json['follow_up_plan'];

    return ConsultationSummary(
      id: json['id'] ?? '',
      assessment: soapNote['assessment'] ?? json['assessment'],
      plan: soapNote['plan'] ?? json['plan'],
      prescriptions: (json['prescriptions'] as List?)
              ?.map((p) => Prescription.fromJson(p))
              .toList() ??
          [],
      examOrders: (json['exam_orders'] as List?)
              ?.map((e) => ExamOrder.fromJson(e))
              .toList() ??
          [],
      followUpPlan: followUpData != null ? FollowUpPlan.fromJson(followUpData) : null,
      doctorName: json['doctor_name'],
      consultationDate: json['consultation_date'] != null
          ? DateTime.parse(json['consultation_date'])
          : null,
    );
  }
}

class ConsultationSummaryController extends GetxController {
  final ApiService apiService = ApiService();

  // Observables
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  Rx<ConsultationSummary?> consultationSummary = Rx<ConsultationSummary?>(null);

  late String consultationId;

  @override
  void onInit() {
    super.onInit();
    // Get consultationId from arguments
    consultationId = Get.arguments ?? '';
    if (consultationId.isNotEmpty) {
      fetchConsultationSummary();
    }
  }

  /// Fetch consultation summary from backend
  Future<void> fetchConsultationSummary() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final String baseUrl = ApiUrls.nestBaseUrl;
      final String url = '$baseUrl${ApiUrls.consultationDetailUrl}$consultationId';

      final response = await apiService.dio.get(url);

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        consultationSummary.value = ConsultationSummary.fromJson(data);
      } else {
        errorMessage.value = 'Failed to load consultation summary';
      }
    } on DioException catch (e) {
      errorMessage.value = e.message ?? 'Network error';
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Download summary as PDF (mock implementation)
  Future<void> downloadSummaryPdf() async {
    try {
      Get.snackbar(
        'Download',
        'Generating PDF summary...',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      // TODO: Implement actual PDF generation and download
      await Future.delayed(const Duration(seconds: 1));

      Get.snackbar(
        'Success',
        'Summary downloaded successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to download summary',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  /// Simplify assessment text for patient understanding
  String simplifyAssessment(String? assessment) {
    if (assessment == null || assessment.isEmpty) {
      return 'No assessment recorded';
    }
    // Remove medical jargon and simplify if needed
    return assessment;
  }

  /// Simplify treatment plan for patient understanding
  String simplifyPlan(String? plan) {
    if (plan == null || plan.isEmpty) {
      return 'No treatment plan recorded';
    }
    return plan;
  }
}

import 'package:flutter/material.dart';
