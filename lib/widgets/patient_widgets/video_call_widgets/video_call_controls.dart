import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../../controllers/patient_controllers/appointment_controllers/video_call_controller.dart';
import '../../../screens/patient_screens/chat_screens/chat_detail_screen.dart';
import '../../../screens/patient_screens/video_call_screens/setting_screen.dart';
import 'call_end_dialog.dart';

class VideoCallControls extends StatelessWidget {
  VideoCallControls({super.key});

  final VideoCallController controller = Get.put(VideoCallController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 16.0,
        top: 16.0,
        left: 8.0,
        right: 8.0,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.black.withOpacity(0.4),
            Colors.transparent,
          ],
          stops: const [0.0, 0.4, 1.0],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ElevatedButton(
              onPressed: () => _showEndCallDialog(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 14.0,
                ),
                elevation: 5,
              ),
              child: Text(
                AppStrings.end.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          _buildMicButton(),
          _buildCameraButton(),
          _buildSpeakerButton(),
          Obx(() => controller.isDoctor.value
              ? _buildMoreMenuButtonDoctor(context)
              : _buildMoreMenuButton(context)),
        ],
      ),
    );
  }

  Widget _buildMicButton() {
    return Obx(() {
      final isMuted = controller.micMuted.value;
      return _buildControlButton(
        icon: isMuted ? Icons.mic_off : Icons.mic,
        onPressed: controller.toggleMic,
        isActive: !isMuted,
      );
    });
  }

  Widget _buildCameraButton() {
    return Obx(() {
      final isOff = controller.cameraOff.value;
      return _buildControlButton(
        icon: isOff ? Icons.videocam_off : Icons.videocam,
        onPressed: controller.toggleCamera,
        isActive: !isOff,
      );
    });
  }

  Widget _buildSpeakerButton() {
    return Obx(() {
      final isMuted = controller.speakerMuted.value;
      return _buildControlButton(
        icon: isMuted ? Icons.volume_off : Icons.volume_up,
        onPressed: controller.toggleSpeaker,
        isActive: !isMuted,
      );
    });
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isActive,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Material(
        color: isActive ? Colors.grey[800] : Colors.red[600],
        shape:  CircleBorder(side: BorderSide(color:isActive?Colors.white:Colors.red,width:2.sp)),
        elevation: 5,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }

  Widget _buildMoreMenuButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Material(
        color: Colors.grey[800],
        shape: const CircleBorder(),
        elevation: 5,
        child: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white, size: 28),
          onSelected: (String result) {
            if (result == "messages") {
              Get.to(ChatDetailScreen());
            } else if (result == "setting") {
              Get.to(SettingScreen());
            }
          },
          offset: const Offset(0, -200),
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'messages',
              child: Text(AppStrings.inVideoMessages.tr, style: const TextStyle(fontSize: 16)),
            ),
            PopupMenuItem<String>(
              value: 'share',
              child: Text(AppStrings.share.tr, style: const TextStyle(fontSize: 16)),
            ),
            PopupMenuItem<String>(
              value: 'setting',
              child: Text(AppStrings.settings.tr, style: const TextStyle(fontSize: 16)),
            ),
            PopupMenuItem<String>(
              value: 'captions',
              child: Text(AppStrings.captionsOff.tr, style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreMenuButtonDoctor(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Material(
        color: Colors.grey[800],
        shape: const CircleBorder(),
        elevation: 5,
        child:  Padding(
          padding:  EdgeInsets.all(4.sp),
          child: InkWell(onTap: (){
            controller.drawerValue.value = "moreAction";
            controller.scaffoldKey.currentState?.openEndDrawer();
          },child: Icon(Icons.more_vert, color: Colors.white, size: 43.sp)),
        ),));
  }

  void _showEndCallDialog() {
    Get.dialog(barrierDismissible: false,  CallEndDialog());
  }
}