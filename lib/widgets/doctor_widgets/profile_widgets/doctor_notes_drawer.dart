
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/appointment_controllers/video_call_controller.dart';
import 'package:patient_app/utils/app_colors.dart';

class DoctorNotesDrawer extends GetView<VideoCallController> {
  const DoctorNotesDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.9,
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Container(
            width: 0.8.sw,
            height: 1.sh,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.onboardingBackground, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60.0, left: 16.0, right: 16.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          Text(
                            'Doctor Notes',
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(
                            width: 0.6.sw,
                            child: Text(
                              'Record Key Observations During This Consultation',
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.darkGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 20.0, bottom: 8.0),
                  child: Text(
                    'Add Note',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Obx(() => Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      onChanged: controller.onNoteChanged,
                      controller: TextEditingController(text: controller.noteText.value),
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: const InputDecoration(
                        hintText: 'Write observations during the consultation',
                        contentPadding: EdgeInsets.all(12),
                        border: InputBorder.none,
                      ),
                    ),
                  )),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.saveNote,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        'Note save',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 12.w,
            top: 55.h,
            child: Container(
              height: 40.h,
              width: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_forward_outlined,
                  color: Colors.white,
                  size: 20.sp,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}