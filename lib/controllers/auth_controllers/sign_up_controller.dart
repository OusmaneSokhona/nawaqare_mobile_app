import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:patient_app/controllers/auth_controllers/sign_in_controller.dart';
import 'package:patient_app/controllers/patient_controllers/home_controller.dart';
import 'package:patient_app/utils/api_urls.dart';
import 'package:patient_app/utils/locat_storage.dart';
import '../../../screens/auth_screens/sign_in_screen.dart';
import '../../../widgets/validation_check_list.dart';
import '../../services/api_service.dart';
import '../../utils/app_strings.dart';

class SignUpController extends GetxController {
  final ApiService _apiService = ApiService();
  RxString type = "patient".obs;
  SignInController signInController = Get.put(SignInController());
  HomeController homeController = Get.put(HomeController());
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController bmiController = TextEditingController();
  TextEditingController bloodPressureController = TextEditingController();
  TextEditingController heartRateController = TextEditingController();
  TextEditingController idNumberController = TextEditingController();
  TextEditingController clinicAddressController = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController placeOfPracticeController = TextEditingController();
  TextEditingController yearOfWorkController = TextEditingController();
  TextEditingController registrationIdController = TextEditingController();
  TextEditingController pharmacyAddressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController areaLocalityController = TextEditingController();
  TextEditingController licenseNumberController = TextEditingController();
  TextEditingController issuingAuthorityController = TextEditingController();
  TextEditingController buisnessRegNoController = TextEditingController();
  TextEditingController registeredNameController = TextEditingController();
  RxBool passwordVisibility = false.obs;
  RxBool isPasswordActive = false.obs;
  RxBool isVerifiedEmail = false.obs;
  RxBool isVerifiedPhone = false.obs;
  RxBool isRegisteredProfessional = false.obs;
  final RxString currentPassword = ''.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(() {
      if (isVerifiedEmail.value) {
        isVerifiedEmail.value = false;
      }
    });
    phoneNumberController.addListener(() {
      if (isVerifiedPhone.value) {
        isVerifiedPhone.value = false;
      }
    });
  }

  bool get hasMinLength => currentPassword.value.length >= 8;
  bool get hasUppercase => currentPassword.value.contains(RegExp(r'[A-Z]'));
  bool get hasDigit => currentPassword.value.contains(RegExp(r'[0-9]'));
  bool get hasSpecialChar =>
      currentPassword.value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  void toggleVisibility() {
    passwordVisibility.value = !passwordVisibility.value;
  }

  bool isPasswordValid() {
    return hasMinLength && hasUppercase && hasDigit && hasSpecialChar;
  }
  final TextEditingController confirmPasswordController = TextEditingController();

  RxBool isConfirmPasswordVisible = false.obs;

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  List<ValidationRule> getValidationRules() {
    return [
      ValidationRule(text: AppStrings.atLeast8Chars.tr, isValid: hasMinLength),
      ValidationRule(text: AppStrings.atLeastOneUpper.tr, isValid: hasUppercase),
      ValidationRule(text: AppStrings.atLeastOneNumber.tr, isValid: hasDigit),
      ValidationRule(text: AppStrings.atLeastOneSpecial.tr, isValid: hasSpecialChar),
    ];
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.password.tr;
    }
    if (!isPasswordValid()) {
      return AppStrings.incompleteCodeMsg.tr;
    }
    return null;
  }

  RxBool hasPasswordInteracted = false.obs;

  void setPasswordActive(bool isActive) {
    isPasswordActive.value = isActive;
    if (isActive || currentPassword.value.isNotEmpty) {
      hasPasswordInteracted.value = true;
    }
  }

  void markPasswordInteracted() {
    hasPasswordInteracted.value = true;
  }

  final int _initialTime = 60;
  RxInt timerCount = 60.obs;
  RxBool isTimerActive = true.obs;
  Timer? timer;

  void startTimer() {
    timerCount.value = _initialTime;
    isTimerActive.value = true;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerCount.value > 0) {
        timerCount.value--;
      } else {
        timer.cancel();
        isTimerActive.value = false;
      }
    });
  }

  final List<TextEditingController> controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  final RxList<String> _currentCode = List.filled(6, '').obs;

  String get completeCode => _currentCode.join();
  final RxBool isCodeComplete = false.obs;

  void handleCodeChange(int index, String value) {
    if (value.isNotEmpty) {
      _currentCode[index] = value;
      isCodeComplete.value = completeCode.length == 6;
      if (index < controllers.length - 1) {
        FocusScope.of(Get.context!).requestFocus(focusNodes[index + 1]);
      } else {
        focusNodes[index].unfocus();
      }
    } else {
      _currentCode[index] = '';
      isCodeComplete.value = false;
      if (index > 0) {
        controllers[index].clear();
        FocusScope.of(Get.context!).requestFocus(focusNodes[index - 1]);
      }
    }
  }

  void completeCodeVerification() {
    if (completeCode.length == 6) {
      print('Verification Code Ready: $completeCode');
    } else {
      Get.snackbar(AppStrings.incompleteCode.tr, AppStrings.incompleteCodeMsg.tr, snackPosition: SnackPosition.BOTTOM);
    }
  }

  void clearAllFields() {
    for (var controller in controllers) {
      controller.clear();
    }
    _currentCode.value = List.filled(6, '');
    isCodeComplete.value = false;
    if (Get.context != null) {
      FocusScope.of(Get.context!).requestFocus(focusNodes[0]);
    }
  }

  String formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  TextEditingController dateController = TextEditingController();
  Rxn<File> pickedImage = Rxn<File>();
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      pickedImage.value = File(image.path);
    }
  }

  void showImageSourceOptions() {
    Get.bottomSheet(
      SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(AppStrings.tapToSelectNew.tr),
              onTap: () {
                pickImage(ImageSource.gallery);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () {
                pickImage(ImageSource.camera);
                Get.back();
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Rxn<Uint8List> pickedImageBytes = Rxn<Uint8List>();
  final ImagePicker webPicker = ImagePicker();

  Future<void> webPickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      final Uint8List bytes = await image.readAsBytes();
      pickedImageBytes.value = bytes;
    }
  }

  void webshowImageSourceOptions() {
    Get.bottomSheet(
      SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                pickImage(ImageSource.gallery);
                Get.back();
              },
            ),
            if (!kIsWeb)
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  pickImage(ImageSource.camera);
                  Get.back();
                },
              ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
RxString isEmailValid="".obs;
RxString isPhoneValid="".obs;
  final Rx<DateTime?> _selectedDate = Rx<DateTime?>(DateTime(2000));
  final Rx<DateTime?> _registrationDate = Rx<DateTime?>(DateTime.now());
  final Rx<DateTime?> _issueDate = Rx<DateTime?>(DateTime.now());
  final Rx<DateTime?> _expiryDate = Rx<DateTime?>(DateTime.now());

  DateTime? get selectedDate => _selectedDate.value;
  DateTime? get dateOfRegistration => _registrationDate.value;
  DateTime? get issueDate => _issueDate.value;
  DateTime? get expiryDate => _expiryDate.value;

  String get formattedDate {
    if (_selectedDate.value == null) return AppStrings.dob.tr;
    final date = _selectedDate.value!;
    return '${date.day}/${date.month}/${date.year}';
  }

  void updateDate(DateTime? newDate) => _selectedDate.value = newDate;
  void updateRegistrationDate(DateTime? newDate) => _registrationDate.value = newDate;
  void updateIssueDate(DateTime? newDate) => _issueDate.value = newDate;
  void updateExpiryDate(DateTime? newDate) => _expiryDate.value = newDate;

  final List<String> genderList = ['Male', 'Female'];
  final List<String> countryList = [
    'Afghanistan', 'Albania', 'Algeria', 'Andorra', 'Angola', 'Antigua and Barbuda',
    'Argentina', 'Armenia', 'Australia', 'Austria', 'Azerbaijan', 'Bahamas',
    'Bahrain', 'Bangladesh', 'Barbados', 'Belarus', 'Belgium', 'Belize', 'Benin',
    'Bhutan', 'Bolivia', 'Bosnia and Herzegovina', 'Botswana', 'Brazil', 'Brunei',
    'Bulgaria', 'Burkina Faso', 'Burundi', 'Cabo Verde', 'Cambodia', 'Cameroon',
    'Canada', 'Central African Republic', 'Chad', 'Chile', 'China', 'Colombia',
    'Comoros', 'Congo', 'Costa Rica', 'Croatia', 'Cuba', 'Cyprus', 'Czech Republic',
    'Democratic Republic of the Congo', 'Denmark', 'Djibouti', 'Dominica',
    'Dominican Republic', 'Ecuador', 'Egypt', 'El Salvador', 'Equatorial Guinea',
    'Eritrea', 'Estonia', 'Eswatini', 'Ethiopia', 'Fiji', 'Finland', 'France',
    'Gabon', 'Gambia', 'Georgia', 'Germany', 'Ghana', 'Greece', 'Grenada',
    'Guatemala', 'Guinea', 'Guinea-Bissau', 'Guyana', 'Haiti', 'Honduras',
    'Hungary', 'Iceland', 'India', 'Indonesia', 'Iran', 'Iraq', 'Ireland',
    'Israel', 'Italy', 'Jamaica', 'Japan', 'Jordan', 'Kazakhstan', 'Kenya',
    'Kiribati', 'Kuwait', 'Kyrgyzstan', 'Laos', 'Latvia', 'Lebanon', 'Lesotho',
    'Liberia', 'Libya', 'Liechtenstein', 'Lithuania', 'Luxembourg', 'Madagascar',
    'Malawi', 'Malaysia', 'Maldives', 'Mali', 'Malta', 'Marshall Islands',
    'Mauritania', 'Mauritius', 'Mexico', 'Micronesia', 'Moldova', 'Monaco',
    'Mongolia', 'Montenegro', 'Morocco', 'Mozambique', 'Myanmar', 'Namibia',
    'Nauru', 'Nepal', 'Netherlands', 'New Zealand', 'Nicaragua', 'Niger',
    'Nigeria', 'North Korea', 'North Macedonia', 'Norway', 'Oman', 'Pakistan',
    'Palau', 'Palestine', 'Panama', 'Papua New Guinea', 'Paraguay', 'Peru',
    'Philippines', 'Poland', 'Portugal', 'Qatar', 'Romania', 'Russia', 'Rwanda',
    'Saint Kitts and Nevis', 'Saint Lucia', 'Saint Vincent and the Grenadines',
    'Samoa', 'San Marino', 'Sao Tome and Principe', 'Saudi Arabia', 'Senegal',
    'Serbia', 'Seychelles', 'Sierra Leone', 'Singapore', 'Slovakia', 'Slovenia',
    'Solomon Islands', 'Somalia', 'South Africa', 'South Korea', 'South Sudan',
    'Spain', 'Sri Lanka', 'Sudan', 'Suriname', 'Sweden', 'Switzerland', 'Syria',
    'Taiwan', 'Tajikistan', 'Tanzania', 'Thailand', 'Timor-Leste', 'Togo',
    'Tonga', 'Trinidad and Tobago', 'Tunisia', 'Turkey', 'Turkmenistan',
    'Tuvalu', 'Uganda', 'Ukraine', 'United Arab Emirates', 'United Kingdom',
    'United States', 'Uruguay', 'Uzbekistan', 'Vanuatu', 'Vatican City',
    'Venezuela', 'Vietnam', 'Yemen', 'Zambia', 'Zimbabwe'
  ];

  final List<String> religionList = [
    'Agnosticism', 'Atheism', 'Baha\'i', 'Buddhism', 'Cao Dai', 'Chinese Folk Religion',
    'Christianity', 'Confucianism', 'Daoism', 'Ethnic Religions', 'Hinduism', 'Islam',
    'Jainism', 'Judaism', 'Mandaeism', 'New Religion', 'Paganism', 'Rastafari',
    'Satanism', 'Shinto', 'Sikhism', 'Spiritism', 'Tenrikyo', 'Unitarian Universalism',
    'Zoroastrianism', 'Other'
  ];
  final List<String> departmentList = ['Medical', 'Engineering', 'Arts', 'Business', 'Science'];

  final selectedGender = Rx<String?>('Female');
  final selectedCountry = Rx<String?>('Pakistan');
  final selectedReligion = Rx<String?>('Islam');
  final selectedDepartment = Rx<String?>('Medical');

  void updateSelectedGender(String? newValue) => selectedGender.value = newValue;
  void updateSelectedCountry(String? newValue) => selectedCountry.value = newValue;
  void updateSelectedReligion(String? newValue) => selectedReligion.value = newValue;
  void updateSelectedDepartment(String? newValue) => selectedDepartment.value = newValue;

  final selectedFileName = Rx<String?>(null);
  final selectedFileIdCard = Rx<String?>(null);
  final selectedFilePassport = Rx<String?>(null);
  final selectedFileMedicalLicense = Rx<String?>(null);
  final selectedFileDiploma = Rx<String?>(null);
  final selectedFileInsuranceProof = Rx<String?>(null);
  final selectedFileCnpd = Rx<String?>(null);
  final selectedFileBankVerification = Rx<String?>(null);
  final selectedFileBankPaymentAuthorization = Rx<String?>(null);
  final selectedLicenseCertificate = Rx<String?>(null);
  final selectedTaxClearance = Rx<String?>(null);
  final selectedNocCertificate = Rx<String?>(null);
  final selectedPharmacyBankVerificationLetter = Rx<String?>(null);
  final selectedPharmacyBankPaymentAuthorization = Rx<String?>(null);

  void pickFile(Rx<String?> file) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpeg', 'jpg'],
    );
    if (result != null && result.files.single.path != null) {
      file.value = result.files.single.path!;
    }
  }
  // In SignUpController.dart
  Future<bool> pickFileNew(Rx<String?> file) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result != null) {
        if (kIsWeb) {
          // For web platform
          final bytes = result.files.first.bytes;
          final fileName = result.files.first.name;
          file.value = fileName;
          // Store bytes for web upload
          print("File selected on web: $fileName");
          Get.snackbar(
            "Success",
            "File selected: $fileName",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          return true;
        } else {
          // For mobile platforms
          if (result.files.single.path != null) {
            file.value = result.files.single.path!;
            print("File selected: ${file.value}");
            Get.snackbar(
              "Success",
              "File selected: ${result.files.single.name}",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      print("Error picking file: $e");
      Get.snackbar(
        "Error",
        "Failed to pick file: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }
  void moveToSignInScreen() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    phoneNumberController.clear();
    for (var controller in controllers) {
      controller.clear();
    }
    Get.to(SignInScreen());
  }

  final List<String> medicalSpecialityList = ['Cardiology', 'Dermatology', 'Neurology', 'Oncology', 'Pediatrics', 'Gastroenterology', 'Orthopedics', 'Ophthalmology', 'Pulmonology', 'Endocrinology', 'Nephrology'];
  RxString selectedSpecialist = "Cardiology".obs;
  void updateSpecialization(String? newValue) => selectedSpecialist.value = newValue!;

  TextEditingController videoConsultationFeeController = TextEditingController();
  TextEditingController inPersonConsultationFeeController = TextEditingController();

  final List<String> feeList = ['\$25/ 30 mint45', '\$50/ 60 mint75', '\$125/ 90 mint'];
  RxString selectedFee = "\$25/ 30 mint45".obs;
  void updateFee(String? newValue) => selectedFee.value = newValue!;

  final isPersonalDataChecked = false.obs;
  final isSubmissionConsentChecked = false.obs;

  void togglePersonalData(bool? value) => isPersonalDataChecked.value = value ?? false;
  void toggleSubmissionConsent(bool? value) => isSubmissionConsentChecked.value = value ?? false;

  @override
  void onClose() {
    timer?.cancel();
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    dateController.dispose();
    videoConsultationFeeController.dispose();
    inPersonConsultationFeeController.dispose();
    for (var controller in controllers) controller.dispose();
    for (var node in focusNodes) node.dispose();
    super.onClose();
  }

  RxBool isLoading = false.obs;

  Future<bool> registerUser() async {
    try {
      isLoading.value = true;
      final Map<String, dynamic> signupData = {
        "fullName": nameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text,
        "phoneNumber": phoneNumberController.text.trim(),
        "role": type.value,
      };
      final response = await _apiService.post(ApiUrls.signUpUrl, data: signupData);
      isLoading.value = false;
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Registration Response: ${response.data}");
        Get.snackbar("Success", "Account created successfully", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        LocalStorageUtils.setToken(response.data["token"]);
        return true;
      }
      return false;
    } catch (e) {
      print("Error during registration: $e");
      isLoading.value = false;
      _handleError(e);
      return false;
    }
  }

  void safeBack() {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    if (Get.isDialogOpen ?? false) Get.back();
    Get.back();
  }

  Future<bool> sendEmailOtp() async {
    try {
      isLoading.value = true;
      final response = await _apiService.post(ApiUrls.sendEmailOtpUrl, data: {"email": emailController.text.trim()});
      isLoading.value = false;
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "OTP sent to your email", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        startTimer();
        return true;
      }
      return false;
    } catch (e) {
      isLoading.value = false;
      _handleError(e);
      return false;
    }
  }

  Future<bool> verifyEmailOtp() async {
    try {
      isLoading.value = true;
      final response = await _apiService.post(ApiUrls.verifyEmailOtpUrl, data: {"email": emailController.text.trim(), "otp": completeCode});
      isLoading.value = false;
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Email verified successfully", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        isVerifiedEmail.value = true;
        return true;
      }
      return false;
    } catch (e) {
      isLoading.value = false;
      _handleError(e);
      return false;
    }
  }

  Future<bool> sendPhoneOtp() async {
    try {
      isLoading.value = true;
      final response = await _apiService.post(ApiUrls.sendPhoneOtpUrl, data: {"phoneNumber": phoneNumberController.text.trim()});
      isLoading.value = false;
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Phone OTP Response: ${response.data}");
        Get.snackbar("Success", "OTP sent to your phone number", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        startTimer();
        return true;
      }
      return false;
    } catch (e) {
      isLoading.value = false;
      _handleError(e);
      return false;
    }
  }

  Future<bool> verifyPhoneOtp() async {
    try {
      isLoading.value = true;
      final response = await _apiService.post(ApiUrls.verifyPhoneOtpUrl, data: {"phoneNumber": phoneNumberController.text.trim(), "otp": completeCode});
      isLoading.value = false;
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Phone number verified successfully", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        isVerifiedPhone.value = true;
        return true;
      }
      return false;
    } catch (e) {
      isLoading.value = false;
      _handleError(e);
      return false;
    }
  }

  Future<bool> updatePatientProfile() async {
    try {
      isLoading.value = true;
      Map<String, dynamic> data = {
        "fullName": nameController.text.trim(),
        "phoneNumber": phoneNumberController.text.trim(),
        "email": emailController.text.trim(),
        "dob": _selectedDate.value?.toIso8601String(),
        "gender": selectedGender.value?.toLowerCase(),
        "country": selectedCountry.value,
        "religion": selectedReligion.value,
        "address": addressController.text.trim(),
        "height": heightController.text.trim(),
        "weight": weightController.text.trim(),
        "bmi": double.tryParse(bmiController.text.trim()),
        "bloodPressure": bloodPressureController.text.trim(),
        "heartRate": heartRateController.text.trim(),
      };

      FormData formData = FormData.fromMap({});
      data.forEach((key, value) {
        if (value != null) {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });

      if (pickedImage.value != null) {
        formData.files.add(MapEntry(
          'profileImage',
          await MultipartFile.fromFile(pickedImage.value!.path),
        ));
      }
      if (selectedFileName.value != null) {
        formData.files.add(MapEntry(
          'reports',
          await MultipartFile.fromFile(selectedFileName.value!),
        ));
      }

      final response = await _apiService.put(ApiUrls.updateProfileUrl, data: formData);
      isLoading.value = false;
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Patient profile Created", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        return true;
      }
      return false;
    } catch (e) {
      isLoading.value = false;
      print("Error updating patient profile: $e");
      _handleError(e);
      return false;
    }
  }

  Future<bool> updateDoctorProfile() async {
    try {
      isLoading.value = true;

      FormData formData = FormData.fromMap({
        "fullName": nameController.text.trim(),
        "phoneNumber": phoneNumberController.text.trim(),
        "email": emailController.text.trim(),
        "dob": _selectedDate.value?.toIso8601String(),
        "gender": selectedGender.value?.toLowerCase(),
        "nationality": selectedCountry.value,
        "idNumber": idNumberController.text.trim(),
        "clinicAddress": clinicAddressController.text.trim(),
        "aboutMe": aboutMeController.text.trim(),
        "experience": experienceController.text.trim().isNotEmpty ? int.tryParse(experienceController.text.trim()) : null,
        "dateOfRegistration": _registrationDate.value?.toIso8601String(),
        "placeOfPractice": placeOfPracticeController.text.trim(),
        "year": yearOfWorkController.text.trim().isNotEmpty ? int.tryParse(yearOfWorkController.text.trim()) : null,
        "country": selectedCountry.value,
        "ratings": "0"
      });

      // Add fee fields separately
      if (videoConsultationFeeController.text.trim().isNotEmpty) {
        formData.fields.add(MapEntry(
          "fee[videoconsultation]",
          videoConsultationFeeController.text.trim(),
        ));
      }
      if (inPersonConsultationFeeController.text.trim().isNotEmpty) {
        formData.fields.add(MapEntry(
          "fee[inpersonconsultation]",
          inPersonConsultationFeeController.text.trim(),
        ));
      }

      if (pickedImage.value != null) {
        formData.files.add(MapEntry(
          'profileImage',
          await MultipartFile.fromFile(pickedImage.value!.path, filename: 'profileImage.jpg'),
        ));
      }
      if (selectedFileIdCard.value != null && selectedFileIdCard.value!.isNotEmpty) {
        formData.files.add(MapEntry(
          'nationalIdentityDocument',
          await MultipartFile.fromFile(selectedFileIdCard.value!, filename: 'nationalIdentityDocument.jpg'),
        ));
      }
      if (selectedFilePassport.value != null && selectedFilePassport.value!.isNotEmpty) {
        formData.files.add(MapEntry(
          'passportOrIdFront',
          await MultipartFile.fromFile(selectedFilePassport.value!, filename: 'passportOrIdFront.jpg'),
        ));
      }
      if (selectedFileMedicalLicense.value != null && selectedFileMedicalLicense.value!.isNotEmpty) {
        formData.files.add(MapEntry(
          'medicalLicence',
          await MultipartFile.fromFile(selectedFileMedicalLicense.value!, filename: 'medicalLicence.jpg'),
        ));
      }
      if (selectedFileDiploma.value != null && selectedFileDiploma.value!.isNotEmpty) {
        formData.files.add(MapEntry(
          'certification',
          await MultipartFile.fromFile(selectedFileDiploma.value!, filename: 'certification.jpg'),
        ));
      }
      if (selectedFileInsuranceProof.value != null && selectedFileInsuranceProof.value!.isNotEmpty) {
        formData.files.add(MapEntry(
          'liabilityInsuranceProof',
          await MultipartFile.fromFile(selectedFileInsuranceProof.value!, filename: 'liabilityInsuranceProof.jpg'),
        ));
      }
      if (selectedFileCnpd.value != null && selectedFileCnpd.value!.isNotEmpty) {
        formData.files.add(MapEntry(
          'cnpd',
          await MultipartFile.fromFile(selectedFileCnpd.value!, filename: 'cnpd.jpg'),
        ));
      }
      if (selectedFileBankVerification.value != null && selectedFileBankVerification.value!.isNotEmpty) {
        formData.files.add(MapEntry(
          'bankVerificationLetter',
          await MultipartFile.fromFile(selectedFileBankVerification.value!, filename: 'bankVerificationLetter.jpg'),
        ));
      }
      if (selectedFileBankPaymentAuthorization.value != null && selectedFileBankPaymentAuthorization.value!.isNotEmpty) {
        formData.files.add(MapEntry(
          'paymentAuthorization',
          await MultipartFile.fromFile(selectedFileBankPaymentAuthorization.value!, filename: 'paymentAuthorization.jpg'),
        ));
      }

      print("Sending Doctor Data: ${formData.fields.map((e) => '${e.key}: ${e.value}').toList()}");
      print("Sending Doctor Files: ${formData.files.length} files");

      final response = await _apiService.put(ApiUrls.updateProfileUrl, data: formData);
      isLoading.value = false;

      print("Doctor Profile Update Response Status: ${response.statusCode}");
      print("Doctor Profile Update Response Data: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Doctor profile updated", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        return true;
      }
      return false;
    } catch (e) {
      print("Error updating doctor profile: $e");
      isLoading.value = false;
      _handleError(e);
      return false;
    }
  }
  Future<bool> updatePharmacyProfile() async {
    try {
      isLoading.value = true;

      FormData formData = FormData.fromMap({
        "fullName": nameController.text.trim(),
        "email": emailController.text.trim(),
        "registrationID": registrationIdController.text.trim(),
        "phoneNumber": phoneNumberController.text.trim(),
        "address": pharmacyAddressController.text.trim(),
        "city": cityController.text.trim(),
        "area": areaLocalityController.text.trim(),
        "operatingHours": "", // Add this if you have a field for it
        "licenseNumber": licenseNumberController.text.trim(),
        "issuingAuthority": issuingAuthorityController.text.trim(),
        "issueDate": _issueDate.value?.toIso8601String(),
        "expiryDate": _expiryDate.value?.toIso8601String(),
        "businessRegistrationNo": buisnessRegNoController.text.trim(),
        "registerName": registeredNameController.text.trim(),
      });

      if (pickedImage.value != null) {
        formData.files.add(MapEntry(
          'profileImage',
          await MultipartFile.fromFile(pickedImage.value!.path, filename: 'profileImage.jpg'),
        ));
      }
      if (selectedTaxClearance.value != null && selectedTaxClearance.value!.isNotEmpty) {
        formData.files.add(MapEntry(
          'taxCertificate',
          await MultipartFile.fromFile(selectedTaxClearance.value!, filename: 'taxCertificate.jpg'),
        ));
      }
      if (selectedNocCertificate.value != null && selectedNocCertificate.value!.isNotEmpty) {
        formData.files.add(MapEntry(
          'nocCertificate',
          await MultipartFile.fromFile(selectedNocCertificate.value!, filename: 'nocCertificate.jpg'),
        ));
      }
      if (selectedPharmacyBankVerificationLetter.value != null && selectedPharmacyBankVerificationLetter.value!.isNotEmpty) {
        formData.files.add(MapEntry(
          'paymentBankVerificationLetter',
          await MultipartFile.fromFile(selectedPharmacyBankVerificationLetter.value!, filename: 'paymentBankVerificationLetter.jpg'),
        ));
      }
      if (selectedPharmacyBankPaymentAuthorization.value != null && selectedPharmacyBankPaymentAuthorization.value!.isNotEmpty) {
        formData.files.add(MapEntry(
          'paymentAuthorization',
          await MultipartFile.fromFile(selectedPharmacyBankPaymentAuthorization.value!, filename: 'paymentAuthorization.jpg'),
        ));
      }

      print("Sending Pharmacy Data: ${formData.fields.map((e) => '${e.key}: ${e.value}').toList()}");
      print("Sending Pharmacy Files: ${formData.files.length} files");

      final response = await _apiService.put(ApiUrls.updateProfileUrl, data: formData);
      isLoading.value = false;

      print("Pharmacy Profile Update Response Status: ${response.statusCode}");
      print("Pharmacy Profile Update Response Data: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Pharmacy profile updated", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        return true;
      }
      return false;
    } catch (e) {
      isLoading.value = false;
      _handleError(e);
      return false;
    }
  }
  Future<bool> editPersonalInfoPatient() async {
    try {
      isLoading.value = true;
      Map<String, dynamic> data = {
        "dob": _selectedDate.value?.toIso8601String(),
        "gender": selectedGender.value?.toLowerCase(),
        "country": selectedCountry.value,
        "religion": selectedReligion.value,
        "address": addressController.text.trim(),
      };

      FormData formData = FormData.fromMap({});
      data.forEach((key, value) {
        if (value != null) {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });

      if (pickedImage.value != null) {
        formData.files.add(MapEntry(
          'profileImage',
          await MultipartFile.fromFile(pickedImage.value!.path),
        ));
      }
      final response = await _apiService.put(ApiUrls.updateProfileUrl, data: formData);
      isLoading.value = false;
      if (response.statusCode == 200 || response.statusCode == 201) {
        homeController.loadUserDataSecondTime();
        Get.back();
        Get.snackbar("Success", "Patient profile Updated", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        return true;
      }
      return false;
    } catch (e) {
      isLoading.value = false;
      print("Error updating patient profile: $e");
      _handleError(e);
      return false;
    }
  }
  Future<bool> editMedicalVitals() async {
    try {
      isLoading.value = true;
      Map<String, dynamic> data = {
        "height": heightController.text.trim(),
        "weight": weightController.text.trim(),
        "bmi": double.tryParse(bmiController.text.trim()),
        "bloodPressure": bloodPressureController.text.trim(),
        "heartRate": heartRateController.text.trim(),
      };

      FormData formData = FormData.fromMap({});
      data.forEach((key, value) {
        if (value != null) {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });

      final response = await _apiService.put(ApiUrls.updateProfileUrl, data: formData);
      isLoading.value = false;
      if (response.statusCode == 200 || response.statusCode == 201) {
        homeController.loadUserDataSecondTime();
        Get.back();
        Get.snackbar("Success", "Details Updated", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        return true;
      }
      return false;
    } catch (e) {
      isLoading.value = false;
      print("Error updating patient profile: $e");
      _handleError(e);
      return false;
    }
  }
  Future<bool> uploadDocuments() async {
    try {
      isLoading.value = true;

      FormData formData = FormData.fromMap({});
      if (selectedFileName.value != null) {
        formData.files.add(MapEntry(
          'reports',
          await MultipartFile.fromFile(selectedFileName.value!),
        ));
      }

      final response = await _apiService.put(ApiUrls.updateProfileUrl, data: formData);
      isLoading.value = false;
      if (response.statusCode == 200 || response.statusCode == 201) {
        homeController.loadUserDataSecondTime();
        Get.back();
        Get.snackbar("Success", "Document Added", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        return true;
      }
      return false;
    } catch (e) {
      isLoading.value = false;
      print("Error updating patient profile: $e");
      _handleError(e);
      return false;
    }
  }
  void _handleError(dynamic e) {
    String errorMessage = "An unexpected error occurred";
    if (e is DioException) {
      if (e.response != null && e.response!.data != null) {
        if (e.response!.data is Map) {
          errorMessage = e.response!.data["message"] ?? "Server Error";
        } else {
          errorMessage = e.response!.data.toString();
        }
      } else {
        errorMessage = "No response from server";
      }
    } else {
      errorMessage = e.toString();
    }
    Get.snackbar("Error", errorMessage, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
  }
  void clearAllControllersAndFields() {
    nameController.clear();
    emailController.clear();
    confirmPasswordController.clear();
    isConfirmPasswordVisible.value = false;
    phoneNumberController.clear();
    passwordController.clear();
    addressController.clear();
    heightController.clear();
    weightController.clear();
    bmiController.clear();
    bloodPressureController.clear();
    heartRateController.clear();
    idNumberController.clear();
    clinicAddressController.clear();
    aboutMeController.clear();
    experienceController.clear();
    placeOfPracticeController.clear();
    yearOfWorkController.clear();
    registrationIdController.clear();
    pharmacyAddressController.clear();
    cityController.clear();
    areaLocalityController.clear();
    licenseNumberController.clear();
    issuingAuthorityController.clear();
    buisnessRegNoController.clear();
    registeredNameController.clear();
    videoConsultationFeeController.clear();
    inPersonConsultationFeeController.clear();

    pickedImage.value = null;
    pickedImageBytes.value = null;

    selectedFileName.value = null;
    selectedFileIdCard.value = null;
    selectedFilePassport.value = null;
    selectedFileMedicalLicense.value = null;
    selectedFileDiploma.value = null;
    selectedFileInsuranceProof.value = null;
    selectedFileCnpd.value = null;
    selectedFileBankVerification.value = null;
    selectedFileBankPaymentAuthorization.value = null;
    selectedLicenseCertificate.value = null;
    selectedTaxClearance.value = null;
    selectedNocCertificate.value = null;
    selectedPharmacyBankVerificationLetter.value = null;
    selectedPharmacyBankPaymentAuthorization.value = null;

    _selectedDate.value = DateTime.now();
    _registrationDate.value = DateTime.now();
    _issueDate.value = DateTime.now();
    _expiryDate.value = DateTime.now();

    isVerifiedEmail.value = false;
    isVerifiedPhone.value = false;
  }

  void calculateAndUpdateBMI(String heightStr, String weightStr) {
    try {
      double height = double.tryParse(heightStr.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
      double weight = double.tryParse(weightStr.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;

      if (height > 100) { // Assuming cm if > 100
        height = height / 100;
      }

      if (height > 0 && weight > 0) {
        double bmi = weight / (height * height);
        bmiController.text = bmi.toStringAsFixed(1);
      }

      update();

    } catch (e) {
      print('Error calculating BMI: $e');
      update();
    }
  }

  String getBMICategory() {
    try {
      double bmi = double.tryParse(bmiController.text) ?? 0;

      if (bmi == 0) return '';
      if (bmi < 18.5) return 'Underweight';
      if (bmi >= 18.5 && bmi < 25) return 'Normal';
      if (bmi >= 25 && bmi < 30) return 'Overweight';
      return 'Obese';
    } catch (e) {
      return '';
    }
  }

}