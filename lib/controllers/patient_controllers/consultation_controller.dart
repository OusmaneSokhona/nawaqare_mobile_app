import 'package:get/get.dart';

import '../../models/consultation_model.dart';

class ConsultationController extends GetxController {
  RxString orderType = "Active Plan(2)".obs;
  RxString searchQuery = ''.obs;

  List<ConsultationModel> demoConsultations = [
    ConsultationModel(
      name: "Premium Tele-Consultation Plan 1",
      status: "Active",
      consultationType: "Video Consultation",
      expirationDate: DateTime(2025, 2, 21),
      cost: 45.00,
      creditsUsed: 3,
      totalCredits: 12,
    ),
    ConsultationModel(
      name: "Standard Checkup Plan",
      status: "Expire Soon",
      consultationType: "Video Consultation",
      expirationDate: DateTime(2025, 2, 21),
      cost: 45.00,
      creditsUsed: 3,
      totalCredits: 12,
    ),
    ConsultationModel(
      name: "Basic Plan",
      status: "Active",
      consultationType: "Video Consultation",
      expirationDate: DateTime(2025, 2, 21),
      cost: 45.00,
      creditsUsed: 3,
      totalCredits: 12,
    ),
    ConsultationModel(
      name: "Pre-Natal Care",
      status: "Pending",
      consultationType: "Video Consultation",
      expirationDate: DateTime(2025, 2, 21),
      cost: 45.00,
      creditsUsed: 3,
      totalCredits: 12,
    ),
  ];
  List<ConsultationModel> demoConsultationsHistory = [
    ConsultationModel(
      name: "Completed Follow-Up",
      status: "Completed",
      consultationType: "Video Consultation",
      expirationDate: DateTime(2025, 2, 21),
      cost: 45.00,
      creditsUsed: 3,
      totalCredits: 12,
    ),
    ConsultationModel(
      name: "Old Wellness Plan",
      status: "Expired",
      consultationType: "Video Consultation",
      expirationDate: DateTime(2025, 2, 21),
      cost: 45.00,
      creditsUsed: 3,
      totalCredits: 12,
    ),
    ConsultationModel(
      name: "Cancelled Initial Consult",
      status: "Completed",
      consultationType: "Video Consultation",
      expirationDate: DateTime(2025, 2, 21),
      cost: 45.00,
      creditsUsed: 3,
      totalCredits: 12,
    ),
    ConsultationModel(
      name: "Expired Family Plan",
      status: "Expired",
      consultationType: "Video Consultation",
      expirationDate: DateTime(2025, 2, 21),
      cost: 45.00,
      creditsUsed: 3,
      totalCredits: 12,
    ),
  ];

  List<ConsultationModel> get currentOrderList =>
      orderType.value == "Active Plan(2)" ? demoConsultations : demoConsultationsHistory;

  List<ConsultationModel> get filteredConsultation {
    if (searchQuery.value.isEmpty) {
      return currentOrderList;
    }

    final query = searchQuery.value.toLowerCase();

    return currentOrderList.where((consultation) {
      return consultation.name.toLowerCase().contains(query) ||
          consultation.status.toLowerCase().contains(query) ||
          consultation.expirationDate.toString().contains(query);
    }).toList();
  }
}