import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/locat_storage.dart';
import 'package:permission_handler/permission_handler.dart';

const String appId = "d7ea8ffc1313493385d9e27827ff633c";
const String channelName = "nawa_qare";
const String token = "007eJxTYPgctreOgzvl0sFpk/5MispTOOzb0nrvgX+8WOIrr2OpwWUKDCnmqYkWaWnJhsaGxiaWxsYWpimWqUbmFkbmaWlmxsbJP182ZTYEMjKsUZ7CwsgAgSA+J0NeYnlifGFiUSoDAwBS0CLM";

class VideoCallController extends GetxController {
  RxBool isCameraInitialized = false.obs;
  int selectedCameraIndex = 0;
  Rx<FlashMode> flashMode = FlashMode.none.obs;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  RtcEngine? engine;
  final isJoined = false.obs;
  final localUid = RxnInt();
  final remoteUid = RxnInt();
  RxBool micMuted = false.obs;
  RxBool cameraOff = false.obs;
  RxBool speakerMuted = false.obs;
  RxBool isDoctor = false.obs;
  RxString drawerValue = "doctorNotes".obs;
  final noteText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkDoctor();
    initLocalPreview();
  }

  Future<void> checkDoctor() async {
    isDoctor.value = await LocalStorageUtils.getLoginedDoctor();
  }

  Future<void> initLocalPreview() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();
print("Camera permission status: ${statuses[Permission.camera]}");
    PermissionStatus cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      if (cameraStatus.isDenied) {
        Get.snackbar(
          "Permission Required",
          "Camera access is needed to preview your video.\nPlease enable it in Settings.",
          duration: const Duration(seconds: 5),
          mainButton: TextButton(
            onPressed: () async {
              await openAppSettings();
              await Future.delayed(const Duration(milliseconds: 800));
              await initLocalPreview();
            },
            child: const Text("Open Settings"),
          ),
        );
      } else {
        Get.snackbar("Error", "Camera permission is required for preview");
      }
      return;
    }

    try {
      isCameraInitialized.value = true;
    } catch (e) {
      Get.snackbar("Error", "Failed to access cameras: $e");
    }
  }

  Future<void> initAgora() async {
    isCameraInitialized.value = false;

    engine = createAgoraRtcEngine();
    await engine!.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    await engine!.enableVideo();
    await engine!.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 640, height: 360),
        frameRate: 15,
        bitrate: 1000,
        orientationMode: OrientationMode.orientationModeAdaptive,
      ),
    );

    engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          isJoined.value = true;
          localUid.value = connection.localUid;
        },
        onUserJoined: (RtcConnection connection, int uid, int elapsed) {
          remoteUid.value = uid;
        },
        onUserOffline: (RtcConnection connection, int uid, UserOfflineReasonType reason) {
          if (remoteUid.value == uid) remoteUid.value = null;
        },
        onError: (ErrorCodeType err, String msg) {
          Get.snackbar('Agora Error', '$err - $msg');
        },
      ),
    );

    await engine!.joinChannel(
      token: token,
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  Future<void> toggleMic() async {
    micMuted.value = !micMuted.value;
    if (engine != null) {
      await engine!.muteLocalAudioStream(micMuted.value);
    }
  }

  Future<void> toggleCamera() async {
    cameraOff.value = !cameraOff.value;
    if (engine != null) {
      await engine!.muteLocalVideoStream(cameraOff.value);
    }
    isCameraInitialized.refresh();
  }

  Future<void> toggleSpeaker() async {
    speakerMuted.value = !speakerMuted.value;
    await engine?.setEnableSpeakerphone(!speakerMuted.value);
  }

  Future<void> switchCamera() async {
    if (engine != null) {
      await engine!.switchCamera();
    }
  }

  Future<void> leaveChannel() async {
    await engine?.leaveChannel();
    await engine?.release();
    engine = null;
    isJoined.value = false;
  }

  Future<void> openAppSettings() async {
    await openAppSettings();
  }

  @override
  void onClose() {
    leaveChannel();
    super.onClose();
  }

  void onNoteChanged(String text) => noteText.value = text;

  void saveNote() {
    Get.focusScope?.unfocus();
    Get.back();
    noteText.value = '';
    Get.snackbar('Success', 'Note Saved', backgroundColor: Colors.green);
  }
}