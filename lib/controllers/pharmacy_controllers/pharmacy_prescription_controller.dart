import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:patient_app/models/pharmacy_prescription_model.dart';

class PharmacyPrescriptionController extends GetxController{
  RxString slectedCompany="A".obs;
  RxString slectedReasons="Invalid Signature".obs;
RxString type="myPrescription".obs;

  final prescriptions = <PharmacyPrescriptionModel>[
    PharmacyPrescriptionModel(
      id: "#1234567",
      patientId: "#PH1234",
      doctorName: "Dr.Alina shah",
      date: "12/Sep/2025",
      status: "Approved",
      hasQr: true,
    ),
    PharmacyPrescriptionModel(
      id: "#1234567",
      patientId: "#PH1234",
      doctorName: "Dr.Alina shah",
      date: "12/Sep/2025",
      status: "Pending",
      hasDoc: true,
    ),
    PharmacyPrescriptionModel(
      id: "#1234567",
      patientId: "#PH1234",
      doctorName: "Dr.Alina shah",
      date: "12/Sep/2025",
      status: "Ready to Ship",
      hasQr: true,
    ),
    PharmacyPrescriptionModel(
      id: "#1234567",
      patientId: "#PH1234",
      doctorName: "Dr.Alina shah",
      date: "12/Sep/2025",
      status: "Delivered",
      hasQr: true,
    ),
    PharmacyPrescriptionModel(
      id: "#8901234",
      patientId: "#PH5678",
      doctorName: "Dr.Alina shah",
      date: "12/Sep/2025",
      status: "Approved",
      hasDoc: true,
    ),
    PharmacyPrescriptionModel(
      id: "#5432109",
      patientId: "#PH9876",
      doctorName: "Dr.Alina shah",
      date: "12/Sep/2025",
      status: "Pending",
      hasQr: true,
      hasDoc: true,
    ),
    PharmacyPrescriptionModel(
      id: "#1122334",
      patientId: "#PH0011",
      doctorName: "Dr.Alina shah",
      date: "12/Sep/2025",
      status: "Delivered",
      hasQr: true,
    ),
    PharmacyPrescriptionModel(
      id: "#5566778",
      patientId: "#PH2233",
      doctorName: "Dr.Alina shah",
      date: "12/Sep/2025",
      status: "Ready to Ship",
      hasDoc: true,
    ),
    PharmacyPrescriptionModel(
      id: "#9900112",
      patientId: "#PH4455",
      doctorName: "Dr.Alina shah",
      date: "12/Sep/2025",
      status: "Approved",
      hasQr: true,
    ),
    PharmacyPrescriptionModel(
      id: "#3344556",
      patientId: "#PH6677",
      doctorName: "Dr.Alina shah",
      date: "12/Sep/2025",
      status: "Pending",
      hasQr: true,
      hasDoc: true,
    ),
    PharmacyPrescriptionModel(
      id: "#7788990",
      patientId: "#PH8899",
      doctorName: "Dr.Alina shah",
      date: "12/Sep/2025",
      status: "Ready to Ship",
      hasQr: true,
    ),
    PharmacyPrescriptionModel(
      id: "#2211009",
      patientId: "#PH0123",
      doctorName: "Dr.Alina shah",
      date: "12/Sep/2025",
      status: "Delivered",
      hasDoc: true,
    ),
  ].obs;
  final List<Map<String, dynamic>> demoData = const [
    {
      "id": "#RX-20391",
      "date": "Oct 25, 2025",
      "amount": "PKR 1,250",
      "pharmacist": "PH-021",
      "status": "Pending",
      "statusColor": Color(0xFFE69B59),
    },
    {
      "id": "#RX-20391",
      "date": "Oct 25, 2025",
      "amount": "PKR 1,250",
      "pharmacist": "PH-021",
      "status": "Validated",
      "statusColor": Color(0xFF64B5F6),
    },
    {
      "id": "#RX-20391",
      "date": "Oct 25, 2025",
      "amount": "PKR 1,250",
      "pharmacist": "PH-021",
      "status": "Rejected",
      "statusColor": Color(0xFFE5533D),
    },
    {
      "id": "#RX-20391",
      "date": "Oct 25, 2025",
      "amount": "PKR 1,250",
      "pharmacist": "PH-021",
      "status": "Delivered",
      "statusColor": Color(0xFF63AB67),
    },
  ];

  final Rx<DateTime?> _selectedDate = Rx<DateTime?>(DateTime.now());

  DateTime? get selectedDate => _selectedDate.value;

  String get formattedDate {
    if (_selectedDate.value == null) {
      return 'Select a Date';
    }
    final date = _selectedDate.value!;
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void updateDate(DateTime? newDate) {
    _selectedDate.value = newDate;
  }
}