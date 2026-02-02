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
      print('Error loading doctors: $e');
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
      final String doctorName = doctor.displayName.toLowerCase();
      final String specialty = (doctor.medicalSpecialty ?? '').toLowerCase();
      final String clinicAddress = (doctor.clinicAddress ?? '').toLowerCase();

      final bool matchesSearch = doctorName.contains(query) ||
          specialty.contains(query) ||
          clinicAddress.contains(query);

      // Category filter
      final bool matchesCategory = selectedCategory.value == "All" ||
          (doctor.medicalSpecialty ?? '') == selectedCategory.value;

      // Gender filter
      final bool matchesGender = selectedGender.value == Gender.all ||
          (doctor.gender?.toLowerCase() ?? '') == selectedGender.value.name.toLowerCase();

      // Price filter
      final bool matchesPrice = _matchesPriceFilter(doctor);

      // Distance filter
      final bool matchesDistance = _matchesDistanceFilter(doctor);

      // Location filter (using country instead of religion)
      final bool matchesLocation = selectedLocation.value == 'All' ||
          (doctor.country ?? '').contains(selectedLocation.value) ||
          (doctor.placeOfPractice ?? '').contains(selectedLocation.value);

      // Consultation mode filter
      final bool matchesConsultationMode = _matchesConsultationMode(doctor);

      return matchesSearch &&
          matchesCategory &&
          matchesGender &&
          matchesPrice &&
          matchesDistance &&
          matchesLocation &&
          matchesConsultationMode;
    }).toList();
  }

  bool _matchesPriceFilter(DoctorModel doctor) {
    if (priceRange.value >= 1000) return true; // Show all if max price selected

    // Get the lowest available fee
    double? lowestFee;
    final fee = doctor.fee;

    if (fee != null) {
      final List<double?> fees = [
        fee.remoteConsultation,
        fee.inPersonConsultation,
        fee.homeVisitConsultation,
      ];

      for (var f in fees) {
        if (f != null) {
          if (lowestFee == null || f < lowestFee) {
            lowestFee = f;
          }
        }
      }
    }

    // If no fee available, include in results
    if (lowestFee == null) return true;

    return lowestFee <= priceRange.value;
  }

  bool _matchesDistanceFilter(DoctorModel doctor) {
    // This is a simplified distance filter
    // You can implement actual distance calculation later
    if (distanceRange.value >= 1000) return true; // Show all if max distance

    // For now, using placeOfPractice as distance indicator
    // You can replace this with actual coordinate-based distance calculation
    return true;
  }

  bool _matchesConsultationMode(DoctorModel doctor) {
    final fee = doctor.fee;

    switch (consultationMode.value) {
      case ConsultationMode.inPerson:
        return fee?.inPersonConsultation != null;
      case ConsultationMode.remote:
        return fee?.remoteConsultation != null;
      case ConsultationMode.all:
        return true;
    }
  }

  List<DoctorModel> get paginatedDoctorList {
    List<DoctorModel> list = filteredDoctorList;
    int start = (currentPage.value - 1) * itemsPerPage;
    int end = start + itemsPerPage;

    if (start >= list.length) return [];
    if (end > list.length) end = list.length;

    return list.sublist(start, end);
  }

  int get totalPages {
    int count = filteredDoctorList.length;
    if (count == 0) return 1;
    return (count / itemsPerPage).ceil();
  }

  // Extract unique specialties from doctor list
  List<String> get availableSpecialties {
    final specialties = _allDoctorList
        .map((doctor) => doctor.medicalSpecialty ?? 'General Practitioner')
        .where((specialty) => specialty.isNotEmpty)
        .toSet()
        .toList();

    // Add "All" at the beginning
    final result = ["All", ...specialties];

    // Ensure unique values and sort alphabetically (excluding "All")
    final sortedSpecialties = result
        .toSet()
        .toList()
      ..sort((a, b) {
        if (a == "All") return -1;
        if (b == "All") return 1;
        return a.compareTo(b);
      });

    return sortedSpecialties;
  }

  // Extract unique countries from doctor list for location filter
  List<String> get availableCountries {
    final countries = _allDoctorList
        .map((doctor) => doctor.country ?? '')
        .where((country) => country.isNotEmpty)
        .toSet()
        .toList();

    return ["All", ...countries]..sort((a, b) {
      if (a == "All") return -1;
      if (b == "All") return 1;
      return a.compareTo(b);
    });
  }

  // Filter properties
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxString selectedLocation = 'All'.obs;
  final Rx<ConsultationMode> consultationMode = ConsultationMode.all.obs;
  final RxDouble distanceRange = 1000.0.obs; // Default show all (1000 km/miles)
  final Rx<Gender> selectedGender = Gender.all.obs;
  final RxDouble priceRange = 1000.0.obs; // Default show all ($1000)

  void resetFilters() {
    selectedDate.value = null;
    selectedLocation.value = 'All';
    consultationMode.value = ConsultationMode.all;
    distanceRange.value = 1000.0;
    selectedGender.value = Gender.all;
    priceRange.value = 1000.0;
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

  // Get list of all doctors for external use
  List<DoctorModel> get allDoctors => _allDoctorList;

  // Get list of available time slots for a specific doctor
  List<String> getAvailableSlotsForDoctor(String doctorId) {
    final doctor = _allDoctorList.firstWhere(
          (doc) => doc.id == doctorId,
      orElse: () => DoctorModel(),
    );

    return doctor.availableSlots ?? [];
  }

  // Get doctor by ID
  DoctorModel? getDoctorById(String id) {
    try {
      return _allDoctorList.firstWhere((doctor) => doctor.id == id);
    } catch (e) {
      return null;
    }
  }
}

enum ConsultationMode { inPerson, remote, all }

enum Gender { male, female, all }