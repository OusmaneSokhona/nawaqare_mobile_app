import 'package:get/get.dart';
import 'package:patient_app/services/api_service.dart';
import 'package:patient_app/utils/api_urls.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../models/patient_model_doctor.dart';

class PatientController extends GetxController {
  final ApiService _apiService = ApiService();

  RxString selectedCategory = AppStrings.overview.tr.obs;
  RxInt currentPage = 1.obs;
  final int itemsPerPage = 10;

  RxList<PatientAppointmentModel> allAppointments = <PatientAppointmentModel>[].obs;
  RxList<PatientSummary> patientSummaries = <PatientSummary>[].obs;
  RxBool isLoading = false.obs;
  RxString searchQuery = ''.obs;

  RxString selectedStatus = AppStrings.all.tr.obs;
  List<String> statusOptions = [
    AppStrings.all.tr,
    AppStrings.pending.tr,
    AppStrings.confirmed.tr,
    "ongoing",
    AppStrings.completed.tr,
    AppStrings.cancelled.tr,
  ];

  @override
  void onInit() {
    super.onInit();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    try {
      isLoading.value = true;
      final response = await _apiService.get(ApiUrls.getAllPatients);

      if (response.statusCode == 200) {
        print("Response data: ${response.data}");
        final appointmentsResponse = AppointmentsResponse.fromJson(response.data);
        allAppointments.value = appointmentsResponse.appointments;
        createPatientSummaries();
        print("Total appointments: ${allAppointments.length}");
        print("Total patients: ${patientSummaries.length}");
      }
    } catch (e) {
      print("Error fetching patients: $e");
      Get.snackbar(
        'Error',
        'Failed to fetch appointments: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void createPatientSummaries() {
    final Map<String, List<PatientAppointmentModel>> appointmentsByPatient = {};

    // Group appointments by patient ID
    for (final appointment in allAppointments) {
      if (!appointmentsByPatient.containsKey(appointment.patientId)) {
        appointmentsByPatient[appointment.patientId] = [];
      }
      appointmentsByPatient[appointment.patientId]!.add(appointment);
    }

    final List<PatientSummary> summaries = [];

    // Create summary for each patient
    appointmentsByPatient.forEach((patientId, appointments) {
      // Sort appointments by date (most recent first)
      appointments.sort((a, b) => b.date.compareTo(a.date));

      // Get patient info from the first appointment
      final patient = appointments.first.patient;

      // Calculate total spent
      double totalSpent = 0;
      for (final app in appointments) {
        if (app.status == 'completed' || app.status == 'confirmed') {
          totalSpent += app.fee;
        }
      }

      summaries.add(PatientSummary(
        patientId: patientId,
        fullName: patient?.fullName ?? 'Unknown Patient',
        email: patient?.email ?? '',
        lastAppointmentDate: appointments.first.date,
        lastConsultationType: appointments.first.consultationType,
        totalAppointments: appointments.length,
        totalSpent: totalSpent,
        imageUrl: patient?.profileImage ?? '',
      ));
    });

    // Sort summaries by last appointment date (most recent first)
    summaries.sort((a, b) {
      if (a.lastAppointmentDate == null) return 1;
      if (b.lastAppointmentDate == null) return -1;
      return b.lastAppointmentDate!.compareTo(a.lastAppointmentDate!);
    });

    patientSummaries.assignAll(summaries);
  }

  List<PatientSummary> get filteredPatients {
    // First filter by status
    List<PatientSummary> statusFiltered;

    if (selectedStatus.value == AppStrings.all.tr) {
      statusFiltered = patientSummaries;
    } else {
      final statusMap = {
        AppStrings.pending.tr: 'pending',
        AppStrings.confirmed.tr: 'confirmed',
        "ongoing": 'ongoing',
        AppStrings.completed.tr: 'completed',
        AppStrings.cancelled.tr: 'cancelled',
      };

      final statusValue = statusMap[selectedStatus.value];

      final patientIdsWithStatus = allAppointments
          .where((app) => app.status == statusValue)
          .map((app) => app.patientId)
          .toSet();

      statusFiltered = patientSummaries
          .where((patient) => patientIdsWithStatus.contains(patient.patientId))
          .toList();
    }

    // Then filter by search query
    if (searchQuery.value.isEmpty) {
      return statusFiltered;
    }

    return statusFiltered.where((patient) {
      final query = searchQuery.value.toLowerCase();
      return patient.fullName.toLowerCase().contains(query) ||
          patient.email.toLowerCase().contains(query);
    }).toList();
  }

  List<PatientSummary> get paginatedPatients {
    final filtered = filteredPatients;
    int start = (currentPage.value - 1) * itemsPerPage;
    int end = start + itemsPerPage;

    if (start >= filtered.length) return [];
    return filtered.sublist(
      start,
      end > filtered.length ? filtered.length : end,
    );
  }

  int get totalPages => (filteredPatients.length / itemsPerPage).ceil();

  int get totalFilteredCount => filteredPatients.length;

  void refreshData() => fetchPatients();

  void setSearchQuery(String query) {
    searchQuery.value = query;
    currentPage.value = 1; // Reset to first page on search
  }

  void setStatusFilter(String status) {
    selectedStatus.value = status;
    currentPage.value = 1; // Reset to first page on filter change
  }

  void nextPage() {
    if (currentPage.value < totalPages) {
      currentPage.value++;
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
    }
  }
}