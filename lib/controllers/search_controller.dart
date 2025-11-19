import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/appointment_model.dart';

class SearchControllerCustom extends GetxController{
  ScrollController scrollController=ScrollController();
  RxDouble scrollValue=0.0.obs;
  final RxString _searchQuery = ''.obs;
  RxString selectedCategory="All".obs;

  @override
  void onInit() {
    super.onInit();
    // Re-initialize scroll listener in onInit for better practice
    scrollChange();
    // Add listeners to rebuild filteredList when search or category changes
    ever(_searchQuery, (_) => update());
    ever(selectedCategory, (_) => update());
  }

  void scrollChange(){
    scrollController.addListener((){
      scrollValue.value=scrollController.offset;
      // print(scrollValue);
    });
  }
  void updateSearchQuery(String query) {
    _searchQuery.value = query;
  }

  // --- Doctor List and Filtering Logic ---

  final List<AppointmentModel> _allDoctorList = [
    AppointmentModel(
      name: "Dr. Daniel Lee",
      specialty: "Cardiologist",
      consultationType: "Remote Consultation",
      rating: 5.0,
      fee: 10,
      date: "Sunday, 12 June",
      time: "11:00-12:00 AM",
      status: "Follow Up",
      imageUrl: "assets/demo_images/doctor_1.png",
    ),
    AppointmentModel(
      name: "Dr. Jessica Turner",
      specialty: "Gynecologist",
      consultationType: "Remote Consultation",
      rating: 5.0,
      fee: 10,
      date: "Sunday, 12 June",
      time: "11:00-12:00 AM",
      status: "Renewal",
      imageUrl: "assets/demo_images/doctor_2.png",
    ),
    AppointmentModel(
      name: "Dr. Michael Johnson",
      specialty: "Orthopedic Surgery",
      consultationType: "In person Consultation",
      rating: 5.0,
      fee: 10,
      date: "Sunday, 12 June",
      time: "11:00-12:00 AM",
      status: "Exam Review",
      imageUrl: "assets/demo_images/doctor_3.png",
    ),
    AppointmentModel(
      name: "Dr. Michael Johnson",
      specialty: "Orthopedic Surgery",
      consultationType: "In person Consultation",
      rating: 5.0,
      fee: 10,
      date: "Sunday, 12 June",
      time: "11:00-12:00 AM",
      status: "Initial",
      imageUrl: "assets/demo_images/doctor_4.png",
    ),
    AppointmentModel(
      name: "Dr. General Guy",
      specialty: "General Practitioner",
      consultationType: "In person Consultation",
      rating: 4.5,
      fee: 15,
      date: "Monday, 13 June",
      time: "09:00-10:00 AM",
      status: "Initial",
      imageUrl: "assets/demo_images/doctor_1.png",
    ),
  ];

  List<AppointmentModel> get doctorList {
    return _allDoctorList.where((doctor) {
      final String query = _searchQuery.value.toLowerCase();
      final bool matchesSearch = doctor.name.toLowerCase().contains(query) ||
          doctor.specialty.toLowerCase().contains(query);

      final bool matchesCategory = selectedCategory.value == "All" ||
          doctor.specialty == selectedCategory.value;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<String> doctorsTypeList=["All","General Practitioner","Gynecologist","Cardiologist","Orthopedic Surgery"];

  // ........search filter bottom sheet ........//
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(DateTime(2025, 9, 12));
  final RxString selectedReligion = 'Islam'.obs;
  final RxString selectedLocation = 'Women\'s Clinic, Seattle, USA'.obs;
  final Rx<ConsultationMode> consultationMode = ConsultationMode.inPerson.obs;
  final RxDouble distanceRange = 2.5.obs;
  final Rx<Gender> selectedGender = Gender.male.obs;
  final RxDouble priceRange = 25.0.obs;

  final List<String> religions = ['Islam', 'Christianity', 'Judaism', 'Hinduism'];
  final List<String> locations = ['Women\'s Clinic, Seattle, USA', 'General Hospital, NY, USA', 'Family Health Center, London, UK'];

  void resetFilters() {
    selectedDate.value = DateTime(2025, 9, 12);
    selectedReligion.value = 'Islam';
    selectedLocation.value = 'Women\'s Clinic, Seattle, USA';
    consultationMode.value = ConsultationMode.inPerson;
    distanceRange.value = 2.5;
    selectedGender.value = Gender.male;
    priceRange.value = 25.0;
  }

  void applyFilters() {
    Get.back();
  }

  void updateDate(DateTime newDate) {
    selectedDate.value = newDate;
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
    }
  }
}
enum ConsultationMode { inPerson, remote }
enum Gender { male, female }