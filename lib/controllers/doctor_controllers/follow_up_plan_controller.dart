import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/api_service.dart';
import '../../../utils/nest_api_urls.dart';

class ControlVisit {
  DateTime date;
  String description;

  ControlVisit({
    required this.date,
    required this.description,
  });

  factory ControlVisit.fromJson(Map<String, dynamic> json) {
    return ControlVisit(
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'description': description,
    };
  }
}

class FollowUpPlan {
  String? id;
  List<String> objectives;
  List<ControlVisit> controlVisits;
  List<String> reminders;
  List<String> redFlags;
  String patientSummaryFr;
  String? consultationId;
  DateTime? createdAt;
  DateTime? updatedAt;

  FollowUpPlan({
    this.id,
    required this.objectives,
    required this.controlVisits,
    required this.reminders,
    required this.redFlags,
    required this.patientSummaryFr,
    this.consultationId,
    this.createdAt,
    this.updatedAt,
  });

  factory FollowUpPlan.fromJson(Map<String, dynamic> json) {
    return FollowUpPlan(
      id: json['id']?.toString(),
      objectives: List<String>.from(json['objectives'] ?? []),
      controlVisits: (json['controlVisits'] as List<dynamic>?)
              ?.map((e) => ControlVisit.fromJson(e))
              .toList() ??
          [],
      reminders: List<String>.from(json['reminders'] ?? []),
      redFlags: List<String>.from(json['redFlags'] ?? []),
      patientSummaryFr: json['patientSummaryFr'] ?? '',
      consultationId: json['consultationId']?.toString(),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'objectives': objectives,
      'controlVisits': controlVisits.map((e) => e.toJson()).toList(),
      'reminders': reminders,
      'redFlags': redFlags,
      'patientSummaryFr': patientSummaryFr,
    };
  }
}

class FollowUpPlanController extends GetxController {
  final ApiService _apiService = ApiService();

  // Form data
  final patientSummaryController = TextEditingController();
  final objectives = <String>[].obs;
  final controlVisits = <ControlVisit>[].obs;
  final reminders = <String>[].obs;
  final redFlags = <String>[].obs;

  // Temporary input controllers for list items
  final objectiveInputController = TextEditingController();
  final redFlagInputController = TextEditingController();
  final visitDateController = TextEditingController();
  final visitDescriptionController = TextEditingController();

  // Data
  final existingPlan = Rx<FollowUpPlan?>(null);
  final isLoading = false.obs;
  final isSaving = false.obs;
  final errorMessage = ''.obs;
  final String consultationId;

  FollowUpPlanController({required this.consultationId});

  @override
  void onInit() {
    super.onInit();
    fetchFollowUpPlan();
  }

  @override
  void onClose() {
    patientSummaryController.dispose();
    objectiveInputController.dispose();
    redFlagInputController.dispose();
    visitDateController.dispose();
    visitDescriptionController.dispose();
    super.onClose();
  }

  /// Fetch existing follow-up plan
  Future<void> fetchFollowUpPlan() async {
    isLoading.value = true;
    try {
      final url = NestApiUrls.getFollowUpPlans(consultationId);
      final response = await _apiService.get(url);

      if (response.statusCode == 200) {
        if (response.data is List && (response.data as List).isNotEmpty) {
          existingPlan.value = FollowUpPlan.fromJson(response.data[0]);
          _populateForm();
        }
      }
    } catch (e) {
      print('Fetch follow-up plan error: $e');
      // First plan might not exist yet, this is OK
    } finally {
      isLoading.value = false;
    }
  }

  /// Populate form from existing plan
  void _populateForm() {
    if (existingPlan.value != null) {
      patientSummaryController.text = existingPlan.value!.patientSummaryFr;
      objectives.value = List.from(existingPlan.value!.objectives);
      controlVisits.value = List.from(existingPlan.value!.controlVisits);
      reminders.value = List.from(existingPlan.value!.reminders);
      redFlags.value = List.from(existingPlan.value!.redFlags);
    }
  }

  /// Add objective
  void addObjective(String objective) {
    if (objective.trim().isNotEmpty) {
      objectives.add(objective.trim());
      objectiveInputController.clear();
    }
  }

  /// Remove objective
  void removeObjective(int index) {
    if (index >= 0 && index < objectives.length) {
      objectives.removeAt(index);
    }
  }

  /// Add red flag
  void addRedFlag(String redFlag) {
    if (redFlag.trim().isNotEmpty) {
      redFlags.add(redFlag.trim());
      redFlagInputController.clear();
    }
  }

  /// Remove red flag
  void removeRedFlag(int index) {
    if (index >= 0 && index < redFlags.length) {
      redFlags.removeAt(index);
    }
  }

  /// Add control visit
  void addControlVisit(DateTime date, String description) {
    if (description.trim().isNotEmpty) {
      controlVisits.add(ControlVisit(date: date, description: description.trim()));
      visitDateController.clear();
      visitDescriptionController.clear();
    }
  }

  /// Remove control visit
  void removeControlVisit(int index) {
    if (index >= 0 && index < controlVisits.length) {
      controlVisits.removeAt(index);
    }
  }

  /// Validate form
  bool _validateForm() {
    if (patientSummaryController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter patient instructions';
      return false;
    }
    if (objectives.isEmpty) {
      errorMessage.value = 'Please add at least one objective';
      return false;
    }
    if (redFlags.isEmpty) {
      errorMessage.value = 'Please add at least one red flag';
      return false;
    }
    return true;
  }

  /// Save follow-up plan
  Future<bool> saveFollowUpPlan() async {
    if (!_validateForm()) return false;

    isSaving.value = true;
    try {
      final url = NestApiUrls.createFollowUpPlan(consultationId);
      final payload = FollowUpPlan(
        objectives: objectives,
        controlVisits: controlVisits,
        reminders: reminders,
        redFlags: redFlags,
        patientSummaryFr: patientSummaryController.text.trim(),
      ).toJson();

      final response = await _apiService.post(url, data: payload);

      if (response.statusCode == 200 || response.statusCode == 201) {
        existingPlan.value = FollowUpPlan.fromJson(response.data);

        Get.snackbar(
          "Success",
          "Follow-up plan saved successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        return true;
      } else {
        errorMessage.value = response.data['message'] ?? 'Failed to save follow-up plan';
        Get.snackbar("Error", errorMessage.value, backgroundColor: Colors.red);
        return false;
      }
    } catch (e) {
      print('Save follow-up plan error: $e');
      errorMessage.value = 'An error occurred: $e';
      Get.snackbar("Error", errorMessage.value, backgroundColor: Colors.red);
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  /// Reset form
  void resetForm() {
    patientSummaryController.clear();
    objectives.clear();
    controlVisits.clear();
    reminders.clear();
    redFlags.clear();
    objectiveInputController.clear();
    redFlagInputController.clear();
    visitDateController.clear();
    visitDescriptionController.clear();
    errorMessage.value = '';
  }
}
