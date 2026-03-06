import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:image_picker/image_picker.dart';
import 'package:patient_app/controllers/patient_controllers/profile_controller.dart';
import 'package:patient_app/services/api_service.dart';
import 'package:patient_app/utils/api_urls.dart';
import 'package:patient_app/utils/locat_storage.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

class BloodTypeController extends GetxController {
  final ProfileController profileController = Get.find<ProfileController>();
  final ApiService apiService = ApiService();

  Rx<String?> selectedBloodType = Rx<String?>(null);
  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<File?> selectedFile = Rx<File?>(null);
  RxString selectedFileName = 'No file selected'.obs;

  final List<String> bloodList = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'
  ];

  final ImagePicker _picker = ImagePicker();




  Future<void> pickFile() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        selectedFile.value = File(pickedFile.path);
        selectedFileName.value = pickedFile.name;
      } else {
        selectedFileName.value = 'File selection cancelled';
      }
    } catch (e) {
      print('Error picking file: $e');
      selectedFileName.value = 'Error selecting file';
    }
  }

  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  Future<void> updateBloodType() async {
    if (selectedBloodType.value == null) {
      Get.snackbar(
        'Error',
        'Please select blood type',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final token = await LocalStorageUtils.getToken();
      if (token == null) {
        Get.back();
        Get.snackbar(
          'Error',
          'Authentication token not found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      FormData formData = FormData.fromMap({
        'type': selectedBloodType.value,
        'lastConfirmed': selectedDate.value.toIso8601String(),
      });

      // Add file if selected using the same pattern as your example
      if (selectedFile.value != null && selectedFile.value!.path.isNotEmpty) {
        formData.files.add(MapEntry(
          'bloodReport',
          await MultipartFile.fromFile(
            selectedFile.value!.path,
            filename: 'blood_report_${DateTime.now().millisecondsSinceEpoch}.jpg',
          ),
        ));
      }

      final response = await apiService.put(
        ApiUrls.updateBloodType,
        data: formData,
      );

      Get.back();

      if (response.statusCode == 200 || response.statusCode == 201) {

        Get.snackbar(
          'Success',
          'Blood type updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.back();
      } else {
        String errorMessage = 'Failed to update blood type';
        if (response.data is Map && response.data['message'] != null) {
          errorMessage = response.data['message'];
        }

        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.back();
      print('Error updating blood type: $e');

      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void clearSelection() {
    selectedBloodType.value = null;
    selectedFile.value = null;
    selectedFileName.value = 'No file selected';
    selectedDate.value = DateTime.now();
  }
}