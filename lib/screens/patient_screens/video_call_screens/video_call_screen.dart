import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/appointment_controllers/video_call_controller.dart';
import 'package:patient_app/widgets/doctor_widgets/video_call_widgets/add_prescription_drawer.dart';
import 'package:patient_app/widgets/doctor_widgets/video_call_widgets/doctor_notes_drawer.dart';
import 'package:patient_app/widgets/doctor_widgets/video_call_widgets/recent_projects_drawer.dart';
import 'package:patient_app/widgets/patient_widgets/video_call_widgets/video_call_controls.dart';

const String appId = "d7ea8ffc1313493385d9e27827ff633c";
const String channelName = "nawa_qare";
const String token = "007eJxTYPgctreOgzvl0sFpk/5MispTOOzb0nrvgX+8WOIrr2OpwWUKDCnmqYkWaWnJhsaGxiaWxsYWpimWqUbmFkbmaWlmxsbJP182ZTYEMjKsUZ7CwsgAgSA+J0NeYnlifGFiUSoDAwBS0CLM";

class VideoCallScreen extends StatelessWidget {
  VideoCallScreen({super.key});

  final VideoCallController controller = Get.put(VideoCallController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      endDrawer: Obx(
            () => controller.drawerValue.value == "doctorNotes"
            ? const DoctorNotesDrawer()
            : controller.drawerValue.value == "addPrescription"
            ? const AddPrescriptionDrawer()
            : const RecentProjectsDrawer(),
      ),
      body: Obx(() {
        final hasRemote = controller.remoteUid.value != null;
        final engineReady = controller.engine != null;

        return Container(
          height: 1.sh,
          width: 1.sw,
          color: Colors.black87,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (hasRemote && engineReady)
                AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: controller.engine!,
                    canvas: VideoCanvas(
                      uid: controller.remoteUid.value,
                      renderMode: RenderModeType.renderModeFit,
                    ),
                    connection: RtcConnection(channelId: channelName),
                  ),
                )
              else
                const Center(
                  child: Text(
                    "Waiting for the other participant...",
                    style: TextStyle(color: Colors.white70, fontSize: 20),
                  ),
                ),

              if (controller.isJoined.value && engineReady)
                Positioned(
                  top: 60.h,
                  right: 16.w,
                  child: Container(
                    width: 140.w,
                    height: 180.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: Colors.blueAccent, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14.r),
                      child: AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: controller.engine!,
                          canvas: const VideoCanvas(uid: 0),
                        ),
                      ),
                    ),
                  ),
                ),

              if (!controller.isJoined.value)
                const Center(child: CircularProgressIndicator(color: Colors.white)),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: VideoCallControls(),
              ),
              Positioned(top: 70.h,left: 30.w,child: InkWell(onTap: (){controller.switchCamera();},child: Icon(Icons.cameraswitch,color: Colors.white,))),
            ],
          ),
        );
      }),
    );
  }
}