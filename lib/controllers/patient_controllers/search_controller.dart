import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/models/doctor_model.dart';
import 'package:patient_app/services/api_service.dart';
import 'package:patient_app/utils/api_urls.dart';

class SearchControllerCustom extends GetxController {
  ScrollController scrollController = ScrollController();
  RxDouble scrollValue = 0.0.obs;
  final RxString _searchQuery = ''.obs;
  RxString selectedCategory = "All".obs;
  RxInt currentPage = 1.obs;
  RxBool isLoading = true.obs;
  final ApiService apiService = ApiService();
  final RxList<DoctorModel> _allDoctorList = <DoctorModel>[].obs;
  final int itemsPerPage = 4;

  @override
  void onInit() {
    super.onInit();
    scrollChange();
    ever(_searchQuery, (_) {
      currentPage.value = 1;
    });
    ever(selectedCategory, (_) {
      currentPage.value = 1;
    });
    loadDoctors();
  }

  Future<void> loadDoctors() async {
    isLoading.value = true;
    try {
      final response = await apiService.get(ApiUrls.getDoctorsUrl);
      if (response.statusCode == 200) {
        if (response.data is Map && response.data['success'] == true) {
          final doctorResponse = DoctorListResponse.fromJson(response.data);
          _allDoctorList.value = doctorResponse.data;
        }
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  void scrollChange() {
    scrollController.addListener(() {
      scrollValue.value = scrollController.offset;
    });
  }

  void updateSearchQuery(String query) {
    _searchQuery.value = query;
  }

  List<DoctorModel> get filteredDoctorList {
    if (_allDoctorList.isEmpty) return [];

    return _allDoctorList.where((doctor) {
      // Text search filter
      final String query = _searchQuery.value.toLowerCase();
      final bool matchesSearch =
          doctor.fullName.toLowerCase().contains(query) ||
              (doctor.medicalSpecialty ?? '').toLowerCase().contains(query);

      // Category filter
      final bool matchesCategory = selectedCategory.value == "All" ||
          (doctor.medicalSpecialty ?? '') == selectedCategory.value;

      // Gender filter
      final bool matchesGender = selectedGender.value == Gender.all ||
          doctor.gender?.toLowerCase() == selectedGender.value.name.toLowerCase();

      // Price filter
      final bool matchesPrice = _matchesPriceFilter(doctor);

      // Distance filter (assuming doctors have location data)
      final bool matchesDistance = _matchesDistanceFilter(doctor);

      // Religion filter
      final bool matchesReligion = selectedReligion.value == 'All' ||
          doctor.country?.contains(selectedReligion.value) == true;

      // Consultation mode filter
      final bool matchesConsultationMode = _matchesConsultationMode(doctor);

      return matchesSearch &&
          matchesCategory &&
          matchesGender &&
          matchesPrice &&
          matchesDistance &&
          matchesReligion &&
          matchesConsultationMode;
    }).toList();
  }

  bool _matchesPriceFilter(DoctorModel doctor) {
    if (priceRange.value >= 50) return true; // Show all if max price selected

    final double? doctorFee = doctor.fee?.videoConsultation ?? doctor.fee?.inPersonConsultation;
    if (doctorFee == null) return true;

    return doctorFee <= priceRange.value;
  }

  bool _matchesDistanceFilter(DoctorModel doctor) {
    // This is a simplified distance filter
    // In a real app, you would calculate actual distance using coordinates
    return true; // For now, return true for all
  }

  bool _matchesConsultationMode(DoctorModel doctor) {
    switch (consultationMode.value) {
      case ConsultationMode.inPerson:
        return doctor.fee?.inPersonConsultation != null;
      case ConsultationMode.remote:
        return doctor.fee?.videoConsultation != null;
      case ConsultationMode.all:
        return true;
    }
  }

  List<DoctorModel> get paginatedDoctorList {
    List<DoctorModel> list = filteredDoctorList;
    int start = (currentPage.value - 1) * itemsPerPage;
    int end = start + itemsPerPage;

    if (start >= list.length) return [];
    return list.sublist(start, end > list.length ? list.length : end);
  }

  int get totalPages {
    int count = filteredDoctorList.length;
    if (count == 0) return 1;
    return (count / itemsPerPage).ceil();
  }

  List<String> doctorsTypeList = [
    "All",
    "Cardiologist",
    "Gynecologist",
    "Orthopedic Surgeon",
    "General Practitioner",
    "Dermatologist",
    "Pediatrician",
    "Neurologist",
  ];

  // Extract unique specialties from doctor list
  List<String> get availableSpecialties {
    final specialties = _allDoctorList
        .map((doctor) => doctor.medicalSpecialty ?? 'General Practitioner')
        .where((specialty) => specialty.isNotEmpty)
        .toSet()
        .toList();

    return ["All", ...specialties];
  }

  // Filter properties
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxString selectedReligion = 'All'.obs;
  final RxString selectedLocation = 'All'.obs;
  final Rx<ConsultationMode> consultationMode = ConsultationMode.all.obs;
  final RxDouble distanceRange = 5.0.obs; // Default 5km
  final Rx<Gender> selectedGender = Gender.all.obs;
  final RxDouble priceRange = 50.0.obs; // Default $50


  final List<String> locations = [
    'All',
    'Women\'s Clinic, Seattle, USA',
    'General Hospital, NY, USA',
    'Family Health Center, London, UK',
    'Cardiac Center, Boston, USA',
  ];

  void resetFilters() {
    selectedDate.value = null;
    selectedReligion.value = 'All';
    selectedLocation.value = 'All';
    consultationMode.value = ConsultationMode.all;
    distanceRange.value = 5.0;
    selectedGender.value = Gender.all;
    priceRange.value = 50.0;
    currentPage.value = 1;
    _searchQuery.value = '';
    selectedCategory.value = 'All';
    update();
  }

  void applyFilters() {
    scrollValue.value = 0.0;
    currentPage.value = 1;
    update();
    Get.back();
  }

  void updateDate(DateTime newDate) {
    selectedDate.value = newDate;
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
    }
  }

  // Method to refresh doctor list
  Future<void> refreshDoctors() async {
    await loadDoctors();
  }
}

enum ConsultationMode { inPerson, remote, all }

enum Gender { male, female, all }