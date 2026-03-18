import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/patient_screens/prescription_screens/refill_staus.dart';
import 'package:patient_app/services/api_service.dart';
import 'package:patient_app/utils/api_urls.dart';
import '../../models/delivery_options_model.dart';
import '../../models/prscription_model.dart';
import '../../screens/patient_screens/prescription_screens/prescription_details.dart';
import '../../screens/patient_screens/prescription_screens/request_refill.dart';

class PrescriptionController extends GetxController {
  ApiService apiService = ApiService();
  RxString prescriptionType = "activePrescription".obs;
  final prescriptions = <PrescriptionModel>[].obs;
  final postPrescriptions = <PrescriptionModel>[].obs;

  RxInt currentPage = 1.obs;
  final int itemsPerPage = 4;
  RxBool isLoading = false.obs;

  List<PrescriptionModel> get paginatedList {
    List<PrescriptionModel> currentList =
    prescriptionType.value == "activePrescription" ? prescriptions : postPrescriptions;

    int start = (currentPage.value - 1) * itemsPerPage;
    int end = start + itemsPerPage;
    if (start >= currentList.length) return [];
    return currentList.sublist(start, end > currentList.length ? currentList.length : end);
  }

  int get totalPages {
    List<PrescriptionModel> currentList =
    prescriptionType.value == "activePrescription" ? prescriptions : postPrescriptions;
    if (currentList.isEmpty) return 1;
    return (currentList.length / itemsPerPage).ceil();
  }

  @override
  void onInit() {
    super.onInit();
    selectedOption.value = options.first;
    fetchAllPrescriptions();
  }

  Future<void> fetchAllPrescriptions() async {
    isLoading.value = true;
    try {
      var response = await apiService.get(ApiUrls.getAllPrescription);

      if (response.data != null && response.data['prescriptions'] != null) {
        List<dynamic> prescriptionsList = response.data['prescriptions'];
        List<PrescriptionModel> allPrescriptions = [];

        for (var item in prescriptionsList) {
          String doctorName = item['doctorId']?['fullName'] ?? 'Unknown Doctor';
          String specialization = item['doctorId']?['medicalSpecialty']?['name'] ?? 'General Physician';

          String medicationName = '';
          if (item['medications'] != null && item['medications'].isNotEmpty) {
            medicationName = item['medications'][0]['name'] ?? '';
          }

          String dosageInstruction = '';
          if (item['medications'] != null && item['medications'].isNotEmpty) {
            var med = item['medications'][0];
            dosageInstruction = '${med['dosage'] ?? ''}, ${med['frequency'] ?? ''} for ${med['duration'] ?? ''}';
          }

          String issueDate = item['issueDate'] ?? '';
          String validUntil = item['validUntil'] ?? '';

          DateTime now = DateTime.now();
          DateTime validUntilDate = DateTime.parse(validUntil);
          PrescriptionStatus status;

          if (item['activestatus'] == 'active' && validUntilDate.isAfter(now)) {
            status = PrescriptionStatus.active;
          } else if (validUntilDate.isBefore(now)) {
            status = PrescriptionStatus.expired;
          } else if (validUntilDate.difference(now).inDays <= 7) {
            status = PrescriptionStatus.expirySoon;
          } else {
            status = PrescriptionStatus.active;
          }

          int refillsLeft = 0;
          if (status == PrescriptionStatus.active) {
            refillsLeft = validUntilDate.difference(now).inDays ~/ 30;
          }

          allPrescriptions.add(PrescriptionModel(
            id: item['_id'] ?? '',
            doctorName: doctorName,
            specialization: specialization,
            medicationName: medicationName,
            dosageInstruction: dosageInstruction,
            status: status,
            dateInfo: 'Valid until ${validUntil.split('T')[0]}',
            refillsLeft: refillsLeft,
            doctorImageUrl: 'assets/demo_images/doctor_2.png',
            diagnosis: item['diagnosis'] ?? '',
            notes: item['notes'] ?? '',
            prescriptionNumber: item['prescriptionNumber'] ?? '',
            medications: item['medications'] != null
                ? List<Map<String, dynamic>>.from(item['medications'])
                : [],
            appointmentData: item['appointmentId'] != null ? {
              'soap': item['appointmentId']['SOAP'] ?? {},
              'date': item['appointmentId']['date'] ?? '',
              'consultationType': item['appointmentId']['consultationType'] ?? '',
            } : null,
          ));
        }

        var activeList = allPrescriptions.where((p) =>
        p.status == PrescriptionStatus.active ||
            p.status == PrescriptionStatus.expirySoon).toList();
        var pastList = allPrescriptions.where((p) =>
        p.status == PrescriptionStatus.expired ||
            p.status == PrescriptionStatus.completed).toList();

        prescriptions.assignAll(activeList);
        postPrescriptions.assignAll(pastList);
      }
    } catch (e) {
      print('Error fetching prescriptions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void requestRefill(PrescriptionModel prescription) {
    Get.to(() => RequestRefill());
  }

  void viewDetail(PrescriptionModel prescription) {
    Get.to(() => PrescriptionDetails(prescriptionModel: prescription));
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
    Get.to(() => RefillStaus());
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
}