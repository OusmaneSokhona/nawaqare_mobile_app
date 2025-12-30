import 'package:get/get.dart';
import '../../../models/appointment_model.dart';

class AppointmentController extends GetxController {
  RxString appointmentType = "upcoming".obs;
  RxInt currentPage = 1.obs;
  final int itemsPerPage = 4;

  RxList<AppointmentModel> doctorList = <AppointmentModel>[
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
      consultationType: "In Person Consultation",
      rating: 5.0,
      fee: 10,
      date: "Sunday, 12 June",
      time: "11:00-12:00 AM",
      status: "Initial",
      imageUrl: "assets/demo_images/doctor_4.png",
    ),
    AppointmentModel(
      name: "Dr. Sarah Smith",
      specialty: "Dermatologist",
      consultationType: "In Person Consultation",
      rating: 4.8,
      fee: 15,
      date: "Monday, 13 June",
      time: "09:00-10:00 AM",
      status: "Initial",
      imageUrl: "assets/demo_images/doctor_1.png",
    ),
  ].obs;

  List<AppointmentModel> get paginatedList {
    int start = (currentPage.value - 1) * itemsPerPage;
    int end = start + itemsPerPage;
    if (start >= doctorList.length) return [];
    return doctorList.sublist(start, end > doctorList.length ? doctorList.length : end);
  }

  int get totalPages => (doctorList.length / itemsPerPage).ceil();
  final RxString selectedTab = "Diagnosis".obs;

  final List<String> tabs = [
    "Diagnosis",
    "Ordonnance",
    "Medical Report",
    "Reviews"
  ];
}