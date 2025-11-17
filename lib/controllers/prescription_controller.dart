import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/prescription_details.dart';
import 'package:patient_app/screens/refill_staus.dart';
import 'package:patient_app/screens/request_refill.dart';

import '../models/delivery_options_model.dart';
import '../models/prscription_model.dart';

class PrescriptionController extends GetxController{
  RxString prescriptionType="activePrescription".obs;
  final prescriptions = <PrescriptionModel>[].obs;
  final postPrescriptions = <PrescriptionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    selectedOption.value=options.first;
    loadDummyData();
  }

  void loadDummyData() {
    prescriptions.assignAll([
      PrescriptionModel(
        id: 'p1',
        doctorName: 'Dr. Maria Waston',
        specialization: 'Heart Surgeon',
        medicationName: 'Amoxicillin 500mg',
        dosageInstruction: '1 tablet, twice daily after meals',
        status: PrescriptionStatus.active,
        dateInfo: 'Refill until March 5, 2025',
        refillsLeft: 2,
        doctorImageUrl: 'assets/demo_images/doctor_2.png',
      ),
      PrescriptionModel(
        id: 'p2',
        doctorName: 'Dr. John Doe',
        specialization: 'Family Physician',
        medicationName: 'Amlodipine 10mg',
        dosageInstruction: 'Morning & Evening',
        status: PrescriptionStatus.expirySoon,
        dateInfo: 'Refill until Sep 1, 2024',
        refillsLeft: 1,
        doctorImageUrl: 'assets/demo_images/doctor_3.png',
      ),
      PrescriptionModel(
        id: 'p3',
        doctorName: 'Dr. Jane Smith',
        specialization: 'Pediatrician',
        medicationName: 'Ibuprofen 200mg',
        dosageInstruction: '1 tablet, twice daily after meals',
        status: PrescriptionStatus.expired,
        dateInfo: 'Expire Sep 15, 2023',
        refillsLeft: 0,
        doctorImageUrl: 'assets/demo_images/doctor_4.png',
      ),
    ]);
    postPrescriptions.assignAll([
      PrescriptionModel(
        id: 'p1',
        doctorName: 'Dr. Maria Waston',
        specialization: 'Heart Surgeon',
        medicationName: 'Amoxicillin 500mg',
        dosageInstruction: '1 tablet, twice daily after meals',
        status: PrescriptionStatus.completed,
        dateInfo: 'Completed Date Sep 15, 2024',
        refillsLeft: null,
        doctorImageUrl: 'assets/demo_images/doctor_2.png',
      ),
      PrescriptionModel(
        id: 'p2',
        doctorName: 'Dr. John Doe',
        specialization: 'Family Physician',
        medicationName: 'Amlodipine 10mg',
        dosageInstruction: 'Morning & Evening',
        status: PrescriptionStatus.expired,
        dateInfo: 'Expired Date Sep 15, 2024',
        refillsLeft: null,
        doctorImageUrl: 'assets/demo_images/doctor_4.png',
      ),
      PrescriptionModel(
        id: 'p3',
        doctorName: 'Dr. Jane Smith',
        specialization: 'Pediatrician',
        medicationName: 'Ibuprofen 200mg',
        dosageInstruction: '1 tablet, twice daily after meals',
        status: PrescriptionStatus.completed,
        dateInfo: 'Completed Date Sep 15, 2024',
        refillsLeft: null,
        doctorImageUrl: 'assets/demo_images/doctor_3.png',
      ),
      PrescriptionModel(
        id: 'p4',
        doctorName: 'Dr. Alex Lee',
        specialization: 'Neurologist',
        medicationName: 'Ciprofloxacin 500mg',
        dosageInstruction: '1 tablet, twice daily after meals',
        status: PrescriptionStatus.expired,
        dateInfo: 'Expired Date Sep 15, 2024',
        refillsLeft: null,
        doctorImageUrl: 'assets/demo_images/doctor_1.png',
      ),
    ]);
  }

  void requestRefill(PrescriptionModel prescription) {
    Get.to(RequestRefill());
  }

  void viewDetail(PrescriptionModel prescription) {
    Get.to(PrescriptionDetails(prescriptionModel: prescription));
  }
  final selectedCycle = '1 month'.obs;
  final refillCycles = ['1 month', '3 months', '6 months'];

  void setCycle(String? newValue) {
    if (newValue != null) {
      selectedCycle.value = newValue;
    }
  }
  TextEditingController noteController=TextEditingController();
  void sendRequest(){
    Get.to(RefillStaus());
  }
  // .........delivery option .............//
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
}