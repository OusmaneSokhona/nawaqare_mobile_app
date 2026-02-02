import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/models/allergy_model.dart';
import 'package:patient_app/models/medical_history_model.dart';
import 'package:patient_app/models/vaccination_history_model.dart';
import 'package:patient_app/utils/app_bindings.dart';
import 'package:patient_app/utils/locat_storage.dart';
import '../../models/profile_models.dart';
import '../../models/user_model.dart';
import '../../screens/patient_screens/profile_screens/edit_medical_vitals.dart';
import '../../screens/patient_screens/profile_screens/edit_personal_info.dart';
import '../../utils/app_strings.dart';

class ProfileController extends GetxController {
  ScrollController scrollController = ScrollController();
  RxDouble scrollValue = 0.0.obs;

  void scrollChange() {
    scrollController.addListener(() {
      scrollValue.value = scrollController.offset;
      print(scrollValue);
    });
  }

  RxString type = "Personal Info".obs;
  final Rx<User> user =
      User(
        name: 'User',
        title: 'user',
        lastUpdate: '12/Sep/2025',
        patientId: 'PT-00923',
        country: 'Country',
        email: 'abc@gmail.com',
        phone: '+1 234 567 890',
        address: '32 Examaple St',
        profileImageUrl: 'assets/demo_images/doctor_1.png',
      ).obs;

  final Rx<Vitals> medicalVitals =
      Vitals(
        heightCm: 165.0,
        weightKg: 60.0,
        bloodPressure: '120/80 mmHg',
        heartRateBpm: 72,
      ).obs;

  final RxList<Document> documents =
      <Document>[
        Document(type: 'Blood Test', date: 'Jan 2025'),
        Document(type: 'Chest X-ray', date: 'Jan 2025'),
        Document(type: 'Blood Test', date: 'Jan 2025'),
      ].obs;

  void editPersonalInfo(UserModel user) {
    Get.to(EditPersonalInfo(user: user,),binding: AppBinding());
  }

  void editMedicalVitals() {
    Get.to(EditMedicalVitals(),binding: AppBinding());
  }

  void uploadNewDocument() {
    Get.snackbar('Action', 'Opening Document Uploader');
  }

  void handleHealthSpaceTap(Widget route) {
    Get.to(route);
  }

  List<AllergyData> allergiesData = [
    AllergyData(
      medication: 'Penicillin',
      reaction: 'Rash',
      severity: 'Mild',
      dateIdentified: '06/sep/2025',
      documentFileName: 'Skin_Test_2024.pdf',
      note: 'Avoid antibiotics in same family',
      status: 'active',
    ),
    AllergyData(
      medication: 'Food',
      reaction: 'Rash',
      severity: 'Mild',
      dateIdentified: '06/sep/2025',
      documentFileName: 'Skin_Test_2024.pdf',
      note: 'Avoid antibiotics in same family',
      status: 'resolved',
    ),
    AllergyData(
      medication: 'Environmental',
      reaction: 'Rash',
      severity: 'Mild',
      dateIdentified: '06/sep/2025',
      documentFileName: 'Skin_Test_2024.pdf',
      note: 'Avoid antibiotics in same family',
      status: 'unConfirmed',
    ),
  ];
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

  RxString selectedBloodType = "O+".obs;
  final List<String> bloodList = [
    "O+",
    "O-",
    "A+",
    "A-",
    "B+",
    "B-",
    "AB+",
    "AB-",
  ];
  final allowSharing = true.obs;
  final allowResearch = true.obs;
  final specialist = true.obs;
  final receiveNotifications = false.obs;
  final emergencyServices = false.obs;
  final pharmacy = false.obs;
  final accessMyData = false.obs;

  void toggleSharing(bool newValue) {
    allowSharing.value = newValue;
    debugPrint('Allow Sharing toggled to: $newValue');
  }

  void togglePharmacy(bool newValue) {
    pharmacy.value = newValue;
    debugPrint('Allow Sharing toggled to: $newValue');
  }

  void toggleEmergencyServices(bool newValue) {
    emergencyServices.value = newValue;
  }

  void toggleSpeacialist(bool newValue) {
    specialist.value = newValue;
  }

  void toggleAccessMyData(bool newValue) {
    accessMyData.value = newValue;
  }

  void toggleResearch(bool newValue) {
    allowResearch.value = newValue;
    debugPrint('Allow Research toggled to: $newValue');
  }

  void toggleNotifications(bool newValue) {
    receiveNotifications.value = newValue;
    debugPrint('Receive Notifications toggled to: $newValue');
  }

  final List<AccessRecord> records = [
    AccessRecord(
      name: 'Alexis',
      role: 'Cardiologist',
      data: 'Medical Record',
      dateTime: 'Oct 18, 2025 – 14:22',
    ),
    AccessRecord(
      name: 'Alexis',
      role: 'Cardiologist',
      data: 'Medical Record',
      dateTime: 'Oct 18, 2025 – 14:22',
    ),
    AccessRecord(
      name: 'Alexis',
      role: 'Cardiologist',
      data: 'Medical Record',
      dateTime: 'Oct 18, 2025 – 14:22',
    ),
    AccessRecord(
      name: 'Alexis',
      role: 'Cardiologist',
      data: 'Medical Record',
      dateTime: 'Oct 18, 2025 – 14:22',
    ),
  ];
  RxBool isPdf = true.obs;
  RxBool isEmail = false.obs;
  RxString dataType = "Medical Record".obs;
  List<String> dataTypeList = [
    "Medical Record",
    "Health Record",
    "Doctor Record",
  ];
  final isChecked = true.obs;

  void toggleCheck(bool? newValue) {
    if (newValue != null) {
      isChecked.value = newValue;
    }
  }

  final selectedLanguage = LocalStorageUtils.getLanguage().obs;

  void setLanguage(String? language) {
    if (language != null) {
      selectedLanguage.value = language;
      // if (selectedLanguage.value == AppStrings.english) {
      //   Get.updateLocale(const Locale('en', 'US'));
      // } else if (selectedLanguage.value == AppStrings.french) {
      //   Get.updateLocale(const Locale('fr', 'FR'));
      // }
    }
  }

  RxString historyType = "Current Medication".obs;
  List<MedicalHistoryModel> medicalHistoryList = [
    MedicalHistoryModel(
      doctor: DoctorInformation(
        name: "Dr. Maria Waston",
        image: "assets/demo_images/doctor_1.png",
        specialty: "Heart Surgeon",
        status: "Active",
      ),
      medicationName: "Amoxicillin 500mg",
      dosage: "1 tablet, twice daily after meals",
      refillLimitDate: "Refill until Oct 15,2025",
      lastUpdated: "Last updated: 12 Sept 2025",
    ),
    MedicalHistoryModel(
      doctor: DoctorInformation(
        name: "Dr. Maria Waston",
        image: "assets/demo_images/doctor_1.png",
        specialty: "Heart Surgeon",
        status: "Completed",
      ),
      medicationName: "Amoxicillin 500mg",
      dosage: "1 tablet, twice daily after meals",
      refillLimitDate: "Refill until Oct 15,2025",
      lastUpdated: "Last updated: 12 Sept 2025",
    ),
  ];
  List<VaccinationHistoryModel> vaccinationHistoryList = [
    VaccinationHistoryModel(
      vaccineName: "Influenza",
      testName: "Skin_Test_2024.pdf",
      status: "Pending",
      lastUpdated: "12/sep/2025",
    ),
    VaccinationHistoryModel(
      vaccineName: "Influenza",
      testName: "Skin_Test_2024.pdf",
      status: "Completed",
      lastUpdated: "12/sep/2025",
    ),
  ];
  List<String> medicationStatusList=["Active","Pending","Completed","Expired"];
  List<String> relationList=["Father","Mother","Son","Brother","Sister"];
  RxString medicationStatus="Active".obs;
  RxString vaccinationStatus="Active".obs;
  RxString activeRelation="Father".obs;
  final selectedSeverityFamilyHistory = Rx<String?>('Mild');
  final RxString selectedSmoking = 'Yes'.obs;
  final RxString selectedAlcohol = 'None'.obs;
  final RxString selectedActivity = 'Sedentary'.obs;
  final RxString selectedDiet = 'Balanced'.obs;
  final RxString selectedSleep = 'Good'.obs;

  final Map<String, List<String>> categories = {
    'Smoking': ['Yes', 'No', 'Occasionally'],
    'Alcohol Use': ['None', 'Occasional', 'Regular'],
    'Physical Activity': ['Sedentary', 'Moderate', 'Active'],
    'Diet Type': ['Balanced', 'High Protein', 'Vegetarian'],
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

}
