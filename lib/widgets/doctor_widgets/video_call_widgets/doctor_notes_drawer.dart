import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/appointment_controllers/video_call_controller.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/patient_widgets/video_call_widgets/clinic_note_widget.dart';

class DoctorNotesDrawer extends GetView<VideoCallController> {
  const DoctorNotesDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width,
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Stack(
        children: [
          Row(
            children: [
              const Spacer(),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFF4F9FF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0.w,20.h, 0.w, 0.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:  EdgeInsets.fromLTRB(20.w,30.h,20.w,0),
                              child: Text(
                                "Doctor Notes",
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF333333),
                                ),
                              ),
                            ),
                           20.verticalSpace,
                           Expanded(child: ClinicalNoteWidget(appointmentId: controller.appointmentId.value)),
                           30.verticalSpace,
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: (MediaQuery.of(context).size.width * 0.15) - 20,
            top: 45.h,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                height: 40.h,
                width: 40.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF4A80F0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}