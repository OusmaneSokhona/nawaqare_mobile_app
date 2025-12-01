import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/shared_prefrence.dart';

class VideoCallController extends GetxController {
  RxBool micMuted = false.obs;
  RxBool cameraOff = false.obs;
  RxBool speakerMuted = false.obs;
  RxBool isDoctor = false.obs;
  Future<void> checkDoctor() async {
    isDoctor.value=await LocalStorageUtils.getLoginedDoctor();
  }
  void toggleMic() {
    micMuted.value = !micMuted.value;
    print('Mic Toggled: ${micMuted.value ? "Muted" : "Active"}');
  }

  void toggleCamera() {
    cameraOff.value = !cameraOff.value;
    print('Camera Toggled: ${cameraOff.value ? "Off" : "On"}');
  }

  void toggleSpeaker() {
    speakerMuted.value = !speakerMuted.value;
    print('Speaker Toggled: ${speakerMuted.value ? "Off" : "On"}');
  }
  final noteText = ''.obs;

  void saveNote() {
    debugPrint('Note Saved: ${noteText.value}');
    Get.focusScope?.unfocus();
    Get.back();
    noteText.value = '';
    Get.snackbar(
      'Note Saved',
      'Observation was recorded successfully.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void onNoteChanged(String text) {
    noteText.value = text;
  }
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
}