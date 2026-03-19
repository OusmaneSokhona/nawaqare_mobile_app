import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/models/doctor_prescription_model.dart';
import 'package:patient_app/screens/doctor_screens/prescription_screens/doctor_prescription_detail_screen.dart';
import 'package:patient_app/services/api_service.dart';
import 'package:patient_app/utils/api_urls.dart';
import '../../models/delivery_options_model.dart';
import '../../screens/patient_screens/prescription_screens/refill_staus.dart';

class DoctorPrescriptionController extends GetxController {
  ApiService apiService = ApiService();
  RxString prescriptionType = "activePrescription".obs;

  final allPrescriptions = <DoctorPrescriptionModel>[].obs;

  final filteredPrescriptions = <DoctorPrescriptionModel>[].obs;
  final prescriptions = <DoctorPrescriptionModel>[].obs; // Display list

  final templates = <int>[].obs;
  final filteredTemplates = <int>[].obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final searchQuery = ''.obs;
  final selectedStatus = 'All'.obs;
  final selectedDateRange = Rxn<DateTimeRange>();
  final selectedMedicineForm = 'All'.obs;
  final selectedMedicineCategory = 'All'.obs;
  final selectedAdministrationRoute = 'All'.obs;

  // Pagination
  RxInt currentPage = 1.obs;
  final int itemsPerPage = 4;

  @override
  void onInit() {
    super.onInit();
    selectedOption.value = options.first;
    fetchAllPrescriptions();

    debounce(
        searchQuery,
            (_) {
          currentPage.value = 1;
          applyFiltersAndSearch();
        },
        time: const Duration(milliseconds: 500)
    );
  }

  Future<void> fetchAllPrescriptions() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiService.get(ApiUrls.getAllPrescription);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;

        if (responseData['message'] == "Prescriptions fetched successfully" &&
            responseData['prescriptions'] != null) {

          final List<dynamic> prescriptionsJson = responseData['prescriptions'];
          final fetchedPrescriptions = prescriptionsJson
              .map((json) => DoctorPrescriptionModel.fromJson(json))
              .toList();

          allPrescriptions.assignAll(fetchedPrescriptions);
          applyFiltersAndSearch();
        }
      } else {
        errorMessage.value = 'Failed to fetch prescriptions';
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void applyFiltersAndSearch() {
    List<DoctorPrescriptionModel> filtered = List.from(allPrescriptions);

    if (selectedStatus.value != 'All') {
      filtered = filtered.where((prescription) {
        switch (selectedStatus.value) {
          case 'Active':
            return prescription.status == PrescriptionStatus.active;
          case 'Expiry Soon':
            return prescription.status == PrescriptionStatus.expirySoon;
          case 'Expired':
            return prescription.status == PrescriptionStatus.expired;
          case 'Completed':
            return prescription.status == PrescriptionStatus.completed;
          default:
            return true;
        }
      }).toList();
    }

    if (selectedDateRange.value != null) {
      filtered = filtered.where((prescription) {
        return prescription.issueDate.isAfter(selectedDateRange.value!.start) &&
            prescription.issueDate.isBefore(selectedDateRange.value!.end);
      }).toList();
    }

    if (selectedMedicineForm.value != 'All') {
      filtered = filtered.where((prescription) {
        return prescription.medications.any((med) =>
            med.name.toLowerCase().contains(selectedMedicineForm.value.toLowerCase()));
      }).toList();
    }

    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((prescription) {
        return prescription.patientInfo.fullName.toLowerCase().contains(query) ||
            prescription.diagnosis.toLowerCase().contains(query) ||
            prescription.prescriptionNumber.toLowerCase().contains(query) ||
            prescription.medications.any((med) =>
                med.name.toLowerCase().contains(query));
      }).toList();
    }

    filteredPrescriptions.assignAll(filtered);
    updateDisplayList();
  }

  void updateDisplayList() {
    prescriptions.assignAll(filteredPrescriptions);
  }

  void filterByStatus(String status) {
    selectedStatus.value = status;
    currentPage.value = 1;
    applyFiltersAndSearch();
  }

  void filterByDateRange(DateTimeRange? range) {
    selectedDateRange.value = range;
    currentPage.value = 1;
    applyFiltersAndSearch();
  }

  void filterByMedicineForm(String form) {
    selectedMedicineForm.value = form;
    currentPage.value = 1;
    applyFiltersAndSearch();
  }

  void filterByMedicineCategory(String category) {
    selectedMedicineCategory.value = category;
    currentPage.value = 1;
    applyFiltersAndSearch();
  }

  void filterByAdministrationRoute(String route) {
    selectedAdministrationRoute.value = route;
    currentPage.value = 1;
    applyFiltersAndSearch();
  }

  void resetAllFilters() {
    selectedStatus.value = 'All';
    selectedDateRange.value = null;
    selectedMedicineForm.value = 'All';
    selectedMedicineCategory.value = 'All';
    selectedAdministrationRoute.value = 'All';
    searchQuery.value = '';
    currentPage.value = 1;
    applyFiltersAndSearch();
  }

  List<DoctorPrescriptionModel> get paginatedPrescriptions {
    int start = (currentPage.value - 1) * itemsPerPage;
    int end = start + itemsPerPage;
    if (start >= prescriptions.length) return [];
    return prescriptions.sublist(
        start, end > prescriptions.length ? prescriptions.length : end);
  }

  List<int> get paginatedTemplates {
    int start = (currentPage.value - 1) * itemsPerPage;
    int end = start + itemsPerPage;
    if (start >= filteredTemplates.length) return [];
    return filteredTemplates.sublist(
        start, end > filteredTemplates.length ? filteredTemplates.length : end);
  }

  int get totalPages {
    int totalItems = prescriptionType.value == "activePrescription"
        ? prescriptions.length
        : filteredTemplates.length;
    if (totalItems == 0) return 1;
    return (totalItems / itemsPerPage).ceil();
  }

  int get filteredCount {
    return prescriptionType.value == "activePrescription"
        ? prescriptions.length
        : filteredTemplates.length;
  }

  void viewDetail(DoctorPrescriptionModel prescription) {
    Get.to(DoctorPrescriptionDetailScreen(
      prescriptionModel: prescription,
    ));
  }

  void searchTemplates(String query) {
    if (query.isEmpty) {
      filteredTemplates.assignAll(templates);
    } else {
      filteredTemplates.assignAll(
          templates.where((template) => template.toString().contains(query)).toList()
      );
    }
    currentPage.value = 1;
  }

  final selectedCycle = '1 month'.obs;
  final refillCycles = ['1 month', '3 months', '6 months'];

  void setCycle(String? newValue) {
    if (newValue != null) {
      selectedCycle.value = newValue;
    }
  }

  TextEditingController noteController = TextEditingController();
  void sendRequest() {
    Get.to(RefillStaus());
  }

  final List<DeliveryOption> options = [
    DeliveryOption(name: 'Home Delivery', price: 5.00),
    DeliveryOption(name: 'Pickup in pharmacy', price: 0.00),
  ];
  var selectedOption = Rx<DeliveryOption?>(null);
  void selectOption(DeliveryOption? option) {
    if (option != null) {
      selectedOption.value = option;
    }
  }

  List<String> statusOptions = ['All', 'Active', 'Expiry Soon', 'Expired', 'Completed'];
  List<String> medicineForm = ['All', 'Tablet', 'Capsule', 'Syrup', 'Injection'];
  List<String> medicineCategory = [
    'All',
    "Cardiology",
    "Dermatology",
    "Neurology",
    "Pediatrics",
    "Psychiatry",
  ];
  List<String> administrationRoute = [
    'All',
    'Oral',
    'Intravenous',
    'Topical',
    'Inhalation',
  ];
  List<String> dosageList = [
    'Once a day',
    'Twice a day',
    'Three times a day',
    'Every 6 hours',
    'Every 8 hours',
  ];
  RxString selectedDosage = 'Once a day'.obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(DateTime.now());

  String get formattedDate {
    if (selectedDate.value == null) return 'Select a Date';
    final date = selectedDate.value!;
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void updateDate(DateTime? newDate) {
    selectedDate.value = newDate;
  }
}