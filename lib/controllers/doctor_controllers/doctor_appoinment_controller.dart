import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../models/appointment_model.dart';

class DoctorAppointmentController extends GetxController {
  final selectedDateIndex = 2.obs;

  void selectDate(int index) {
    selectedDateIndex.value = index;
  }

  RxString appointmentType = "upcoming".obs;
  RxInt currentPage = 1.obs;
  final int itemsPerPage = 4;

  List<AppointmentModel> patientList = [
    AppointmentModel(
      name: "Mr. Daniel Lee",
      specialty: "Cardiologist",
      consultationType: "Remote Consultation",
      rating: 5.0,
      fee: 10,
      date: "Sunday, 12 June",
      time: "11:00-12:00 AM",
      status: "Follow Up",
      imageUrl: "assets/demo_images/patient_1.png",
    ),
    AppointmentModel(
      name: "Mr. Daniel Lee",
      specialty: "Cardiologist",
      consultationType: "Remote Consultation",
      rating: 5.0,
      fee: 10,
      date: "Sunday, 12 June",
      time: "11:00-12:00 AM",
      status: "Follow Up",
      imageUrl: "assets/demo_images/patient_1.png",
    ),
    AppointmentModel(
      name: "Mr. Daniel Lee",
      specialty: "Cardiologist",
      consultationType: "Remote Consultation",
      rating: 5.0,
      fee: 10,
      date: "Sunday, 12 June",
      time: "11:00-12:00 AM",
      status: "Follow Up",
      imageUrl: "assets/demo_images/patient_1.png",
    ),
    AppointmentModel(
      name: "Mrs. Jessica Turner",
      specialty: "Gynecologist",
      consultationType: "Remote Consultation",
      rating: 5.0,
      fee: 10,
      date: "Sunday, 12 June",
      time: "11:00-12:00 AM",
      status: "Renewal",
      imageUrl: "assets/demo_images/patient_3.png",
    ),
    AppointmentModel(
      name: "Mr. Michael Johnson",
      specialty: "Orthopedic Surgery",
      consultationType: "In person Consultation",
      rating: 5.0,
      fee: 10,
      date: "Sunday, 12 June",
      time: "11:00-12:00 AM",
      status: "Exam Review",
      imageUrl: "assets/demo_images/patient_2.png",
    ),
    AppointmentModel(
      name: "Mrs. Jessica Turner",
      specialty: "Orthopedic Surgery",
      consultationType: "In person Consultation",
      rating: 5.0,
      fee: 10,
      date: "Sunday, 12 June",
      time: "11:00-12:00 AM",
      status: "Initial",
      imageUrl: "assets/demo_images/patient_3.png",
    ),
  ];

  List<AppointmentModel> postPatientList = [
    AppointmentModel(
      name: "Mr. Daniel Lee",
      specialty: "Cardiologist",
      consultationType: "Remote Consultation",
      rating: 5.0,
      fee: 10,
      date: "Sunday, 12 June",
      time: "11:00-12:00 AM",
      status: "Completed",
      imageUrl: "assets/demo_images/patient_1.png",
    ),
    AppointmentModel(
      name: "Mrs. Jessica Turner",
      specialty: "Gynecologist",
      consultationType: "Remote Consultation",
      rating: 5.0,
      fee: 10,
      date: "Sunday, 12 June",
      time: "11:00-12:00 AM",
      status: "Cancelled",
      imageUrl: "assets/demo_images/patient_3.png",
    ),
    AppointmentModel(
      name: "Mr. Michael Johnson",
      specialty: "Orthopedic Surgery",
      consultationType: "In person Consultation",
      rating: 5.0,
      fee: 10,
      date: "Sunday, 12 June",
      time: "11:00-12:00 AM",
      status: "Exam Review",
      imageUrl: "assets/demo_images/patient_2.png",
    ),
    AppointmentModel(
      name: "Mrs. Jessica Turner",
      specialty: "Orthopedic Surgery",
      consultationType: "In person Consultation",
      rating: 5.0,
      fee: 10,
      date: "Sunday, 12 June",
      time: "11:00-12:00 AM",
      status: "Cancelled",
      imageUrl: "assets/demo_images/patient_3.png",
    ),
  ];

  List<AppointmentModel> get paginatedList {
    List<AppointmentModel> currentList =
    appointmentType.value == "upcoming" ? patientList : postPatientList;
    int start = (currentPage.value - 1) * itemsPerPage;
    int end = start + itemsPerPage;
    if (start >= currentList.length) return [];
    return currentList.sublist(
        start, end > currentList.length ? currentList.length : end);
  }

  int get totalPages {
    List<AppointmentModel> currentList =
    appointmentType.value == "upcoming" ? patientList : postPatientList;
    return (currentList.length / itemsPerPage).ceil();
  }

  final List<String> consultationTypes = [
    'Follow Up',
    'Initial Consultation',
    'Review'
  ];
  final List<String> statuses = ['Confirmed', 'Pending', 'Cancelled'];
  final List<String> periods = [
    'This week',
    'Last week',
    'This month',
    'All time'
  ];

  final RxString _selectedConsultationType = 'Follow Up'.obs;
  final RxString _selectedStatus = 'Confirmed'.obs;
  final RxString _selectedPeriod = 'This week'.obs;

  String get selectedConsultationType => _selectedConsultationType.value;
  String get selectedStatus => _selectedStatus.value;
  String get selectedPeriod => _selectedPeriod.value;

  void updateConsultationType(String? newValue) {
    if (newValue != null) {
      _selectedConsultationType.value = newValue;
    }
  }

  void updateStatus(String? newValue) {
    if (newValue != null) {
      _selectedStatus.value = newValue;
    }
  }

  void updatePeriod(String? newValue) {
    if (newValue != null) {
      _selectedPeriod.value = newValue;
    }
  }

  void resetFilters() {
    _selectedConsultationType.value = consultationTypes.first;
    _selectedStatus.value = statuses.first;
    _selectedPeriod.value = periods.first;
  }

  void applyFilters() {
    Get.back();
  }

  RxString notesText =
      "Symptoms improving, headache frequency reduced from 5 to 2 times per week. Advised patient to continue current regimen and maintain sleep hygiene"
          .obs;
  TextEditingController notesController = TextEditingController();

  void saveNotes() {
    notesText.value = notesController.text;
  }

  List<String> reportTypes = [
    "Blood Test Report",
    "X-Ray Report",
    "MRI Scan Report",
    "CT Scan Report",
    "Ultrasound Report",
  ];
  RxString selectedReportType = "Blood Test Report".obs;
  final selectedFileName = Rx<String?>('No file selected');

  void pickFile(Rx<String?> file) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpeg', 'jpg'],
    );

    if (result != null && result.files.single.name != null) {
      file.value = result.files.single.name!;
    } else {
      file.value = 'File selection cancelled';
    }
  }
}