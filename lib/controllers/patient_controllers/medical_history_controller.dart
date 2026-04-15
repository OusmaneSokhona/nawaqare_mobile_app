import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:dio/dio.dart';
import '../../models/doctor_model.dart';
import '../../models/family_history_model.dart';
import '../../models/life_style_model.dart';
import '../../models/medical_history_model.dart';
import '../../models/vaccination_history_model.dart';
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
  RxList<VaccinationHistoryModel> apiVaccinationList = <VaccinationHistoryModel>[].obs;

  RxList<MedicalHistoryResponse> medicalHistoryList = <MedicalHistoryResponse>[].obs;
  RxMap<String, dynamic> medicalHistoryData = <String, dynamic>{}.obs;

  TextEditingController noteController = TextEditingController();
  RxString selectedHistoryId = ''.obs;
  RxString selectedSectionType = ''.obs;

  Future<void> fetchMedicalHistory() async {
    try {
      isLoading.value = true;
      String patientId = homeController.currentUser.value?.id ?? "";

      if (patientId.isEmpty) {
        debugPrint('Patient ID is empty');
        return;
      }

      final response = await apiService.get(
        "${ApiUrls.getMedicalHistory}$patientId",
      );

      if (response.statusCode == 200) {
        var rawData = response.data;

        if (rawData is List && rawData.isNotEmpty) {
          medicalHistoryList.assignAll(
            rawData.map((json) => MedicalHistoryResponse.fromJson(json.cast<String, dynamic>())).toList(),
          );
          if (medicalHistoryList.isNotEmpty) {
            medicalHistoryData.value = Map<String, dynamic>.from(medicalHistoryList.first.toJson());
          }
          debugPrint('Fetched ${medicalHistoryList.length} medical history records');
        } else if (rawData is Map && rawData['data'] is List) {
          List<dynamic> listData = rawData['data'];
          if (listData.isNotEmpty) {
            medicalHistoryList.assignAll(
              listData.map((json) => MedicalHistoryResponse.fromJson(json.cast<String, dynamic>())).toList(),
            );
            if (medicalHistoryList.isNotEmpty) {
              medicalHistoryData.value = Map<String, dynamic>.from(medicalHistoryList.first.toJson());
            }
          }
          debugPrint('Fetched ${medicalHistoryList.length} medical history records from data field');
        } else if (rawData is Map && rawData.containsKey('addMedications')) {
          Map<String, dynamic> castedData = Map<String, dynamic>.from(rawData);
          medicalHistoryData.value = castedData;
          MedicalHistoryResponse singleRecord = MedicalHistoryResponse.fromJson(castedData);
          medicalHistoryList.add(singleRecord);
          debugPrint('Fetched single medical history record');
        } else if (rawData is Map) {
          Map<String, dynamic> castedData = Map<String, dynamic>.from(rawData);
          medicalHistoryData.value = castedData;
          MedicalHistoryResponse singleRecord = MedicalHistoryResponse.fromJson(castedData);
          medicalHistoryList.add(singleRecord);
          debugPrint('Fetched medical history as single object');
        } else {
          debugPrint('Unexpected response format: ${rawData.runtimeType}');
        }

        if (medicalHistoryData.isNotEmpty) {
          debugPrint('Medical History Data Keys: ${medicalHistoryData.keys}');
          if (medicalHistoryData.containsKey('addMedications')) {
            debugPrint('Has Medications: ${medicalHistoryData['addMedications']}');
          }
          if (medicalHistoryData.containsKey('addProblem')) {
            debugPrint('Has Problem: ${medicalHistoryData['addProblem']}');
          }
          if (medicalHistoryData.containsKey('addAllergical')) {
            debugPrint('Has Allergies: ${medicalHistoryData['addAllergical']}');
          }
        }
      } else {
        debugPrint('Failed to fetch medical history: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Fetch Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addNote(String historyId, String sectionType) async {
    if (noteController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a note',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      String patientId = homeController.currentUser.value?.id ?? "";

      if (patientId.isEmpty) {
        Get.snackbar(
          'Error',
          'Patient ID not found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      Map<String, dynamic> requestData = {
        "patientId": patientId,
        "note": noteController.text.trim(),
      };

      final response = await apiService.patch(
        ApiUrls.addNoteApi,
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        noteController.clear();
        selectedHistoryId.value = '';
        selectedSectionType.value = '';

        Get.back();

        Get.snackbar(
          'Success',
          'Note added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        await fetchMedicalHistory();
      } else {
        String errorMessage = 'Failed to add note';
        if (response.data is Map && response.data['message'] != null) {
          errorMessage = response.data['message'];
        } else if (response.data is Map && response.data['error'] != null) {
          errorMessage = response.data['error'];
        }

        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';

      if (e.response != null) {
        if (e.response?.data is Map) {
          errorMessage = e.response?.data['message'] ??
              e.response?.data['error'] ??
              'Server error: ${e.response?.statusCode}';
        } else {
          errorMessage = 'Server error: ${e.response?.statusCode}';
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout. Please try again.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Server not responding. Please try again.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection. Please check your network.';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Note',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              16.verticalSpace,
              TextField(
                controller: noteController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Enter your note here...',
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
                  ),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          side: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: Obx(() => ElevatedButton(
                      onPressed: isLoading.value
                          ? null
                          : () => addNote(historyId, sectionType),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: isLoading.value
                          ? SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : Text(
                        'Add Note',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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

  @override
  void onInit() {
    super.onInit();
    loadDoctors();
    fetchMedicalHistory();
  }

  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  List<String> medicationStatusList = ["Active", "Stopped", "Completed"];
  List<String> vacinationStatusList = ["Pending", "Completed"];
  List<String> relationList = ["Father", "Mother", "Son", "Brother", "Sister"];

  TextEditingController medicineNameController = TextEditingController();
  TextEditingController dosageController = TextEditingController();
  TextEditingController familyConditionController = TextEditingController();
  TextEditingController familyAgeController = TextEditingController();
  TextEditingController familyNotesController = TextEditingController();
  TextEditingController vaccineNameController = TextEditingController();
  RxString medicationStatus = "Active".obs;
  RxString vaccinationStatus = "Pending".obs;
  RxString activeRelation = "Father".obs;
  RxBool hasRefill = false.obs;
  final selectedSeverityFamilyHistory = Rx<String?>('Mild');
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

  final List<String> severityList = ['Mild', 'Moderate', 'Severe'];
  final selectedFileName = Rx<String?>('No file selected');

  void pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpeg', 'jpg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      selectedFileName.value = result.files.single.name;
      selectedCertificateFile.value = File(result.files.single.path!);
    } else {
      selectedFileName.value = 'File selection cancelled';
      selectedCertificateFile.value = null;
    }
  }

  final RxList<DoctorModel> allDoctorList = <DoctorModel>[].obs;
  final Rx<DoctorModel?> selectedDoctor = Rx<DoctorModel?>(null);

  Future<void> loadDoctors() async {
    isLoading.value = true;
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
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addMedication() async {
    if (medicineNameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter medication name',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    if (dosageController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter dosage information',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;

      String doctorId = "";
      if (allDoctorList.isNotEmpty && selectedDoctor.value != null) {
        doctorId = selectedDoctor.value!.id ?? "";
      }

      Map<String, dynamic> requestData = {
        "patientId": homeController.currentUser.value?.id,
        "type": "medications",
        "data": {
          "medicineName": medicineNameController.text.trim(),
          "dosage": dosageController.text.trim(),
          "doctor": doctorId,
          "refill": hasRefill.value,
          "status": medicationStatus.value.toLowerCase(),
        }
      };
      final response = await apiService.post(
        ApiUrls.createMedicalHistory,
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        clearForm();
        fetchMedicalHistory();
        Get.back();
      } else {
        String errorMessage = 'Failed to add medication';
        if (response.data is Map && response.data['message'] != null) {
          errorMessage = response.data['message'];
        } else if (response.data is Map && response.data['error'] != null) {
          errorMessage = response.data['error'];
        }

        Get.snackbar('Error', errorMessage,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';
      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? e.response?.data['error'] ?? 'Server error: ${e.response?.statusCode}';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout. Please try again.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Server not responding. Please try again.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection. Please check your network.';
      }

      Get.snackbar('Error', errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  final Rx<DateTime?> _selectedDate = Rx<DateTime?>(DateTime.now());

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
    _selectedDate.value = newDate;
  }

  void clearForm() {
    medicineNameController.clear();
    dosageController.clear();
    hasRefill.value = false;
    medicationStatus.value = "Active";
    selectedFileName.value = 'No file selected';
    selectedCertificateFile.value = null;
  }

  void clearVaccinationForm() {
    vaccineNameController.clear();
    _selectedDate.value = DateTime.now();
    vaccinationStatus.value = "Pending";
    selectedFileName.value = 'No file selected';
    selectedCertificateFile.value = null;
  }

  Future<void> addVaccination() async {
    if (vaccineNameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter vaccination name',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    if (_selectedDate.value == null) {
      Get.snackbar('Error', 'Please select vaccination date',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;

      String patientId = homeController.currentUser.value?.id ?? "";
      if (patientId.isEmpty) {
        Get.snackbar('Error', 'Patient ID not found',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
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

        final response = await apiService.post(
          ApiUrls.createMedicalHistory,
          data: formData,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          clearVaccinationForm();
          fetchMedicalHistory();
          Get.back();
          Get.snackbar('Success', 'Vaccination added successfully',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white);
        } else {
          String errorMessage = 'Failed to add vaccination';
          if (response.data is Map) {
            errorMessage = response.data['message'] ??
                response.data['error'] ??
                'Server error: ${response.statusCode}';
          }

          Get.snackbar('Error', errorMessage,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        }
      } else {
        Map<String, dynamic> requestData = {
          "patientId": patientId,
          "type": "vaccinations",
          "data": vaccineData,
        };

        final response = await apiService.post(
          ApiUrls.createMedicalHistory,
          data: requestData,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          clearVaccinationForm();
          fetchMedicalHistory();
          Get.back();
          Get.snackbar('Success', 'Vaccination added successfully',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white);
        } else {
          String errorMessage = 'Failed to add vaccination';
          if (response.data is Map) {
            errorMessage = response.data['message'] ??
                response.data['error'] ??
                'Server error: ${response.statusCode}';
          }

          Get.snackbar('Error', errorMessage,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        }
      }
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';

      if (e.response != null) {
        if (e.response?.data is Map) {
          errorMessage = e.response?.data['message'] ??
              e.response?.data['error'] ??
              'Server error: ${e.response?.statusCode}';
        } else {
          errorMessage = 'Server error: ${e.response?.statusCode}';
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout. Please try again.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Server not responding. Please try again.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection. Please check your network.';
      }

      Get.snackbar('Error', errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
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

    int? age;
    try {
      age = int.parse(familyAgeController.text.trim());
      if (age < 0 || age > 120) {
        Get.snackbar('Error', 'Please enter a valid age (0–120)',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
    } catch (e) {
      Get.snackbar('Error', 'Age must be a number',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;

      final Map<String, dynamic> requestBody = {
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

      final response = await apiService.post(
        ApiUrls.createMedicalHistory,
        data: requestBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        clearFamilyHistoryForm();
        fetchMedicalHistory();
        Get.back();
      } else {
        String msg = response.data?['message'] ??
            response.data?['error'] ??
            'Failed to add family history';
        Get.snackbar('Error', msg,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } on DioException catch (e) {
      String errorMsg = 'Network error';
      if (e.response != null) {
        errorMsg = e.response?.data?['message'] ??
            e.response?.data?['error'] ??
            'Server error (${e.response?.statusCode})';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMsg = 'Connection timeout';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMsg = 'No internet connection';
      }
      Get.snackbar('Error', errorMsg,
          backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Unexpected error: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void clearFamilyHistoryForm() {
    familyConditionController.clear();
    familyAgeController.clear();
    familyNotesController.clear();
    activeRelation.value = relationList.first;
    selectedSeverityFamilyHistory.value = severityList.first;
  }

  Future<void> addLifestyle() async {
    try {
      isLoading.value = true;

      final Map<String, dynamic> requestBody = {
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

      final response = await apiService.post(
        ApiUrls.createMedicalHistory,
        data: requestBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchMedicalHistory();
        Get.back();
      } else {
        String errorMsg = 'Failed to save lifestyle data';
        if (response.data is Map) {
          errorMsg = response.data['message'] ?? response.data['error'] ?? errorMsg;
        }
        Get.snackbar(
          'Error',
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on DioException catch (e) {
      String msg = 'Network error occurred';
      if (e.response != null) {
        msg = e.response?.data?['message'] ??
            e.response?.data?['error'] ??
            'Server error (${e.response?.statusCode})';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        msg = 'Connection timeout';
      } else if (e.type == DioExceptionType.connectionError) {
        msg = 'No internet connection';
      }
      Get.snackbar(
        'Error',
        msg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unexpected error: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsVerified(String historyId, String type) async {
    try {
      isLoading.value = true;

      final response = await apiService.patch(
          ApiUrls.markVerified,
          data: {
            "patientId": homeController.currentUser.value?.id ?? "",
            "type": type,
          }
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Marked as verified successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        fetchMedicalHistory();
      } else {
        String errorMessage = 'Failed to mark as verified';
        if (response.data is Map) {
          errorMessage = response.data['message'] ??
              response.data['error'] ??
              'Server error: ${response.statusCode}';
        }

        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';

      if (e.response != null) {
        if (e.response?.data is Map) {
          errorMessage = e.response?.data['message'] ??
              e.response?.data['error'] ??
              'Server error: ${e.response?.statusCode}';
        } else {
          errorMessage = 'Server error: ${e.response?.statusCode}';
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout. Please try again.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Server not responding. Please try again.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection. Please check your network.';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    familyConditionController.dispose();
    familyAgeController.dispose();
    familyNotesController.dispose();
    vaccineNameController.dispose();
    noteController.dispose();
    super.onClose();
  }
}