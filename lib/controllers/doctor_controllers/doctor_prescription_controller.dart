import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/doctor_screens/prescription_screens/doctor_prescription_detail_screen.dart';
import '../../models/delivery_options_model.dart';
import '../../models/prscription_model.dart';
import '../../screens/patient_screens/prescription_screens/prescription_details.dart';
import '../../screens/patient_screens/prescription_screens/refill_staus.dart';
import '../../screens/patient_screens/prescription_screens/request_refill.dart';

class DoctorPrescriptionController extends GetxController {
  RxString prescriptionType = "activePrescription".obs;
  final prescriptions = <PrescriptionModel>[].obs;

  final templates = <int>[1, 2, 3, 4, 5, 6].obs;

  RxInt currentPage = 1.obs;
  final int itemsPerPage = 4;

  @override
  void onInit() {
    super.onInit();
    selectedOption.value = options.first;
    loadDummyData();
  }

  List<PrescriptionModel> get paginatedPrescriptions {
    int start = (currentPage.value - 1) * itemsPerPage;
    int end = start + itemsPerPage;
    if (start >= prescriptions.length) return [];
    return prescriptions.sublist(
        start, end > prescriptions.length ? prescriptions.length : end);
  }

  List<int> get paginatedTemplates {
    int start = (currentPage.value - 1) * itemsPerPage;
    int end = start + itemsPerPage;
    if (start >= templates.length) return [];
    return templates.sublist(
        start, end > templates.length ? templates.length : end);
  }

  int get totalPages {
    int totalItems = prescriptionType.value == "activePrescription"
        ? prescriptions.length
        : templates.length;
    if (totalItems == 0) return 1;
    return (totalItems / itemsPerPage).ceil();
  }

  void loadDummyData() {
    prescriptions.assignAll([
      PrescriptionModel(
        id: 'p1',
        doctorName: 'Mrs. Maria Waston',
        specialization: 'Heart Surgeon',
        medicationName: 'Amoxicillin 500mg',
        dosageInstruction: '1 tablet, twice daily after meals',
        status: PrescriptionStatus.active,
        dateInfo: 'Refill until March 5, 2025',
        refillsLeft: 2,
        doctorImageUrl: 'assets/demo_images/patient_3.png',
      ),
      PrescriptionModel(
        id: 'p2',
        doctorName: 'Mr. John Doe',
        specialization: 'Family Physician',
        medicationName: 'Amlodipine 10mg',
        dosageInstruction: 'Morning & Evening',
        status: PrescriptionStatus.expirySoon,
        dateInfo: 'Refill until Sep 1, 2024',
        refillsLeft: 1,
        doctorImageUrl: 'assets/demo_images/patient_2.png',
      ),
      PrescriptionModel(
        id: 'p2',
        doctorName: 'Mr. John Doe',
        specialization: 'Family Physician',
        medicationName: 'Amlodipine 10mg',
        dosageInstruction: 'Morning & Evening',
        status: PrescriptionStatus.expirySoon,
        dateInfo: 'Refill until Sep 1, 2024',
        refillsLeft: 1,
        doctorImageUrl: 'assets/demo_images/patient_2.png',
      ),
      PrescriptionModel(
        id: 'p2',
        doctorName: 'Mr. John Doe',
        specialization: 'Family Physician',
        medicationName: 'Amlodipine 10mg',
        dosageInstruction: 'Morning & Evening',
        status: PrescriptionStatus.expirySoon,
        dateInfo: 'Refill until Sep 1, 2024',
        refillsLeft: 1,
        doctorImageUrl: 'assets/demo_images/patient_2.png',
      ),
      PrescriptionModel(
        id: 'p3',
        doctorName: 'Mr. Jane Smith',
        specialization: 'Pediatrician',
        medicationName: 'Ibuprofen 200mg',
        dosageInstruction: '1 tablet, twice daily after meals',
        status: PrescriptionStatus.expired,
        dateInfo: 'Expire Sep 15, 2023',
        refillsLeft: 0,
        doctorImageUrl: 'assets/demo_images/patient_1.png',
      ),
      PrescriptionModel(
        id: 'p4',
        doctorName: 'Mr. Daniel Lee',
        specialization: 'Cardiologist',
        medicationName: 'Lisinopril 10mg',
        dosageInstruction: '1 tablet daily',
        status: PrescriptionStatus.active,
        dateInfo: 'Refill until June 12, 2025',
        refillsLeft: 5,
        doctorImageUrl: 'assets/demo_images/patient_1.png',
      ),
    ]);
  }

  void viewDetail(PrescriptionModel prescription) {
    Get.to(DoctorPrescriptionDetailScreen(prescriptionModel: prescription));
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

  List<String> statusOptions = ['All', 'Active', 'Expiry Soon', 'Expired'];
  RxString selectedStatus = 'All'.obs;
  List<String> medicineForm = ['All', 'Tablet', 'Capsule', 'Syrup', 'Injection'];
  RxString selectedMedicineForm = 'All'.obs;
  List<String> medicineCategory = [
    'All',
    "Cardiology",
    "Dermatology",
    "Neurology",
    "Pediatrics",
    "Psychiatry",
  ];
  RxString selectedMedicineCategory = 'All'.obs;
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
  RxString selectedAdministrationRoute = 'All'.obs;
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