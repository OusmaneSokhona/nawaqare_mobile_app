import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/appointment_controllers/video_call_controller.dart';

import '../../../screens/patient_screens/chat_screens/chat_detail_screen.dart';
import '../../../screens/patient_screens/video_call_screens/setting_screen.dart';

class MoreActionsDrawer extends GetView<VideoCallController> {
  const MoreActionsDrawer({super.key});

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
                width: 0.85.sw,
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F9FF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    bottomLeft: Radius.circular(24),
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 5.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "More Actions",
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        15.verticalSpace,
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: ListView(
                              padding: EdgeInsets.symmetric(horizontal: 0,vertical: 10.h),
                              children: [
                                _buildActionItem(
                                  icon: Icons.local_hospital,
                                  title: "Add Clinical Note",
                                  onTap: () {
                                    controller.drawerValue.value = "medicalObservation";
                                    controller.scaffoldKey.currentState?.openEndDrawer();
                                  },
                                ),
                                _buildActionItem(
                                  icon: Icons.add,
                                  title: "Add Prescription",
                                  onTap: () {
                                    controller.drawerValue.value = "addPrescription";
                                    controller.scaffoldKey.currentState?.openEndDrawer();
                                  },
                                ),
                                _buildActionItem(icon: Icons.notes, title: "Doctor Notes", onTap: (){
                                  controller.drawerValue.value = "doctorNotes";
                                  controller.scaffoldKey.currentState?.openEndDrawer();
                                }),
                                _buildActionItem(icon: Icons.chat_bubble, title: "Chat Screen", onTap: (){  Get.to(ChatDetailScreen());}),
                                _buildActionItem(
                                  icon: Icons.assignment_outlined,
                                  title: "View Reports",
                                  onTap: () {
                                    controller.drawerValue.value = "viewReports";
                                    controller.scaffoldKey.currentState?.openEndDrawer();
                                  },
                                ),
                                _buildActionItem(
                                  icon: Icons.cloud_outlined,
                                  title: "Consent & Access",
                                  onTap: () {
                                    controller.drawerValue.value = "consentAccess";
                                    controller.scaffoldKey.currentState?.openEndDrawer();
                                  },
                                ),
                                _buildActionItem(
                                  icon: Icons.settings_outlined,
                                  title: "Setting",
                                  onTap: () {
                                    Get.to(SettingScreen());
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: (0.15.sw) - 20,
            top: 55.h,
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
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: (){
        Get.back();
        onTap();
      },
      leading: Icon(
        icon,
        color: const Color(0xFF4A80F0),
        size: 24.sp,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey.shade400,
        size: 20.sp,
      ),
    );
  }
}