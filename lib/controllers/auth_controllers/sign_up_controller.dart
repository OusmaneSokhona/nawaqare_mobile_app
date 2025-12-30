import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:patient_app/controllers/auth_controllers/sign_in_controller.dart';
import '../../../screens/auth_screens/sign_in_screen.dart';
import '../../../widgets/validation_check_list.dart';
import '../../utils/app_strings.dart';

class SignUpController extends GetxController {
  RxString type = "doctor".obs;
  SignInController signInController = Get.put(SignInController());
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool passwordVisibility = false.obs;
  RxBool isPasswordActive = false.obs;
  RxBool isRegisteredProfessional = false.obs;
  final RxString currentPassword = ''.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

  List<ValidationRule> getValidationRules() {
    return [
      ValidationRule(
        text: AppStrings.atLeast8Chars.tr,
        isValid: hasMinLength,
      ),
      ValidationRule(
        text: AppStrings.atLeastOneUpper.tr,
        isValid: hasUppercase,
      ),
      ValidationRule(
        text: AppStrings.atLeastOneNumber.tr,
        isValid: hasDigit,
      ),
      ValidationRule(
        text: AppStrings.atLeastOneSpecial.tr,
        isValid: hasSpecialChar,
      ),
    ];
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return
        AppStrings.password.tr;
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
        Get.snackbar(
          AppStrings.verification.tr,
          AppStrings.requestNewCode.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFF44336),
          colorText: const Color(0xFFFFFFFF),
        );
      }
    });
  }

  final List<TextEditingController> controllers = List.generate(
    6,
        (index) => TextEditingController(),
  );
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
      Get.snackbar(
        AppStrings.incompleteCode.tr,
        AppStrings.incompleteCodeMsg.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
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

  final Rx<DateTime?> _selectedDate = Rx<DateTime?>(DateTime.now());
  DateTime? get selectedDate => _selectedDate.value;

  String get formattedDate {
    if (_selectedDate.value == null) {
      return AppStrings.dob.tr;
    }
    final date = _selectedDate.value!;
    return '${date.day}/${date.month}/${date.year}';
  }

  void updateDate(DateTime? newDate) {
    _selectedDate.value = newDate;
  }

  final List<String> genderList = ['Male', 'Female', 'Other'];
  final List<String> countryList = ['Pakistan', 'India', 'USA', 'UK', 'Canada'];
  final List<String> religionList = ['Islam', 'Christianity', 'Hinduism', 'Buddhism', 'Other'];
  final List<String> departmentList = ['Medical', 'Engineering', 'Arts', 'Business', 'Science'];

  final selectedGender = Rx<String?>('Female');
  final selectedCountry = Rx<String?>('Pakistan');
  final selectedReligion = Rx<String?>('Islam');
  final selectedDepartment = Rx<String?>('Medical');

  void updateSelectedGender(String? newValue) { selectedGender.value = newValue; }
  void updateSelectedCountry(String? newValue) { selectedCountry.value = newValue; }
  void updateSelectedReligion(String? newValue) { selectedReligion.value = newValue; }
  void updateSelectedDepartment(String? newValue) { selectedDepartment.value = newValue; }

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

    if (result != null && result.files.single.name != null) {
      file.value = result.files.single.name!;
    }
  }

  void moveToSignInScreen() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    phoneNumberController.clear();
    controllers.clear();
    Get.to(SignInScreen());
  }

  final List<String> medicalSpecialityList = ['Cardiology', 'Dermatology', 'Neurology', 'Oncology', 'Pediatrics', 'Gastroenterology', 'Orthopedics', 'Ophthalmology', 'Pulmonology', 'Endocrinology', 'Nephrology'];
  RxString selectedSpecialist = "Cardiology".obs;
  void updateSpecialization(String? newValue) { selectedSpecialist.value = newValue!; }

  final List<String> feeList = ['\$25/ 30 mint45', '\$50/ 60 mint75', '\$125/ 90 mint'];
  RxString selectedFee = "\$25/ 30 mint45".obs;
  void updateFee(String? newValue) { selectedFee.value = newValue!; }

  final isPersonalDataChecked = false.obs;
  final isSubmissionConsentChecked = false.obs;

  void togglePersonalData(bool? value) { isPersonalDataChecked.value = value ?? false; }
  void toggleSubmissionConsent(bool? value) { isSubmissionConsentChecked.value = value ?? false; }

  @override
  void onClose() {
    timer?.cancel();
    for (var controller in controllers) { controller.dispose(); }
    for (var node in focusNodes) { node.dispose(); }
    super.onClose();
  }
}