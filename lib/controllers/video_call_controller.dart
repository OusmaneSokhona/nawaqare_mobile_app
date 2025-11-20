import 'package:get/get.dart';

class VideoCallController extends GetxController {
  RxBool micMuted = false.obs;
  RxBool cameraOff = false.obs;
  RxBool speakerMuted = false.obs;
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
}