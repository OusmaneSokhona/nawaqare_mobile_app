import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/models/appointment_model.dart';
import 'package:patient_app/screens/patient_screens/video_call_screens/video_call_screen.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import '../../../controllers/patient_controllers/appointment_controllers/video_call_controller.dart';
import '../../../widgets/doctor_widgets/appointment_widgets/doctor_past_appoinment_widget.dart';

class PreviewScreen extends StatelessWidget {
  final Appointment appointment;
  const PreviewScreen({super.key, required this.appointment});

  String _getFormattedDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final appointmentDay = DateTime(date.year, date.month, date.day);
    if (appointmentDay == today) {
      return "Today";
    } else if (appointmentDay == today.add(const Duration(days: 1))) {
      return "Tomorrow";
    } else {
      final weekdayMap = {
        1: 'Monday', 2: 'Tuesday', 3: 'Wednesday', 4: 'Thursday', 5: 'Friday', 6: 'Saturday', 7: 'Sunday',
      };
      final monthMap = {
        1: 'January', 2: 'February', 3: 'March', 4: 'April', 5: 'May', 6: 'June',
        7: 'July', 8: 'August', 9: 'September', 10: 'October', 11: 'November', 12: 'December',
      };
      final weekday = weekdayMap[date.weekday] ?? 'Day';
      final month = monthMap[date.month] ?? 'Month';
      return '$weekday, ${date.day} $month';
    }
  }

  String _getFormattedTime(DateTime startTime, DateTime endTime) {
    // Add null checks
    if (startTime == null || endTime == null) {
      return 'Time not available';
    }

    final startHour = startTime.hour % 12 == 0 ? 12 : startTime.hour % 12;
    final startPeriod = startTime.hour < 12 ? 'AM' : 'PM';
    final endHour = endTime.hour % 12 == 0 ? 12 : endTime.hour % 12;
    final endPeriod = endTime.hour < 12 ? 'AM' : 'PM';

    return '$startHour:${startTime.minute.toString().padLeft(2, '0')} $startPeriod - $endHour:${endTime.minute.toString().padLeft(2, '0')} $endPeriod';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VideoCallController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.setAppointmentId(appointment.id);
      controller.initializePreview();
    });

    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.onboardingBackground, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            70.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.preview.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                  InkWell(
                    onTap: () => Get.back(),
                    child: Text(
                      AppStrings.cancel.tr,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: AppFonts.jakartaBold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    20.verticalSpace,
                    Stack(
                      children: [
                        SizedBox(
                          height: 300.h,
                          width: 1.sw,
                          child: Obx(() {
                            if (controller.isLoading.value) {
                              return Container(
                                color: Colors.black,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            } else if (controller.cameraOff.value) {
                              return Container(
                                color: Colors.black,
                                child: Center(
                                  child: Icon(
                                    Icons.videocam_off,
                                    color: Colors.white,
                                    size: 50.sp,
                                  ),
                                ),
                              );
                            } else if (controller.isCameraInitialized.value &&
                                controller.engine != null) {
                              return AgoraVideoView(
                                controller: VideoViewController(
                                  rtcEngine: controller.engine!,
                                  canvas: const VideoCanvas(uid: 0),
                                ),
                              );
                            }
                            return Container(
                              color: Colors.black,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }),
                        ),
                        Positioned(
                          bottom: 15.h,
                          right: 0,
                          left: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(
                                    () => Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _ControlButton(
                                      icon: controller.micMuted.value ? Icons.mic_off : Icons.mic,
                                      color: controller.micMuted.value ? Colors.red : AppColors.primaryColor,
                                      onTap: controller.toggleMic,
                                    ),
                                    24.horizontalSpace,
                                    _ControlButton(
                                      icon: controller.cameraOff.value ? Icons.videocam_off : Icons.videocam,
                                      color: controller.cameraOff.value ? Colors.red : AppColors.primaryColor,
                                      onTap: controller.toggleCamera,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    30.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          CardHeader(title: AppStrings.remoteConsultation.tr),
                          _buildConsultationCard(),
                          10.verticalSpace,
                          _buildEncryptedCallNote(),
                          20.verticalSpace,
                           CustomButton(
                            borderRadius: 15,
                            text: AppStrings.launchVideo.tr,
                            onTap: () async {
                              if(controller.isLoading.value){

                              }else{
                              await controller.joinMeeting();
                              Get.to(() => VideoCallScreen());}
                            },
                          ),
                          30.verticalSpace,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsultationCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildDoctorImage(),
              15.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.doctorId.fullName,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: AppFonts.jakartaBold,
                        color: Colors.black,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      appointment.doctorId.email,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppFonts.jakartaMedium,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          15.verticalSpace,
          Divider(thickness: 0.3, color: Colors.black45),
          15.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailColumn(Icons.calendar_today_outlined,
                  AppStrings.date.tr, _getFormattedDate(appointment.date)),
              // Fix: Safely handle null timeslot
              _buildDetailColumn(
                Icons.watch_later_outlined,
                "Time",
                appointment.timeslot != null
                    ? _getFormattedTime(appointment.timeslot!.startTime, appointment.timeslot!.endTime)
                    : 'Time not specified',
              ),
              _buildDetailColumn(Icons.payment, AppStrings.fee.tr,
                  "${appointment.fee} ${appointment.currency}"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorImage() {
    if (appointment.doctorId.profileImage != null &&
        appointment.doctorId.profileImage!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Image.network(
          appointment.doctorId.profileImage!,
          height: 70.h,
          width: 70.w,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildFallbackImage(),
        ),
      );
    }
    return _buildFallbackImage();
  }

  Widget _buildFallbackImage() {
    return Container(
      height: 70.h,
      width: 70.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.primaryColor.withOpacity(0.1),
      ),
      child: Center(
        child: Icon(
          Icons.person,
          size: 35.sp,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }

  Widget _buildDetailColumn(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 24.sp),
        8.verticalSpace,
        Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        4.verticalSpace,
        Text(
          value,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildEncryptedCallNote() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.orange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: AppColors.orange.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: AppColors.orange, size: 24.sp),
          12.horizontalSpace,
          Expanded(
            child: Text(
              AppStrings.encryptedCallNote.tr,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF333333),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 32.sp),
      ),
    );
  }
}