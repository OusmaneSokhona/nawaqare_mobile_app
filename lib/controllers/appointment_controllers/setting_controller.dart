import 'package:get/get.dart';

class SettingsController extends GetxController {
  final List<String> microphoneOptions = ['Internal microphone', 'External microphone', 'Headset mic'];
  final List<String> speakerOptions = ['Default', 'Built-in speakers', 'External output'];
  final List<String> cameraOptions = ['Default', 'Front camera', 'Back camera'];
  final List<String> captionLanguageOptions = ['Detect language', 'English', 'Spanish', 'French'];

  var microphoneValue = 'Internal microphone'.obs;
  var speakerValue = 'Default'.obs;
  var cameraValue = 'Default'.obs;
  var captionLanguageValue = 'Detect language'.obs;

  var bandwidth = '3.8 Mbps'.obs;
  var latency = '62 ms'.obs;
  var connectionQuality = 'Good'.obs;

  var isCameraGranted = true.obs;
  var isMicrophoneGranted = false.obs;

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
    bandwidth.value = 'Testing...';
    latency.value = 'Testing...';
    connectionQuality.value = 'Testing...';
    Future.delayed(const Duration(seconds: 2), () {
      bandwidth.value = '5.1 Mbps';
      latency.value = '45 ms';
      connectionQuality.value = 'Excellent';
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