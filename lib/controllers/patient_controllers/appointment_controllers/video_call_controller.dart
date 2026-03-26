import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/services/api_service.dart';
import 'package:patient_app/utils/api_urls.dart';
import 'package:patient_app/utils/locat_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;

const String appId = "d7ea8ffc1313493385d9e27827ff633c";

class VideoCallController extends GetxController {
  RxBool isCameraInitialized = false.obs;
  RxBool showLocalPreview = false.obs;
  int selectedCameraIndex = 0;
  ApiService _apiService=ApiService();
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

  RxString channelName = ''.obs;
  RxString token = ''.obs;
  RxString appointmentId = ''.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkDoctor();
  }

  void setAppointmentId(String id) {
    appointmentId.value = id;
  }

  Future<void> initializePreview() async {
    if (appointmentId.value.isEmpty) {
      Get.snackbar('Error', 'Appointment ID is required', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isCameraInitialized.value = false;
    showLocalPreview.value = false;

    await callVideoCallApi();
  }

  Future<void> callVideoCallApi() async {
    if (appointmentId.value.isEmpty) {
      Get.snackbar('Error', 'Appointment ID is required',backgroundColor: Colors.red,colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      final response = await _apiService.post(
        ApiUrls.videoCallApi,
        data: {"appointmentId":appointmentId.value},
      );

      if (response.statusCode == 200) {
        print("agora is runing");
        final data = response.data;

        if (data['success'] == true) {
          token.value = data['token'];
          channelName.value = data['channelName'];
          await setupPreviewEngine();
        } else {
          Get.snackbar('Error', 'Failed to get video call token');
        }
      } else {
        Get.snackbar('Error', 'API Error: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onNoteChanged(String text) => noteText.value = text;

  void saveNote() {
    Get.focusScope?.unfocus();
    Get.back();
    noteText.value = '';
    Get.snackbar('Success', 'Note Saved', backgroundColor: Colors.green);
  }

  Future<void> checkDoctor() async {
    isDoctor.value = await LocalStorageUtils.getLoginedDoctor();
  }

  Future<void> setupPreviewEngine() async {
    if (token.value.isEmpty || channelName.value.isEmpty) {
      Get.snackbar('Error', 'Token or channel name not available');
      return;
    }

    await [Permission.camera, Permission.microphone].request();

    engine = createAgoraRtcEngine();
    await engine!.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    await engine!.enableVideo();

    // iOS specific setup
    if (Platform.isIOS) {
      await engine!.setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
      await engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    }

    await engine!.startPreview();
    isCameraInitialized.value = true;
    showLocalPreview.value = true;

    engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          isJoined.value = true;
          localUid.value = connection.localUid;
          if (Platform.isIOS && !cameraOff.value) {
            showLocalPreview.value = true;
          }
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
  }

  Future<void> joinMeeting() async {
    if (token.value.isEmpty || channelName.value.isEmpty) {
      await callVideoCallApi();
    }

    if (token.value.isEmpty || channelName.value.isEmpty) {
      Get.snackbar('Error', 'Cannot join: Missing token or channel',backgroundColor: Colors.red,colorText: Colors.white);
      return;
    }

    try {
      if (!cameraOff.value) {
        await engine!.enableVideo();
        await engine!.startPreview();
        showLocalPreview.value = true;
      }

      await engine!.joinChannel(
        token: token.value,
        channelId: channelName.value,
        uid: 0,
        options: ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          publishCameraTrack: !cameraOff.value,
          publishMicrophoneTrack: !micMuted.value,
          autoSubscribeAudio: true,
          autoSubscribeVideo: true,
        ),
      );
    } catch (e) {
      Get.snackbar('Join Error', 'Failed to join channel: $e');
    }
  }

  Future<void> toggleMic() async {
    micMuted.value = !micMuted.value;
    if (engine != null) {
      await engine!.muteLocalAudioStream(micMuted.value);
      await engine!.updateChannelMediaOptions(
        ChannelMediaOptions(
          publishMicrophoneTrack: !micMuted.value,
        ),
      );
    }
  }

  Future<void> toggleCamera() async {
    cameraOff.value = !cameraOff.value;

    if (engine != null) {
      try {
        if (cameraOff.value) {
          // Turn camera OFF
          await engine!.muteLocalVideoStream(true);
          await engine!.updateChannelMediaOptions(
            ChannelMediaOptions(
              publishCameraTrack: false,
            ),
          );

          if (Platform.isIOS) {
            showLocalPreview.value = false;
            await engine!.stopPreview();
          }
        } else {
          // Turn camera ON
          await engine!.enableVideo();

          if (Platform.isIOS) {
            // For iOS, we need to reinitialize preview
            await engine!.startPreview();
            showLocalPreview.value = true;
          }

          await engine!.muteLocalVideoStream(false);
          await engine!.updateChannelMediaOptions(
            ChannelMediaOptions(
              publishCameraTrack: true,
            ),
          );

          // Small delay for iOS to properly initialize
          if (Platform.isIOS) {
            await Future.delayed(const Duration(milliseconds: 300));
          }
        }
      } catch (e) {
        Get.snackbar('Camera Error', 'Failed to toggle camera: $e');
      }
    }
  }

  Future<void> toggleSpeaker() async {
    speakerMuted.value = !speakerMuted.value;
    await engine?.setEnableSpeakerphone(!speakerMuted.value);
  }

  Future<void> switchCamera() async {
    if (engine != null && !cameraOff.value) {
      await engine!.switchCamera();

      if (Platform.isIOS) {
        // iOS needs to restart preview after switching cameras
        await Future.delayed(const Duration(milliseconds: 100));
        await engine!.startPreview();
      }
    }
  }

  Future<void> leaveChannel() async {
    await engine?.leaveChannel();
    await engine?.stopPreview();
    await engine?.release();
    engine = null;
    isJoined.value = false;
    isCameraInitialized.value = false;
    showLocalPreview.value = false;
    token.value = '';
    channelName.value = '';
  }

  @override
  void onClose() {
    leaveChannel();
    super.onClose();
  }
  RxInt durationSeconds = 0.obs;
  Timer? _timer;

  void startCallTimer() {
    if (_timer != null && _timer!.isActive) return;
    durationSeconds.value = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      durationSeconds.value++;
    });
  }

  void stopCallTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> saveCallDuration(String appointmentId) async {
    try {
      final response = await _apiService.post(
        ApiUrls.saveCallDuration,
        data: {
          "appointmentId": appointmentId,
          "duration": durationSeconds.value,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
       print("Call duration saved successfully");
      } else {
        print("Failed to save call duration: ${response.statusCode}");
      }
    } catch (e) {
      print("Error saving call duration: $e");
    }
  }
}