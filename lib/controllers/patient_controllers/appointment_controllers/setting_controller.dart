import 'package:get/get.dart';
import 'package:patient_app/utils/app_strings.dart';

class SettingsController extends GetxController {
  final List<String> microphoneOptions = [
    AppStrings.internalMic.tr,
    AppStrings.externalMic.tr,
    AppStrings.headsetMic.tr
  ];
  final List<String> speakerOptions = [
    AppStrings.defaultOption.tr,
    AppStrings.builtInSpeakers.tr,
    AppStrings.externalOutput.tr
  ];
  final List<String> cameraOptions = [
    AppStrings.defaultOption.tr,
    AppStrings.frontCamera.tr,
    AppStrings.backCamera.tr
  ];
  final List<String> captionLanguageOptions = [
    AppStrings.detectLanguage.tr,
    AppStrings.english.tr,
    AppStrings.spanish.tr,
    AppStrings.french.tr
  ];

  late RxString microphoneValue;
  late RxString speakerValue;
  late RxString cameraValue;
  late RxString captionLanguageValue;

  var bandwidth = '3.8 Mbps'.obs;
  var latency = '62 ms'.obs;
  var connectionQuality = AppStrings.good.tr.obs;

  var isCameraGranted = true.obs;
  var isMicrophoneGranted = false.obs;

  @override
  void onInit() {
    microphoneValue = AppStrings.internalMic.tr.obs;
    speakerValue = AppStrings.defaultOption.tr.obs;
    cameraValue = AppStrings.defaultOption.tr.obs;
    captionLanguageValue = AppStrings.detectLanguage.tr.obs;
    super.onInit();
  }

  void updateMicrophone(String? newValue) {
    if (newValue != null) {
      microphoneValue.value = newValue;
    }
  }

  void updateSpeaker(String? newValue) {
    if (newValue != null) {
      speakerValue.value = newValue;
    }
  }

  void updateCamera(String? newValue) {
    if (newValue != null) {
      cameraValue.value = newValue;
    }
  }

  void updateCaptionLanguage(String? newValue) {
    if (newValue != null) {
      captionLanguageValue.value = newValue;
    }
  }

  void runNetworkTest() {
    bandwidth.value = AppStrings.testing.tr;
    latency.value = AppStrings.testing.tr;
    connectionQuality.value = AppStrings.testing.tr;
    Future.delayed(const Duration(seconds: 2), () {
      bandwidth.value = '5.1 Mbps';
      latency.value = '45 ms';
      connectionQuality.value = AppStrings.excellent.tr;
    });
  }

  void managePermissions() {
    isCameraGranted.toggle();
    isMicrophoneGranted.toggle();
  }

  RxBool isFaqExpanded = false.obs;

  void toggleFaq() {
    isFaqExpanded.value = !isFaqExpanded.value;
  }
}