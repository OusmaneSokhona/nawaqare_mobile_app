import 'package:get/get.dart';
import '../../models/patient_model.dart';
import '../../utils/app_strings.dart';

class PatientController extends GetxController {
  RxString selectedCategory = AppStrings.overview.tr.obs;
  RxInt currentPage = 1.obs;
  final int itemsPerPage = 4;

  RxList<PatientModel> allPatients = <PatientModel>[
    PatientModel(
      patientName: 'Mr. Alex Martin',
      patientImageUrl: 'assets/demo_images/patient_1.png',
      lastAppointmentDate: 'Sunday, 12 June',
      consultationType: 'Remote Consultation',
      period: 'This Week',
    ),
    PatientModel(
      patientName: 'Ms. Sarah Johnson',
      patientImageUrl: 'assets/demo_images/patient_2.png',
      lastAppointmentDate: 'Monday, 13 June',
      consultationType: 'In-Person Consultation',
      period: 'This Month',
    ),
    PatientModel(
      patientName: 'Mr. David Lee',
      patientImageUrl: 'assets/demo_images/patient_3.png',
      lastAppointmentDate: 'Wednesday, 15 June',
      consultationType: 'Remote Consultation',
      period: 'This Week',
    ),
    PatientModel(
      patientName: 'Mrs. Jessica Turner',
      patientImageUrl: 'assets/demo_images/patient_3.png',
      lastAppointmentDate: 'Sunday, 12 June',
      consultationType: 'In person Consultation',
      period: 'This Month',
    ),
    PatientModel(
      patientName: 'Mr. Michael Johnson',
      patientImageUrl: 'assets/demo_images/patient_2.png',
      lastAppointmentDate: 'Sunday, 12 June',
      consultationType: 'Remote Consultation',
      period: 'This Week',
    ),
  ].obs;

  List<PatientModel> get paginatedPatients {
    int start = (currentPage.value - 1) * itemsPerPage;
    int end = start + itemsPerPage;
    if (start >= allPatients.length) return [];
    return allPatients.sublist(
        start, end > allPatients.length ? allPatients.length : end);
  }

  int get totalPages => (allPatients.length / itemsPerPage).ceil();

  List<String> statusOptions = [
    AppStrings.all.tr,
    AppStrings.active.tr,
    AppStrings.expirySoon.tr,
    AppStrings.expired.tr,
  ];

  RxString selectedStatus = AppStrings.all.tr.obs;
}