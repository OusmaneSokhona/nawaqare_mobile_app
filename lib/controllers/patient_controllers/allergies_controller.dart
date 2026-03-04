import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/services/api_service.dart';
import 'package:patient_app/utils/api_urls.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../models/allergy_model.dart';

class AllergyController extends GetxController {
  final ApiService apiService = ApiService();

  var isLoading = false.obs;
  var isAddingAllergy = false.obs;
  var isDeletingAllergy = false.obs;
  var allergiesData = <Allergy>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllergies();
  }

  // Fetch all allergies
  Future<void> fetchAllergies() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiService.get(ApiUrls.getAllAllergies);

      if (response.statusCode == 200) {
        // Assuming the response follows the AllergyResponse structure
        if (response.data['success'] == true) {
          allergiesData.value = (response.data['data'] as List)
              .map((json) => Allergy.fromJson(json))
              .toList();
        } else {
          errorMessage.value = response.data['message'] ?? 'Failed to load allergies';
        }
      } else {
        errorMessage.value = response.statusMessage ?? 'Failed to load allergies';
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error fetching allergies: $e');
    } finally {
      isLoading.value = false;
    }
  }
  final List<String> allergyTypeList = ['Medication', 'Food', 'Environmental'];
  final List<String> severityList = ['Mild', 'Slight', 'Minor', 'Low-Risk'];
  final List<String> statusList = ['active', 'resolved', 'unconfirmed'];
  final selectedAllergy = Rx<String?>('Medication');
  final selectedSeverity = Rx<String?>('Mild');
  final selectedAllergyStatus = Rx<String?>('active');
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

  final selectedFileName = Rx<String?>('No file selected');
  final selectedBloodFileName = Rx<String?>('No file selected');

  void pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpeg', 'jpg'],
    );

    if (result != null && result.files.single.name != null) {
      selectedFileName.value = result.files.single.name!;
    } else {
      selectedFileName.value = 'File selection cancelled';
    }
  }
  // Add new allergy
  Future<bool> addAllergy(Map<String, dynamic> allergyData) async {
    try {
      isAddingAllergy.value = true;
      errorMessage.value = '';

      final response = await apiService.post(ApiUrls.addAllergie, data:allergyData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data['success'] == true) {
          // Add the new allergy to the list
          final newAllergy = Allergy.fromJson(response.data['data']);
          allergiesData.add(newAllergy);

          Get.snackbar(
            'Success',
            response.data['message'] ?? 'Allergy added successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          return true;
        } else {
          errorMessage.value = response.data['message'] ?? 'Failed to add allergy';
          Get.snackbar(
            'Error',
            errorMessage.value,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          return false;
        }
      } else {
        errorMessage.value = response.statusMessage ?? 'Failed to add allergy';
        Get.snackbar(
          'Error',
          errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isAddingAllergy.value = false;
    }
  }
  //
  // // Update allergy
  // Future<bool> updateAllergy(String allergyId, Map<String, dynamic> allergyData) async {
  //   try {
  //     isLoading.value = true;
  //     errorMessage.value = '';
  //
  //     final response = await apiService.put(
  //         '${ApiUrls.updateAllergy}/$allergyId',
  //         allergyData
  //     );
  //
  //     if (response.statusCode == 200) {
  //       if (response.data['success'] == true) {
  //         // Update the allergy in the list
  //         final updatedAllergy = Allergy.fromJson(response.data['data']);
  //         final index = allergiesData.indexWhere((a) => a.id == allergyId);
  //         if (index != -1) {
  //           allergiesData[index] = updatedAllergy;
  //         }
  //
  //         Get.snackbar(
  //           'Success',
  //           response.data['message'] ?? 'Allergy updated successfully',
  //           backgroundColor: Colors.green,
  //           colorText: Colors.white,
  //           snackPosition: SnackPosition.BOTTOM,
  //         );
  //         return true;
  //       } else {
  //         errorMessage.value = response.data['message'] ?? 'Failed to update allergy';
  //         Get.snackbar(
  //           'Error',
  //           errorMessage.value,
  //           backgroundColor: Colors.red,
  //           colorText: Colors.white,
  //           snackPosition: SnackPosition.BOTTOM,
  //         );
  //         return false;
  //       }
  //     } else {
  //       errorMessage.value = response.statusMessage ?? 'Failed to update allergy';
  //       Get.snackbar(
  //         'Error',
  //         errorMessage.value,
  //         backgroundColor: Colors.red,
  //         colorText: Colors.white,
  //         snackPosition: SnackPosition.BOTTOM,
  //       );
  //       return false;
  //     }
  //   } catch (e) {
  //     errorMessage.value = e.toString();
  //     Get.snackbar(
  //       'Error',
  //       'An error occurred: $e',
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //     return false;
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  //
  // // Delete allergy
  // Future<bool> deleteAllergy(String allergyId) async {
  //   try {
  //     isDeletingAllergy.value = true;
  //     errorMessage.value = '';
  //
  //     final response = await apiService.delete('${ApiUrls.deleteAllergy}/$allergyId');
  //
  //     if (response.statusCode == 200) {
  //       if (response.data['success'] == true) {
  //         // Remove the allergy from the list
  //         allergiesData.removeWhere((a) => a.id == allergyId);
  //
  //         Get.snackbar(
  //           'Success',
  //           response.data['message'] ?? 'Allergy deleted successfully',
  //           backgroundColor: Colors.green,
  //           colorText: Colors.white,
  //           snackPosition: SnackPosition.BOTTOM,
  //         );
  //         return true;
  //       } else {
  //         errorMessage.value = response.data['message'] ?? 'Failed to delete allergy';
  //         Get.snackbar(
  //           'Error',
  //           errorMessage.value,
  //           backgroundColor: Colors.red,
  //           colorText: Colors.white,
  //           snackPosition: SnackPosition.BOTTOM,
  //         );
  //         return false;
  //       }
  //     } else {
  //       errorMessage.value = response.statusMessage ?? 'Failed to delete allergy';
  //       Get.snackbar(
  //         'Error',
  //         errorMessage.value,
  //         backgroundColor: Colors.red,
  //         colorText: Colors.white,
  //         snackPosition: SnackPosition.BOTTOM,
  //       );
  //       return false;
  //     }
  //   } catch (e) {
  //     errorMessage.value = e.toString();
  //     Get.snackbar(
  //       'Error',
  //       'An error occurred: $e',
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //     return false;
  //   } finally {
  //     isDeletingAllergy.value = false;
  //   }
  // }

  // Refresh allergies
  Future<void> refreshAllergies() async {
    await fetchAllergies();
  }

  // Get allergy by ID
  Allergy? getAllergyById(String id) {
    try {
      return allergiesData.firstWhere((allergy) => allergy.id == id);
    } catch (e) {
      return null;
    }
  }
}