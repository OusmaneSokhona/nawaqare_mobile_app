import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/services/api_service.dart';
import 'package:patient_app/utils/api_urls.dart';
import '../../models/allergy_model.dart';

class AllergyController extends GetxController {
  final ApiService apiService = ApiService();

  final allergenNameController = TextEditingController();
  final reactionController = TextEditingController();
  final noteController = TextEditingController();

  var isLoading = false.obs;
  var isAddingAllergy = false.obs;
  var isUpdatingAllergy = false.obs;
  var isDeletingAllergy = false.obs;
  var allergiesData = <Allergy>[].obs;
  var errorMessage = ''.obs;

  final List<String> allergyTypeList = ['birds', 'Medication', 'Food', 'Environmental'];
  final List<String> severityList = ['severe', 'Mild', 'Slight', 'Minor', 'Low-Risk'];

  final selectedAllergy = Rx<String?>('birds');
  final selectedSeverity = Rx<String?>('severe');
  final Rx<DateTime?> _selectedDate = Rx<DateTime?>(DateTime.now());

  final selectedFileName = Rx<String?>('No file selected');
  PlatformFile? pickedFile;

  @override
  void onInit() {
    super.onInit();
    fetchAllergies();
  }

  DateTime? get selectedDate => _selectedDate.value;

  String get formattedDate {
    if (_selectedDate.value == null) return 'Select a Date';
    final date = _selectedDate.value!;
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void updateDate(DateTime? newDate) {
    if (newDate != null) _selectedDate.value = newDate;
  }

  void pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpeg', 'jpg'],
    );

    if (result != null && result.files.single.path != null) {
      pickedFile = result.files.first;
      selectedFileName.value = result.files.single.name;
    } else {
      selectedFileName.value = 'File selection cancelled';
    }
  }

  Future<void> fetchAllergies() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await apiService.get(ApiUrls.getAllAllergies);
      if (response.statusCode == 200 && response.data['success'] == true) {
        allergiesData.value = (response.data['data'] as List)
            .map((json) => Allergy.fromJson(json))
            .toList();
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitAllergy() async {
    if (allergenNameController.text.isEmpty) {
      Get.snackbar('Required', 'Please enter allergen name',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    Map<String, dynamic> allergyData = {
      "allergyType": selectedAllergy.value,
      "allergenName": allergenNameController.text.trim(),
      "reaction": reactionController.text.trim(),
      "severity": selectedSeverity.value,
      "dateIdentified": _selectedDate.value?.toIso8601String(),
      "notes": noteController.text.trim(),
    };

    bool success = await addAllergy(allergyData);
  }

  Future<bool> addAllergy(Map<String, dynamic> allergyData) async {
    try {
      isAddingAllergy.value = true;
      errorMessage.value = '';

      dio.FormData formData = dio.FormData.fromMap(allergyData);

      if (pickedFile != null && pickedFile!.path != null) {
        formData.files.add(MapEntry(
          "photo",
          await dio.MultipartFile.fromFile(
            pickedFile!.path!,
            filename: pickedFile!.name,
          ),
        ));
      }

      final response = await apiService.post(ApiUrls.addAllergie, data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        fetchAllergies();
        Get.snackbar('Success', 'Allergy added successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
        return true;
      }
      return false;
    } catch (e) {
      _handleError(e);
      return false;
    } finally {
      isAddingAllergy.value = false;
    }
  }

  Future<bool> updateAllergy(String allergyId, Map<String, dynamic> allergyData) async {
    try {
      isUpdatingAllergy.value = true;
      errorMessage.value = '';

      dio.FormData formData = dio.FormData.fromMap(allergyData);

      if (pickedFile != null && pickedFile!.path != null) {
        formData.files.add(MapEntry(
          "photo",
          await dio.MultipartFile.fromFile(
            pickedFile!.path!,
            filename: pickedFile!.name,
          ),
        ));
      }

      final String updateUrl = "${ApiUrls.updateAllergie}$allergyId";
      final response = await apiService.put(updateUrl, data: formData);

      if (response.statusCode == 200) {
        int index = allergiesData.indexWhere((element) => element.id == allergyId);
        if (index != -1 && response.data['data'] != null) {
          allergiesData[index] = Allergy.fromJson(response.data['data']);
        }

        await fetchAllergies();
        Get.back();
        Get.snackbar('Updated', 'Allergy updated successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
        return true;
      }
      return false;
    } catch (e) {
      _handleError(e);
      return false;
    } finally {
      isUpdatingAllergy.value = false;
    }
  }

  Future<void> deleteItem(String allergyId) async {
    try {
      isDeletingAllergy.value = true;
      final String deleteUrl = "${ApiUrls.deleteAllergie}$allergyId";
      final response = await apiService.delete(deleteUrl);

      if (response.statusCode == 200 && response.data['success'] == true) {
        allergiesData.removeWhere((element) => element.id == allergyId);
        Get.snackbar('Deleted', 'Record removed successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      _handleError(e);
    } finally {
      isDeletingAllergy.value = false;
    }
  }

  void prepareEditScreen(Allergy allergy) {
    errorMessage.value = '';
    allergenNameController.text = allergy.allergenName ?? '';
    reactionController.text = allergy.reaction ?? '';
    noteController.text = allergy.notes ?? '';

    if (allergyTypeList.contains(allergy.allergyType)) {
      selectedAllergy.value = allergy.allergyType;
    }
    if (severityList.contains(allergy.severity)) {
      selectedSeverity.value = allergy.severity;
    }

    if (allergy.dateIdentified != null) {
      _selectedDate.value = DateTime.tryParse(allergy.dateIdentified.toString());
    }

    pickedFile = null;
    selectedFileName.value = 'No file selected';
  }

  void clearFields() {
    allergenNameController.clear();
    reactionController.clear();
    noteController.clear();
    selectedFileName.value = 'No file selected';
    pickedFile = null;
    _selectedDate.value = DateTime.now();
  }

  void _handleError(dynamic e) {
    String message = "An unexpected error occurred";
    if (e is dio.DioException) {
      final res = e.response;
      if (res?.data is Map) {
        message = res?.data['message'] ?? "Validation Error";
      } else {
        message = e.message ?? "Network Error";
      }
    }
    errorMessage.value = message;
    Get.snackbar('Error', message, backgroundColor: Colors.red, colorText: Colors.white);
  }
}