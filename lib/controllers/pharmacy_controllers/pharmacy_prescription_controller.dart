import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:patient_app/client/api_client.dart';
import 'package:patient_app/models/pharmacy_prescription_model.dart';
import 'package:patient_app/utils/nest_api_urls.dart';

class PharmacyPrescriptionController extends GetxController{
  final ApiClient apiClient = ApiClient();

  RxString slectedCompany="DHL".obs;
  RxString slectedReasons="Invalid Signature".obs;
  RxString type="myPrescription".obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final prescriptions = <PharmacyPrescriptionModel>[].obs;
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

  @override
  void onInit() {
    super.onInit();
    fetchPharmacyPrescriptions();
  }

  /// Récupère la liste des prescriptions de la pharmacie
  Future<void> fetchPharmacyPrescriptions() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiClient.dio.get(
        NestApiUrls.baseUrl + NestApiUrls.getPharmacyPrescriptions(),
      );

      if (response.statusCode == 200) {
        final data = response.data as List?;
        if (data != null) {
          prescriptions.value = data
              .map((p) => PharmacyPrescriptionModel.fromJson(p as Map<String, dynamic>))
              .toList();
        }
      }
    } on DioException catch (e) {
      errorMessage.value = e.message ?? 'Erreur de chargement';
      // Garder les données mockées comme fallback
      _loadMockData();
    } catch (e) {
      errorMessage.value = 'Erreur: ${e.toString()}';
      _loadMockData();
    } finally {
      isLoading.value = false;
    }
  }

  /// Récupère une prescription par token QR
  Future<PharmacyPrescriptionModel?> getPrescriptionByQR(String token) async {
    try {
      final response = await apiClient.dio.get(
        NestApiUrls.baseUrl + NestApiUrls.getPharmacyPrescriptionByQR(token),
      );

      if (response.statusCode == 200) {
        return PharmacyPrescriptionModel.fromJson(response.data as Map<String, dynamic>);
      }
    } on DioException catch (e) {
      errorMessage.value = e.message ?? 'Erreur QR';
    } catch (e) {
      errorMessage.value = 'Erreur: ${e.toString()}';
    }
    return null;
  }

  /// Charge les données mockées en tant que fallback
  void _loadMockData() {
    prescriptions.value = [
      PharmacyPrescriptionModel(
        id: "#1234567",
        patientId: "#PH1234",
        doctorName: "Dr. Alina Shah",
        date: "12/Sep/2025",
        status: "Approved",
        hasQr: true,
      ),
      PharmacyPrescriptionModel(
        id: "#1234568",
        patientId: "#PH1235",
        doctorName: "Dr. Jean Dupont",
        date: "13/Sep/2025",
        status: "Pending",
        hasDoc: true,
      ),
      PharmacyPrescriptionModel(
        id: "#1234569",
        patientId: "#PH1236",
        doctorName: "Dr. Marie Bernard",
        date: "14/Sep/2025",
        status: "Ready to Ship",
        hasQr: true,
      ),
      PharmacyPrescriptionModel(
        id: "#1234570",
        patientId: "#PH1237",
        doctorName: "Dr. Pierre Martin",
        date: "15/Sep/2025",
        status: "Delivered",
        hasQr: true,
      ),
    ];
  }
}