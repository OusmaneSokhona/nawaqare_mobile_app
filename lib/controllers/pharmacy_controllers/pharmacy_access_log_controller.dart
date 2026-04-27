import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:patient_app/client/api_client.dart';
import 'package:patient_app/utils/nest_api_urls.dart';

/// Model pour un log d'accès
class AccessLogEntry {
  final String id;
  final String action; // READ, WRITE, EXPORT
  final String resourceType; // Prescription, etc.
  final String resourceId;
  final DateTime createdAt;
  final Map<String, dynamic>? details;

  AccessLogEntry({
    required this.id,
    required this.action,
    required this.resourceType,
    required this.resourceId,
    required this.createdAt,
    this.details,
  });

  factory AccessLogEntry.fromJson(Map<String, dynamic> json) {
    return AccessLogEntry(
      id: json['id']?.toString() ?? '',
      action: json['action']?.toString() ?? '',
      resourceType: json['resource_type']?.toString() ?? '',
      resourceId: json['resource_id']?.toString() ?? '',
      createdAt: DateTime.parse(json['created_at']?.toString() ?? DateTime.now().toString()),
      details: json['details'] as Map<String, dynamic>?,
    );
  }

  /// Retourne l'icône pour l'action
  String get actionIcon {
    switch (action.toUpperCase()) {
      case 'READ':
        return '👁️';
      case 'WRITE':
        return '✏️';
      case 'EXPORT':
        return '⬇️';
      default:
        return '•';
    }
  }

  /// Retourne le label pour l'action
  String get actionLabel {
    switch (action.toUpperCase()) {
      case 'READ':
        return 'Consultation';
      case 'WRITE':
        return 'Modification';
      case 'EXPORT':
        return 'Exportation';
      default:
        return action;
    }
  }
}

class PharmacyAccessLogController extends GetxController {
  final ApiClient apiClient = ApiClient();

  final RxList<AccessLogEntry> accessLogs = <AccessLogEntry>[].obs;
  final RxString selectedFilter = 'all'.obs; // all, dispensing, consultation
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  /// Récupère les logs d'accès
  Future<void> fetchAccessLogs() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiClient.dio.get(
        NestApiUrls.baseUrl + NestApiUrls.getPharmacyAccessLog(),
      );

      if (response.statusCode == 200) {
        final logs = (response.data as List?)
            ?.map((log) => AccessLogEntry.fromJson(log as Map<String, dynamic>))
            .toList() ?? [];

        // Trier par date décroissante
        logs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        accessLogs.value = logs;
      }
    } on DioException catch (e) {
      errorMessage.value = e.message ?? 'Erreur lors du chargement';
    } catch (e) {
      errorMessage.value = 'Erreur: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Applique un filtre sur les logs
  void applyFilter(String filter) {
    selectedFilter.value = filter;
  }

  /// Retourne les logs filtrés
  List<AccessLogEntry> get filteredLogs {
    if (selectedFilter.value == 'all') {
      return accessLogs;
    }

    return accessLogs.where((log) {
      if (selectedFilter.value == 'dispensing') {
        return log.action.toUpperCase() == 'WRITE' &&
            log.resourceType.toUpperCase() == 'PRESCRIPTION';
      } else if (selectedFilter.value == 'consultation') {
        return log.action.toUpperCase() == 'READ';
      }
      return true;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchAccessLogs();
  }
}
