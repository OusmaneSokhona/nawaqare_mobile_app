import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:patient_app/screens/document_view_screen.dart';
import 'package:patient_app/services/api_service.dart';
import 'package:patient_app/utils/api_urls.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';

class Report {
  final String id;
  final String patientId;
  final String doctorId;
  final String name;
  final String file;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;

  Report({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.name,
    required this.file,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['_id'],
      patientId: json['patientId'],
      doctorId: json['doctorId'],
      name: json['name'],
      file: json['file'],
      category: json['category'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class ReportController extends GetxController {
  final ApiService _apiService = ApiService();

  var reports = <Report>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var selectedFileName = Rxn<String>();
  var selectedFileBytes = Rxn<List<int>>();
  var isUploading = false.obs;
  String patientId = "";
  String doctorId = "";

  @override
  void onInit() {
    super.onInit();
    ever(selectedFileName, (_) {});
  }

  void initialize(String patientId, String doctorId) {
    this.patientId = patientId;
    this.doctorId = doctorId;
    fetchReports();
  }

  Future<void> fetchReports() async {
    if (patientId.isEmpty) {
      errorMessage.value = 'Patient ID is required';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _apiService.get("${ApiUrls.getReports}$patientId");

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        reports.value = data.map((json) => Report.fromJson(json)).toList();
      } else {
        errorMessage.value = 'Failed to fetch reports';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching reports: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'gif'],
        withData: true,
      );

      if (result != null) {
        selectedFileName.value = result.files.first.path;
        selectedFileBytes.value = result.files.first.bytes;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick file: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> addReportWithFile({
    required String patientId,
    required String name,
    required String category,
  }) async {
    try {
      isLoading.value = true;

      if (selectedFileName.value == null) {
        Get.snackbar(
          'Error',
          'Please select a file',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return;
      }

      FormData formData = FormData.fromMap({
        'patientId': patientId,
        'doctorId': doctorId,
        'name': name,
        'category': category,
        'reportFile': await MultipartFile.fromFile(selectedFileName.value!),
      });

      final response = await _apiService.post(ApiUrls.createReport, data: formData);

      if (response.data['success'] == true) {
        selectedFileName.value = null;
        selectedFileBytes.value = null;
        await fetchReports();
        Get.back();
        Get.snackbar(
          'Success',
          'Report added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to add report',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error adding report: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteReport(String reportId) async {
    try {
      isLoading.value = true;

      final response = await _apiService.delete('${ApiUrls.deleteReportOfPatient}$reportId');

      if (response.data['success'] == true) {
        reports.removeWhere((report) => report.id == reportId);
        Get.snackbar(
          'Success',
          'Report deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade400,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to delete report',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error deleting report: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void viewReport(Report report) {
    Get.to(DocumentViewerScreen(documentUrl: report.file, fileName: report.name));
  }

  void clearSelectedFile() {
    selectedFileName.value = null;
    selectedFileBytes.value = null;
  }

  String formatDate(DateTime date) {
    return '${_getMonthAbbreviation(date.month)} ${date.year}';
  }

  String _getMonthAbbreviation(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  IconData getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'blood test':
        return Icons.science_outlined;
      case 'x-ray':
      case 'chest xray':
        return Icons.medical_services_outlined;
      case 'mri':
      case 'mri scan':
        return Icons.document_scanner;
      default:
        return Icons.description_outlined;
    }
  }
}