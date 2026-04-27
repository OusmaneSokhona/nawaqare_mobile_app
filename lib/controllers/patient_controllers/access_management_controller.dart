import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/api_urls.dart';
import 'package:patient_app/services/api_service.dart';

class ConsentData {
  final String type;
  final bool isGranted;
  final DateTime? grantedDate;
  final DateTime? expiryDate;

  ConsentData({
    required this.type,
    required this.isGranted,
    this.grantedDate,
    this.expiryDate,
  });

  factory ConsentData.fromJson(Map<String, dynamic> json) {
    return ConsentData(
      type: json['type'] ?? '',
      isGranted: json['is_granted'] ?? false,
      grantedDate: json['granted_date'] != null ? DateTime.parse(json['granted_date']) : null,
      expiryDate: json['expiry_date'] != null ? DateTime.parse(json['expiry_date']) : null,
    );
  }
}

class AuthorizedActor {
  final String id;
  final String name;
  final String type; // DOCTOR, PHARMACY, HOSPITAL, etc.
  final String? institution;
  final DateTime authorizedDate;
  final List<String> permissions; // MEDICAL_DATA, PRESCRIPTIONS, etc.

  AuthorizedActor({
    required this.id,
    required this.name,
    required this.type,
    this.institution,
    required this.authorizedDate,
    required this.permissions,
  });

  factory AuthorizedActor.fromJson(Map<String, dynamic> json) {
    return AuthorizedActor(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      institution: json['institution'],
      authorizedDate: DateTime.parse(json['authorized_date'] ?? DateTime.now().toIso8601String()),
      permissions: List<String>.from(json['permissions'] ?? []),
    );
  }
}

class AccessLog {
  final String id;
  final String actorName;
  final String actorType;
  final DateTime accessDate;
  final String action; // VIEW, DOWNLOAD, etc.
  final List<String> dataAccessed;

  AccessLog({
    required this.id,
    required this.actorName,
    required this.actorType,
    required this.accessDate,
    required this.action,
    required this.dataAccessed,
  });

  factory AccessLog.fromJson(Map<String, dynamic> json) {
    return AccessLog(
      id: json['id'] ?? '',
      actorName: json['actor_name'] ?? '',
      actorType: json['actor_type'] ?? '',
      accessDate: DateTime.parse(json['access_date'] ?? DateTime.now().toIso8601String()),
      action: json['action'] ?? '',
      dataAccessed: List<String>.from(json['data_accessed'] ?? []),
    );
  }
}

class AccessManagementController extends GetxController {
  final ApiService apiService = ApiService();

  // Observables
  RxBool isLoading = false.obs;
  RxBool isRefreshing = false.obs;
  RxString errorMessage = ''.obs;

  // Consent data
  RxBool medicalDataConsent = false.obs;
  Rx<DateTime?> consentGrantedDate = Rx<DateTime?>(null);
  RxList<ConsentData> allConsents = <ConsentData>[].obs;

  // Authorized actors
  RxList<AuthorizedActor> authorizedActors = <AuthorizedActor>[].obs;

  // Access history
  RxList<AccessLog> accessHistory = <AccessLog>[].obs;

  // Notification preferences
  RxBool notifyOnAccess = true.obs;
  RxBool notifyOnConsent = true.obs;
  RxBool notifyOnRevokedAccess = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllAccessData();
  }

  /// Fetch all access control data from backend
  Future<void> fetchAllAccessData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final String baseUrl = ApiUrls.nestBaseUrl;

      // Fetch consents
      await _fetchConsents(baseUrl);

      // Fetch authorized actors
      await _fetchAuthorizedActors(baseUrl);

      // Fetch access history
      await _fetchAccessHistory(baseUrl);
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch consent data
  Future<void> _fetchConsents(String baseUrl) async {
    try {
      final url = '$baseUrl${ApiUrls.accessControlUrl}/consents';
      final response = await apiService.dio.get(url);

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        if (data is List) {
          allConsents.value = data.map((c) => ConsentData.fromJson(c)).toList();

          // Set medical data consent
          final medicalConsent = allConsents.firstWhere(
            (c) => c.type == 'MEDICAL_DATA',
            orElse: () => ConsentData(type: '', isGranted: false),
          );

          medicalDataConsent.value = medicalConsent.isGranted;
          consentGrantedDate.value = medicalConsent.grantedDate;
        }
      }
    } on DioException catch (e) {
      print('Error fetching consents: ${e.message}');
    }
  }

  /// Fetch authorized actors
  Future<void> _fetchAuthorizedActors(String baseUrl) async {
    try {
      final url = '$baseUrl${ApiUrls.accessControlUrl}/authorized';
      final response = await apiService.dio.get(url);

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        if (data is List) {
          authorizedActors.value = data.map((a) => AuthorizedActor.fromJson(a)).toList();
        }
      }
    } on DioException catch (e) {
      print('Error fetching authorized actors: ${e.message}');
    }
  }

  /// Fetch access history
  Future<void> _fetchAccessHistory(String baseUrl) async {
    try {
      final url = '$baseUrl${ApiUrls.accessControlUrl}/history';
      final response = await apiService.dio.get(url);

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        if (data is List) {
          accessHistory.value = data.map((h) => AccessLog.fromJson(h)).toList();
          // Sort by access date descending
          accessHistory.sort((a, b) => b.accessDate.compareTo(a.accessDate));
        }
      }
    } on DioException catch (e) {
      print('Error fetching access history: ${e.message}');
    }
  }

  /// Refresh access data
  Future<void> refreshAccessData() async {
    try {
      isRefreshing.value = true;
      await fetchAllAccessData();
    } finally {
      isRefreshing.value = false;
    }
  }

  /// Toggle medical data consent
  Future<void> toggleMedicalDataConsent() async {
    try {
      final String baseUrl = ApiUrls.nestBaseUrl;
      final url = '$baseUrl${ApiUrls.accessControlUrl}/consents/MEDICAL_DATA';

      final newValue = !medicalDataConsent.value;

      final response = await apiService.dio.put(
        url,
        data: {
          'is_granted': newValue,
        },
      );

      if (response.statusCode == 200) {
        medicalDataConsent.value = newValue;
        consentGrantedDate.value = DateTime.now();

        Get.snackbar(
          'Success',
          newValue ? 'Medical data access granted' : 'Medical data access revoked',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        await fetchAllAccessData();
      }
    } on DioException catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update consent: ${e.message}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  /// Revoke access for an actor
  Future<void> revokeActorAccess(String actorId) async {
    try {
      final String baseUrl = ApiUrls.nestBaseUrl;
      final url = '$baseUrl${ApiUrls.accessControlUrl}/authorized/$actorId';

      final response = await apiService.dio.delete(url);

      if (response.statusCode == 200) {
        authorizedActors.removeWhere((a) => a.id == actorId);

        Get.snackbar(
          'Success',
          'Access revoked successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        await fetchAllAccessData();
      }
    } on DioException catch (e) {
      Get.snackbar(
        'Error',
        'Failed to revoke access: ${e.message}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  /// Update notification preferences
  Future<void> updateNotificationPreference(String preferenceType, bool value) async {
    try {
      switch (preferenceType) {
        case 'access':
          notifyOnAccess.value = value;
          break;
        case 'consent':
          notifyOnConsent.value = value;
          break;
        case 'revoked':
          notifyOnRevokedAccess.value = value;
          break;
      }

      // TODO: Send preference update to backend when API is ready
      Get.snackbar(
        'Updated',
        'Notification preference updated',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update preference',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  /// Get actor type icon
  String getActorTypeIcon(String type) {
    switch (type) {
      case 'DOCTOR':
        return '👨‍⚕️';
      case 'PHARMACY':
        return '💊';
      case 'HOSPITAL':
        return '🏥';
      case 'LAB':
        return '🔬';
      default:
        return '👤';
    }
  }

  /// Get actor type label
  String getActorTypeLabel(String type) {
    switch (type) {
      case 'DOCTOR':
        return 'Doctor';
      case 'PHARMACY':
        return 'Pharmacy';
      case 'HOSPITAL':
        return 'Hospital';
      case 'LAB':
        return 'Laboratory';
      default:
        return 'Other';
    }
  }
}

import 'package:flutter/material.dart';
