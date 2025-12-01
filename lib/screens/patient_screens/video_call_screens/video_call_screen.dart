import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/appointment_controllers/video_call_controller.dart';

import '../../../widgets/doctor_widgets/profile_widgets/doctor_notes_drawer.dart';
import '../../../widgets/patient_widgets/video_call_widgets/video_call_controls.dart';

class VideoCallScreen extends StatelessWidget {
   VideoCallScreen({super.key});
VideoCallController controller=Get.put(VideoCallController());
  @override
  Widget build(BuildContext context) {
    controller.checkDoctor();
    return Scaffold(
      key: controller.scaffoldKey,
      endDrawer: DoctorNotesDrawer(),
body: Container(
  height: 1.sh,
  width: 1.sw,color: Colors.black87,

  child: Column(
    children: [
      50.verticalSpace,
      Container(height: 0.80.sh,width: 1.sw,child: Image.asset("assets/demo_images/demo_video_image_2.png",fit: BoxFit.fill,)),
      VideoCallControls(),
    ],
  ),
),
    );
  }
}
