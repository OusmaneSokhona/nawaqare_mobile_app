import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/patient_widgets/video_call_widgets/video_call_controls.dart';

class VideoCallScreen extends StatelessWidget {
  const VideoCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
