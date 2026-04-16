import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:dio/dio.dart';
import '../../models/doctor_model.dart';
import '../../models/medical_history_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../services/api_service.dart';
import '../../utils/api_urls.dart';
import 'home_controller.dart';

class MedicalHistoryController extends GetxController {
  final ApiService apiService = ApiService();
  RxBool isLoading = false.obs;
  HomeController homeController = Get.find<HomeController>();

  RxString historyType = AppStrings.currentMedication.obs;

  RxList<MedicalHistoryResponse> apiMedicationList = <MedicalHistoryResponse>[].obs;
  RxList<MedicalHistoryResponse> medicalHistoryList = <MedicalHistoryResponse>[].obs;
  RxMap<String, dynamic> medicalHistoryData = <String, dynamic>{}.obs;

  TextEditingController noteController = TextEditingController();
  RxString selectedHistoryId = ''.obs;
  RxString selectedSectionType = ''.obs;

  TextEditingController medicineNameController = TextEditingController();
  TextEditingController dosageController = TextEditingController();
  TextEditingController familyConditionController = TextEditingController();
  TextEditingController familyAgeController = TextEditingController();
  TextEditingController familyNotesController = TextEditingController();
  TextEditingController vaccineNameController = TextEditingController();
  TextEditingController problemNameController = TextEditingController();
  TextEditingController treatmentController = TextEditingController();
  TextEditingController allergenController = TextEditingController();
  TextEditingController reactionController = TextEditingController();
  TextEditingController bpController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController procedureController = TextEditingController();
  TextEditingController surgicalDateController = TextEditingController();
  TextEditingController infectionTypeController = TextEditingController();
  TextEditingController infectionDateController = TextEditingController();
  TextEditingController infectionNotesController = TextEditingController();

  RxString medicationStatus = "Active".obs;
  RxString vaccinationStatus = "Pending".obs;
  RxString activeRelation = "Father".obs;
  RxBool hasRefill = false.obs;
  final Rx<String?> selectedSeverityFamilyHistory = Rx<String?>('Mild');
  final Rx<String?> selectedSeverity = Rx<String?>('Mild');
  final Rx<String?> selectedSurgicalSeverity = Rx<String?>('Mild');
  final RxString selectedSmoking = 'Yes'.obs;
  final RxString selectedAlcohol = 'None'.obs;
  final RxString selectedActivity = 'Sedentary'.obs;
  final RxString selectedDiet = 'Balanced'.obs;
  final RxString selectedSleep = 'Good'.obs;
  Rx<File?> selectedCertificateFile = Rx<File?>(null);

  final Map<String, List<String>> categories = {
    'Smoking': ['Yes', 'No', 'Occasionally'],
    'Alcohol Use': ['None', 'Occasional', 'Regular'],
    'Physical Activity': ['Sedentary', 'Moderate', 'Active'],
    'Diet Type': ['Vegetarian', 'High Protein', 'Balanced'],
    'Sleep Quality': ['Good', 'Fair', 'Poor'],
  };

  List<String> medicationStatusList = ["Active", "Stopped", "Completed"];
  List<String> vacinationStatusList = ["Pending", "Completed"];
  List<String> relationList = ["Father", "Mother", "Son", "Brother", "Sister"];
  final List<String> severityList = ['Mild', 'Moderate', 'Severe'];
  final selectedFileName = Rx<String?>('No file selected');

  final RxList<DoctorModel> allDoctorList = <DoctorModel>[].obs;
  final Rx<DoctorModel?> selectedDoctor = Rx<DoctorModel?>(null);

  final Rx<DateTime?> _selectedDate = Rx<DateTime?>(DateTime.now());
  DateTime? get selectedDate => _selectedDate.value;
  String get formattedDate {
    if (_selectedDate.value == null) return 'Select a Date';
    final date = _selectedDate.value!;
    const months = ['January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void updateDate(DateTime? newDate) {
    _selectedDate.value = newDate;
  }

  void updateSelection(String category, String value) {
    switch (category) {
      case 'Smoking':
        selectedSmoking.value = value;
        break;
      case 'Alcohol Use':
        selectedAlcohol.value = value;
        break;
      case 'Physical Activity':
        selectedActivity.value = value;
        break;
      case 'Diet Type':
        selectedDiet.value = value;
        break;
      case 'Sleep Quality':
        selectedSleep.value = value;
        break;
    }
  }

  RxString getSelection(String category) {
    switch (category) {
      case 'Smoking':
        return selectedSmoking;
      case 'Alcohol Use':
        return selectedAlcohol;
      case 'Physical Activity':
        return selectedActivity;
      case 'Diet Type':
        return selectedDiet;
      case 'Sleep Quality':
        return selectedSleep;
      default:
        throw Exception('Invalid category');
    }
  }

  void pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpeg', 'jpg', 'png'],
    );
    if (result != null && result.files.single.path != null) {
      selectedFileName.value = result.files.single.name;
      selectedCertificateFile.value = File(result.files.single.path!);
    } else {
      selectedFileName.value = 'No file selected';
      selectedCertificateFile.value = null;
    }
  }

  Future<void> loadDoctors() async {
    try {
      final response = await apiService.get(ApiUrls.getDoctorsUrl);
      if (response.statusCode == 200) {
        if (response.data is Map && response.data['success'] == true) {
          final doctorResponse = DoctorListResponse.fromJson(response.data);
          allDoctorList.value = doctorResponse.data;
          if (allDoctorList.isNotEmpty) {
            selectedDoctor.value = allDoctorList.first;
          }
        }
      }
    } catch (e) {
      print('Error loading doctors: $e');
    }
  }

  Future<void> fetchMedicalHistory() async {
    try {
      isLoading.value = true;
      String patientId = homeController.currentUser.value?.id ?? "";
      if (patientId.isEmpty) {
        debugPrint('Patient ID is empty');
        return;
      }

      final response = await apiService.get("${ApiUrls.getMedicalHistory}$patientId");

      if (response.statusCode == 200) {
        var rawData = response.data;
        if (rawData is List && rawData.isNotEmpty) {
          medicalHistoryList.assignAll(rawData.map((json) => MedicalHistoryResponse.fromJson(json.cast<String, dynamic>())).toList());
          if (medicalHistoryList.isNotEmpty) {
            medicalHistoryData.value = Map<String, dynamic>.from(medicalHistoryList.first.toJson());
          }
        } else if (rawData is Map && rawData.containsKey('addMedications')) {
          Map<String, dynamic> castedData = Map<String, dynamic>.from(rawData);
          medicalHistoryData.value = castedData;
          MedicalHistoryResponse singleRecord = MedicalHistoryResponse.fromJson(castedData);
          medicalHistoryList.add(singleRecord);
        } else if (rawData is Map) {
          Map<String, dynamic> castedData = Map<String, dynamic>.from(rawData);
          medicalHistoryData.value = castedData;
          MedicalHistoryResponse singleRecord = MedicalHistoryResponse.fromJson(castedData);
          medicalHistoryList.add(singleRecord);
        }
      }
    } catch (e) {
      debugPrint('Fetch Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addMedication() async {

    try {
      isLoading.value = true;
      String doctorId = selectedDoctor.value?.id ?? "";

      Map<String, dynamic> requestData = {
        "patientId": homeController.currentUser.value?.id,
        "type": "medications",
        "data": {
          "medicineName": medicineNameController.text.trim(),
          "dosage": dosageController.text.trim(),
          "doctor": doctorId,
          "refill": hasRefill.value,
        }
      };

      debugPrint('Request Data: ${jsonEncode(requestData)}');

      final response = await apiService.post(ApiUrls.createMedicalHistory, data: requestData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success handling
      } else {
        // Try to extract more error details
        String errorMsg = 'Failed to add medication';
        if (response.data != null) {
          if (response.data is Map) {
            errorMsg = response.data['message'] ??
                response.data['error'] ??
                response.data['details'] ??
                'Server error: ${response.statusCode}';
          } else {
            errorMsg = response.data.toString();
          }
        }

        debugPrint('Error Response: ${response.data}');
        Get.snackbar('Error', errorMsg,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 5));
      }
    } on DioException catch (e) {
      debugPrint('DioException Response: ${e.response?.data}');
      debugPrint('DioException Status Code: ${e.response?.statusCode}');

      String errorMsg = 'Network error occurred';
      if (e.response?.data != null) {
        if (e.response?.data is Map) {
          errorMsg = e.response?.data['message'] ??
              e.response?.data['error'] ??
              e.response?.data['details'] ??
              'Server error: ${e.response?.statusCode}';
        } else {
          errorMsg = e.response?.data.toString() ?? 'Unknown server error';
        }
      }

      Get.snackbar('Error', errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 5));
    } catch (e) {
      debugPrint('Unexpected Error: $e');
      Get.snackbar('Error', 'An unexpected error occurred: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addVaccination() async {
    if (vaccineNameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter vaccination name',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (_selectedDate.value == null) {
      Get.snackbar('Error', 'Please select vaccination date',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      String patientId = homeController.currentUser.value?.id ?? "";
      if (patientId.isEmpty) {
        Get.snackbar('Error', 'Patient ID not found',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
        isLoading.value = false;
        return;
      }

      String formattedDateString = "${_selectedDate.value!.year}-${_selectedDate.value!.month.toString().padLeft(2, '0')}-${_selectedDate.value!.day.toString().padLeft(2, '0')}";

      Map<String, dynamic> vaccineData = {
        "vaccineName": vaccineNameController.text.trim(),
        "date": formattedDateString,
        "status": vaccinationStatus.value.toLowerCase(),
      };

      if (selectedCertificateFile.value != null) {
        String fileName = selectedCertificateFile.value!.path.split('/').last;
        MultipartFile multipartFile = await MultipartFile.fromFile(
          selectedCertificateFile.value!.path,
          filename: fileName,
        );

        FormData formData = FormData.fromMap({
          'patientId': patientId,
          'type': 'vaccinations',
          'certificate': multipartFile,
          'data': jsonEncode(vaccineData),
        });

        debugPrint('Vaccination FormData with file created');
        final response = await apiService.post(ApiUrls.createMedicalHistory, data: formData);

        if (response.statusCode == 200 || response.statusCode == 201) {
          _clearVaccinationForm();
          await fetchMedicalHistory();
          Get.back();
          Get.snackbar('Success', 'Vaccination added successfully',
              snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        } else {
          Get.snackbar('Error', 'Failed to add vaccination',
              snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        Map<String, dynamic> requestData = {
          "patientId": patientId,
          "type": "vaccinations",
          "data": vaccineData,
        };

        debugPrint('Vaccination Request: $requestData');
        final response = await apiService.post(ApiUrls.createMedicalHistory, data: requestData);

        if (response.statusCode == 200 || response.statusCode == 201) {
          _clearVaccinationForm();
          await fetchMedicalHistory();
          Get.back();
          Get.snackbar('Success', 'Vaccination added successfully',
              snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        } else {
          String errorMsg = response.data['message'] ?? 'Failed to add vaccination';
          Get.snackbar('Error', errorMsg,
              snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
        }
      }
    } on DioException catch (e) {
      debugPrint('Dio Error: ${e.response?.data}');
      String errorMsg = 'Network error occurred';
      if (e.response?.data is Map) {
        errorMsg = e.response?.data['message'] ?? e.response?.data['error'] ?? 'Server error';
      }
      Get.snackbar('Error', errorMsg,
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      debugPrint('Vaccination Error: $e');
      Get.snackbar('Error', 'An unexpected error occurred: $e',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addSurgicalHistory() async {
    if (procedureController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter procedure name',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;

      Map<String, dynamic> requestData = {
        "patientId": homeController.currentUser.value?.id ?? "",
        "type": "surgical",
        "data": {
          "procedure": procedureController.text.trim(),
          "date": surgicalDateController.text.trim().isEmpty ? DateTime.now().year.toString() : surgicalDateController.text.trim(),
          "severity": selectedSurgicalSeverity.value?.toLowerCase() ?? "mild",
        }
      };

      debugPrint('Surgical Request: $requestData');

      final response = await apiService.post(ApiUrls.createMedicalHistory, data: requestData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _clearSurgicalForm();
        await fetchMedicalHistory();
        Get.back();
        Get.snackbar('Success', 'Surgical history added successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        String errorMsg = response.data['message'] ?? 'Failed to add surgical history';
        Get.snackbar('Error', errorMsg,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint('Surgical Error: $e');
      Get.snackbar('Error', 'An unexpected error occurred: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addFamilyHistory() async {
    if (familyConditionController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter the medical condition',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (familyAgeController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter the age at diagnosis',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      int age = int.parse(familyAgeController.text.trim());

      Map<String, dynamic> requestData = {
        "patientId": homeController.currentUser.value?.id ?? "",
        "type": "familyHistory",
        "data": {
          "relation": activeRelation.value,
          "condition": familyConditionController.text.trim(),
          "severity": selectedSeverityFamilyHistory.value?.toLowerCase() ?? "mild",
          "age": age,
          "notes": familyNotesController.text.trim(),
        }
      };

      debugPrint('Family History Request: $requestData');

      final response = await apiService.post(ApiUrls.createMedicalHistory, data: requestData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _clearFamilyHistoryForm();
        await fetchMedicalHistory();
        Get.back();
        Get.snackbar('Success', 'Family history added successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        String errorMsg = response.data['message'] ?? 'Failed to add family history';
        Get.snackbar('Error', errorMsg,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint('Family History Error: $e');
      Get.snackbar('Error', 'Unexpected error: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addLifestyle() async {
    try {
      isLoading.value = true;

      Map<String, dynamic> requestData = {
        "patientId": homeController.currentUser.value?.id ?? "",
        "type": "lifestyle",
        "data": {
          "smoking": selectedSmoking.value.toLowerCase(),
          "alcohol": selectedAlcohol.value.toLowerCase(),
          "physicalActivity": selectedActivity.value.toLowerCase(),
          "dietType": selectedDiet.value.toLowerCase(),
          "sleepQuality": selectedSleep.value.toLowerCase(),
        }
      };

      debugPrint('Lifestyle Request: $requestData');

      final response = await apiService.post(ApiUrls.createMedicalHistory, data: requestData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchMedicalHistory();
        Get.back();
        Get.snackbar('Success', 'Lifestyle data saved successfully',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        String errorMsg = response.data['message'] ?? 'Failed to save lifestyle data';
        Get.snackbar('Error', errorMsg,
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint('Lifestyle Error: $e');
      Get.snackbar('Error', 'Unexpected error: $e',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addProblemHistory() async {
    if (problemNameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter problem name',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      String doctorId = selectedDoctor.value?.id ?? "";

      Map<String, dynamic> requestData = {
        "patientId": homeController.currentUser.value?.id ?? "",
        "type": "problem",
        "data": {
          "problemName": problemNameController.text.trim(),
          "treatment": treatmentController.text.trim(),
          "doctor": doctorId,
        }
      };

      debugPrint('Problem History Request: $requestData');

      final response = await apiService.post(ApiUrls.createMedicalHistory, data: requestData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _clearProblemForm();
        await fetchMedicalHistory();
        Get.back();
        Get.snackbar('Success', 'Problem history added successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        String errorMsg = response.data['message'] ?? 'Failed to add problem history';
        Get.snackbar('Error', errorMsg,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint('Problem History Error: $e');
      Get.snackbar('Error', 'Unexpected error: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addAllergy() async {
    if (allergenController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter allergen',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;

      Map<String, dynamic> requestData = {
        "patientId": homeController.currentUser.value?.id ?? "",
        "type": "allergical",
        "data": {
          "allergen": allergenController.text.trim(),
          "reaction": reactionController.text.trim(),
          "severity": selectedSeverity.value?.toLowerCase() ?? "mild",
        }
      };

      debugPrint('Allergy Request: $requestData');

      final response = await apiService.post(ApiUrls.createMedicalHistory, data: requestData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _clearAllergyForm();
        await fetchMedicalHistory();
        Get.back();
        Get.snackbar('Success', 'Allergy added successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        String errorMsg = response.data['message'] ?? 'Failed to add allergy';
        Get.snackbar('Error', errorMsg,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint('Allergy Error: $e');
      Get.snackbar('Error', 'Unexpected error: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addBaselineVitals() async {
    if (bpController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter blood pressure',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      double? weight = double.tryParse(weightController.text.trim());
      double? height = double.tryParse(heightController.text.trim());
      double? bmi = (weight != null && height != null && height > 0) ? weight / ((height / 100) * (height / 100)) : null;

      Map<String, dynamic> requestData = {
        "patientId": homeController.currentUser.value?.id ?? "",
        "type": "vitals",
        "data": {
          "bp": bpController.text.trim(),
          "weight": weight,
          "height": height,
          "bmi": bmi?.toStringAsFixed(1),
        }
      };

      debugPrint('Vitals Request: $requestData');

      final response = await apiService.post(ApiUrls.createMedicalHistory, data: requestData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _clearVitalsForm();
        await fetchMedicalHistory();
        Get.back();
        Get.snackbar('Success', 'Baseline vitals added successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        String errorMsg = response.data['message'] ?? 'Failed to add vitals';
        Get.snackbar('Error', errorMsg,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint('Vitals Error: $e');
      Get.snackbar('Error', 'Unexpected error: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addInfectiousHistory() async {
    if (infectionTypeController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter infection type',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;

      Map<String, dynamic> requestData = {
        "patientId": homeController.currentUser.value?.id ?? "",
        "type": "infectional",
        "data": {
          "infectionType": infectionTypeController.text.trim(),
          "date": infectionDateController.text.trim(),
          "notes": infectionNotesController.text.trim(),
        }
      };

      debugPrint('Infectious History Request: $requestData');

      final response = await apiService.post(ApiUrls.createMedicalHistory, data: requestData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _clearInfectionForm();
        await fetchMedicalHistory();
        Get.back();
        Get.snackbar('Success', 'Infectious history added successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        String errorMsg = response.data['message'] ?? 'Failed to add infectious history';
        Get.snackbar('Error', errorMsg,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint('Infectious History Error: $e');
      Get.snackbar('Error', 'Unexpected error: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addNote(String historyId, String sectionType) async {
    if (noteController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter a note',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      Map<String, dynamic> requestData = {
        "patientId": homeController.currentUser.value?.id ?? "",
        "note": noteController.text.trim(),
      };
      final response = await apiService.patch(ApiUrls.addNoteApi, data: requestData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        noteController.clear();
        Get.back();
        Get.snackbar('Success', 'Note added successfully',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        await fetchMedicalHistory();
      } else {
        Get.snackbar('Error', 'Failed to add note',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsVerified(String historyId, String type) async {
    try {
      isLoading.value = true;
      final response = await apiService.patch(ApiUrls.markVerified, data: {
        "patientId": homeController.currentUser.value?.id ?? "",
        "type": type,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Marked as verified successfully',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        await fetchMedicalHistory();
      } else {
        Get.snackbar('Error', 'Failed to mark as verified',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void showAddNoteDialog(String historyId, String sectionType) {
    selectedHistoryId.value = historyId;
    selectedSectionType.value = sectionType;
    noteController.clear();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Note', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black)),
              16.verticalSpace,
              TextField(
                controller: noteController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Enter your note here...',
                  hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: Colors.grey.shade300)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: Colors.grey.shade300)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: AppColors.primaryColor, width: 2)),
                  contentPadding: EdgeInsets.all(12.w),
                ),
              ),
              20.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r), side: BorderSide(color: Colors.grey.shade400)),
                      ),
                      child: Text('Cancel', style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700)),
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: Obx(() => ElevatedButton(
                      onPressed: isLoading.value ? null : () => addNote(historyId, sectionType),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                      ),
                      child: isLoading.value
                          ? SizedBox(height: 20.h, width: 20.w, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text('Add Note', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.white)),
                    )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _clearMedicationForm() {
    medicineNameController.clear();
    dosageController.clear();
    hasRefill.value = false;
    medicationStatus.value = "Active";
    selectedDoctor.value = allDoctorList.isNotEmpty ? allDoctorList.first : null;
  }

  void _clearVaccinationForm() {
    vaccineNameController.clear();
    _selectedDate.value = DateTime.now();
    vaccinationStatus.value = "Pending";
    selectedFileName.value = 'No file selected';
    selectedCertificateFile.value = null;
  }

  void _clearFamilyHistoryForm() {
    familyConditionController.clear();
    familyAgeController.clear();
    familyNotesController.clear();
    activeRelation.value = relationList.first;
    selectedSeverityFamilyHistory.value = severityList.first;
  }

  void _clearProblemForm() {
    problemNameController.clear();
    treatmentController.clear();
    selectedDoctor.value = allDoctorList.isNotEmpty ? allDoctorList.first : null;
  }

  void _clearAllergyForm() {
    allergenController.clear();
    reactionController.clear();
    selectedSeverity.value = 'Mild';
  }

  void _clearVitalsForm() {
    bpController.clear();
    weightController.clear();
    heightController.clear();
  }

  void _clearSurgicalForm() {
    procedureController.clear();
    surgicalDateController.clear();
    selectedSurgicalSeverity.value = 'Mild';
  }

  void _clearInfectionForm() {
    infectionTypeController.clear();
    infectionDateController.clear();
    infectionNotesController.clear();
  }

  @override
  void onInit() {
    super.onInit();
    loadDoctors();
    fetchMedicalHistory();
  }

  @override
  void onClose() {
    familyConditionController.dispose();
    familyAgeController.dispose();
    familyNotesController.dispose();
    vaccineNameController.dispose();
    noteController.dispose();
    medicineNameController.dispose();
    dosageController.dispose();
    problemNameController.dispose();
    treatmentController.dispose();
    allergenController.dispose();
    reactionController.dispose();
    bpController.dispose();
    weightController.dispose();
    heightController.dispose();
    procedureController.dispose();
    surgicalDateController.dispose();
    infectionTypeController.dispose();
    infectionDateController.dispose();
    infectionNotesController.dispose();
    super.onClose();
  }
}