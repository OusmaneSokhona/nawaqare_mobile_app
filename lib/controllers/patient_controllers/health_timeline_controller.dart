import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/api_urls.dart';
import 'package:patient_app/services/api_service.dart';

class HealthTimelineEvent {
  final String id;
  final String type; // CONSULTATION, PRESCRIPTION, EXAM_ORDER, VACCINATION
  final DateTime date;
  final String title;
  final String? doctorName;
  final String? structure;
  final Map<String, dynamic> details;

  HealthTimelineEvent({
    required this.id,
    required this.type,
    required this.date,
    required this.title,
    this.doctorName,
    this.structure,
    required this.details,
  });

  factory HealthTimelineEvent.fromJson(Map<String, dynamic> json) {
    return HealthTimelineEvent(
      id: json['id'] ?? '',
      type: json['type'] ?? 'CONSULTATION',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      title: json['title'] ?? '',
      doctorName: json['doctor'],
      structure: json['structure'],
      details: json['details'] ?? {},
    );
  }
}

class HealthTimelineController extends GetxController {
  final ApiService apiService = ApiService();

  // Observables
  RxBool isLoading = false.obs;
  RxBool isRefreshing = false.obs;
  RxString errorMessage = ''.obs;
  RxList<HealthTimelineEvent> timelineEvents = <HealthTimelineEvent>[].obs;
  RxString selectedEventType = 'All'.obs;

  // Filters
  final List<String> eventTypes = ['All', 'CONSULTATION', 'PRESCRIPTION', 'EXAM_ORDER', 'VACCINATION'];
  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchTimelineEvents();
  }

  /// Fetch health timeline events from the backend
  Future<void> fetchTimelineEvents() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final String baseUrl = ApiUrls.nestBaseUrl;
      final String patientId = 'current_patient_id'; // Replace with actual patient ID from auth

      String url = '$baseUrl${ApiUrls.patientTimelineUrl}$patientId/records/timeline';

      // Add query parameters
      final Map<String, dynamic> queryParams = {};
      if (selectedEventType.value != 'All') {
        queryParams['eventType'] = selectedEventType.value;
      }
      if (startDate.value != null) {
        queryParams['startDate'] = startDate.value!.toIso8601String();
      }
      if (endDate.value != null) {
        queryParams['endDate'] = endDate.value!.toIso8601String();
      }

      final response = await apiService.dio.get(
        url,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? response.data;
        final events = data.map((json) => HealthTimelineEvent.fromJson(json)).toList();

        // Sort by date descending (most recent first)
        events.sort((a, b) => b.date.compareTo(a.date));
        timelineEvents.value = events;
      } else {
        errorMessage.value = 'Failed to load timeline';
      }
    } on DioException catch (e) {
      errorMessage.value = e.message ?? 'Network error';
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh timeline events (pull to refresh)
  Future<void> refreshTimeline() async {
    try {
      isRefreshing.value = true;
      await fetchTimelineEvents();
    } finally {
      isRefreshing.value = false;
    }
  }

  /// Filter events by type
  void filterByEventType(String eventType) {
    selectedEventType.value = eventType;
    fetchTimelineEvents();
  }

  /// Filter events by date range
  void filterByDateRange(DateTime start, DateTime end) {
    startDate.value = start;
    endDate.value = end;
    fetchTimelineEvents();
  }

  /// Clear all filters
  void clearFilters() {
    selectedEventType.value = 'All';
    startDate.value = null;
    endDate.value = null;
    fetchTimelineEvents();
  }

  /// Get icon color based on event type
  String getEventColor(String eventType) {
    switch (eventType) {
      case 'CONSULTATION':
        return '#2F80ED'; // Primary blue
      case 'PRESCRIPTION':
        return '#27AE60'; // Green
      case 'EXAM_ORDER':
        return '#F2994A'; // Orange
      case 'VACCINATION':
        return '#EB4824'; // Red
      default:
        return '#828282'; // Grey
    }
  }

  /// Get icon based on event type
  String getEventIcon(String eventType) {
    switch (eventType) {
      case 'CONSULTATION':
        return '👨‍⚕️';
      case 'PRESCRIPTION':
        return '💊';
      case 'EXAM_ORDER':
        return '🔬';
      case 'VACCINATION':
        return '💉';
      default:
        return '📋';
    }
  }
}
