import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/api_service.dart';
import '../../../utils/nest_api_urls.dart';

enum ExamOrderStatus {
  REQUESTED,
  SENT_TO_PATIENT,
  COMPLETED,
  RESULTS_AVAILABLE,
  REVIEWED,
}

enum ExamType { BLOOD_TEST, URINE_TEST, IMAGING, BIOPSY, OTHER }

enum ExamPriority { ROUTINE, URGENT }

class ExamOrder {
  String? id;
  String type; // BLOOD_TEST, URINE_TEST, IMAGING, BIOPSY, OTHER
  String status; // REQUESTED, SENT_TO_PATIENT, COMPLETED, RESULTS_AVAILABLE, REVIEWED
  String priority; // ROUTINE, URGENT
  String description;
  String instructions;
  String? results;
  String? consultationId;
  DateTime? requestedAt;
  DateTime? completedAt;
  DateTime? reviewedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  ExamOrder({
    this.id,
    required this.type,
    required this.status,
    required this.priority,
    required this.description,
    required this.instructions,
    this.results,
    this.consultationId,
    this.requestedAt,
    this.completedAt,
    this.reviewedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory ExamOrder.fromJson(Map<String, dynamic> json) {
    return ExamOrder(
      id: json['id']?.toString(),
      type: json['type'] ?? 'OTHER',
      status: json['status'] ?? 'REQUESTED',
      priority: json['priority'] ?? 'ROUTINE',
      description: json['description'] ?? '',
      instructions: json['instructions'] ?? '',
      results: json['results']?.toString(),
      consultationId: json['consultationId']?.toString(),
      requestedAt: json['requestedAt'] != null ? DateTime.parse(json['requestedAt']) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      reviewedAt: json['reviewedAt'] != null ? DateTime.parse(json['reviewedAt']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'status': status,
      'priority': priority,
      'description': description,
      'instructions': instructions,
    };
  }
}

class ExamOrdersController extends GetxController {
  final ApiService _apiService = ApiService();

  // Form controllers for new exam order
  final typeController = Rx<ExamType>(ExamType.BLOOD_TEST);
  final priorityController = Rx<ExamPriority>(ExamPriority.ROUTINE);
  final descriptionController = TextEditingController();
  final instructionsController = TextEditingController();

  // Data
  final examOrders = <ExamOrder>[].obs;
  final isLoading = false.obs;
  final isSaving = false.obs;
  final errorMessage = ''.obs;
  final String consultationId;

  ExamOrdersController({required this.consultationId});

  @override
  void onInit() {
    super.onInit();
    fetchExamOrders();
  }

  @override
  void onClose() {
    descriptionController.dispose();
    instructionsController.dispose();
    super.onClose();
  }

  /// Fetch exam orders from backend
  Future<void> fetchExamOrders() async {
    isLoading.value = true;
    try {
      final url = NestApiUrls.getExamOrders(consultationId);
      final response = await _apiService.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List ? response.data : [];
        examOrders.value = data.map((item) => ExamOrder.fromJson(item)).toList();
      }
    } catch (e) {
      print('Fetch exam orders error: $e');
      errorMessage.value = 'Failed to load exam orders';
    } finally {
      isLoading.value = false;
    }
  }

  /// Create new exam order
  Future<bool> createExamOrder() async {
    if (descriptionController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter exam description';
      return false;
    }

    isSaving.value = true;
    try {
      final url = NestApiUrls.createExamOrder(consultationId);
      final payload = {
        'type': typeController.value.toString().split('.').last,
        'priority': priorityController.value.toString().split('.').last,
        'description': descriptionController.text.trim(),
        'instructions': instructionsController.text.trim(),
        'status': 'REQUESTED',
      };

      final response = await _apiService.post(url, data: payload);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newOrder = ExamOrder.fromJson(response.data);
        examOrders.add(newOrder);
        _resetForm();

        Get.snackbar(
          "Success",
          "Exam order created successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        return true;
      } else {
        errorMessage.value = response.data['message'] ?? 'Failed to create exam order';
        Get.snackbar("Error", errorMessage.value, backgroundColor: Colors.red);
        return false;
      }
    } catch (e) {
      print('Create exam order error: $e');
      errorMessage.value = 'An error occurred: $e';
      Get.snackbar("Error", errorMessage.value, backgroundColor: Colors.red);
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  /// Update exam order status (e.g., mark as reviewed)
  Future<bool> updateExamOrderStatus(String examOrderId, String newStatus) async {
    isSaving.value = true;
    try {
      final url = NestApiUrls.updateExamOrderStatus(examOrderId);
      final payload = {'status': newStatus};

      final response = await _apiService.patch(url, data: payload);

      if (response.statusCode == 200) {
        final index = examOrders.indexWhere((order) => order.id == examOrderId);
        if (index != -1) {
          examOrders[index].status = newStatus;
          examOrders.refresh();
        }

        Get.snackbar(
          "Success",
          "Exam order updated",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        return true;
      } else {
        errorMessage.value = response.data['message'] ?? 'Failed to update exam order';
        return false;
      }
    } catch (e) {
      print('Update exam order status error: $e');
      errorMessage.value = 'An error occurred: $e';
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  /// Reset form fields
  void _resetForm() {
    typeController.value = ExamType.BLOOD_TEST;
    priorityController.value = ExamPriority.ROUTINE;
    descriptionController.clear();
    instructionsController.clear();
    errorMessage.value = '';
  }

  /// Get status color based on exam status
  Color getStatusColor(String status) {
    switch (status) {
      case 'REQUESTED':
        return const Color(0xFFF2994A); // Orange
      case 'SENT_TO_PATIENT':
        return const Color(0xFF2F80ED); // Blue
      case 'COMPLETED':
        return const Color(0xFF828282); // Grey
      case 'RESULTS_AVAILABLE':
        return const Color(0xFF27AE60); // Green
      case 'REVIEWED':
        return const Color(0xFF6C5CE7); // Purple
      default:
        return const Color(0xFF828282);
    }
  }

  /// Get readable status text
  String getStatusLabel(String status) {
    switch (status) {
      case 'REQUESTED':
        return 'Requested';
      case 'SENT_TO_PATIENT':
        return 'Sent to Patient';
      case 'COMPLETED':
        return 'Completed';
      case 'RESULTS_AVAILABLE':
        return 'Results Available';
      case 'REVIEWED':
        return 'Reviewed';
      default:
        return status;
    }
  }
}
