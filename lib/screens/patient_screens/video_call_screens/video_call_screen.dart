import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/appointment_controllers/video_call_controller.dart';
import 'package:patient_app/widgets/doctor_widgets/video_call_widgets/add_prescription_drawer.dart';
import '../../../widgets/doctor_widgets/video_call_widgets/doctor_notes_drawer.dart';
import '../../../widgets/doctor_widgets/video_call_widgets/recent_projects_drawer.dart';
import '../../../widgets/patient_widgets/video_call_widgets/video_call_controls.dart';
import '../../../utils/app_strings.dart';

class VideoCallScreen extends StatelessWidget {
  VideoCallScreen({super.key});

  // Use Get.find if the controller is already initialized in a previous screen/binding
  final VideoCallController controller = Get.put(VideoCallController());

  @override
  Widget build(BuildContext context) {
    controller.checkDoctor();
    return Scaffold(
      key: controller.scaffoldKey,
      // The drawer content remains localized within the specific Drawer widgets
      endDrawer: Obx(() => controller.drawerValue.value == "doctorNotes"
          ? const DoctorNotesDrawer()
          : controller.drawerValue.value == "addPrescription"
          ? const AddPrescriptionDrawer()
          : const RecentProjectsDrawer()),
      body: Container(
        height: 1.sh,
        width: 1.sw,
        color: Colors.black87,
        child: Column(
          children: [
            50.verticalSpace,
            // The main video feed container
            SizedBox(
              height: 0.80.sh,
              width: 1.sw,
              child: Image.asset(
                "assets/demo_images/demo_video_image_2.png",
                fit: BoxFit.fill,
              ),
            ),
            // Controls (Mic, Camera, End Call, etc.)
             VideoCallControls(),
          ],
        ),
      ),
    );
  }
}