import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/appointment_controllers/appointment_controller.dart';
import 'package:patient_app/screens/patient_screens/appointment_screens/patient_reschdule_appoinment_screen.dart';
import 'package:patient_app/widgets/custom_button.dart';
import '../../../models/appointment_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../../widgets/appointment_statue_widget.dart';
import '../../../widgets/patient_widgets/appointment_widgets/past_appointment_widgets.dart';
import '../../../widgets/reschdule_request_widget.dart';
import '../../doctor_screens/appointment_screens/doctor_reschedule_appointment_screen.dart';
import '../video_call_screens/preview_screen.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final bool isCompleted;
  final Appointment appointment;

  AppointmentDetailScreen({
    super.key,
    required this.appointment,
    this.isCompleted = false,
  });

  final AppointmentController appointmentController = Get.put(
    AppointmentController(),
  );

  bool get _hasRescheduleReason {
    return appointment.isReschedule?.reason != null &&
        appointment.isReschedule!.reason!.isNotEmpty &&
        appointment.isReschedule!.role != "patient"&&appointment.isReschedule!.isAccept=="pending";
  }

  bool get _hasRescheduleStatus {
    return appointment.isReschedule?.reason != null &&
        appointment.isReschedule!.reason!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    print("object${appointment.isReschedule!.isAccept}");
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              70.verticalSpace,
              Row(
                children: [
                  InkWell(
                    onTap: (){appointmentController.fetchAppointments();Get.back();},
                    child: Image.asset(
                      AppImages.backIcon,
                      height: 33.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    AppStrings.appointmentDetails.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              30.verticalSpace,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildAppointmentDetailCard(),
                      10.verticalSpace,
                      isCompleted ? _buildTabs() : SizedBox.shrink(),
                      isCompleted
                          ? PastAppointmentWidgets(appointment: appointment)
                          : _buildCurrentAppointmentContent(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentDetailCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: AppFonts.jakartaBold,
                        color: Colors.black,
                      ),
                    ),
                    5.verticalSpace,
                    Text(
                      "General Practitioner",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppFonts.jakartaMedium,
                        color: Colors.grey,
                      ),
                    ),
                    10.verticalSpace,
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange, size: 16.sp),
                        4.horizontalSpace,
                        Text(
                          "5.0",
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        8.horizontalSpace,
                        Container(
                          height: 15.h,
                          width: 1.w,
                          color: AppColors.primaryColor,
                        ),
                        8.horizontalSpace,
                        Text(
                          "${AppStrings.fee.tr}: ",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 13.sp,
                          ),
                        ),
                        Text(
                          "\$${appointment.fee} ${appointment.currency}",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          20.verticalSpace,
          _buildDetailRow(
            Icons.calendar_today_outlined,
            AppStrings.date.tr,
            _formatDate(appointment.date),
          ),
          15.verticalSpace,
          // Fix: Safely handle null timeslot
          _buildDetailRow(
            Icons.watch_later_outlined,
            "Time",
            appointment.timeslot != null
                ? _formatTime(
                  appointment.timeslot!.startTime,
                  appointment.timeslot!.endTime,
                )
                : 'Time not specified',
          ),
          15.verticalSpace,
          _buildDetailRow(
            Icons.medical_services,
            AppStrings.consultationType.tr,
            appointment.consultationType.displayName,
          ),
          if (appointment.consultationType == ConsultationType.homevisit &&
              appointment.visitAddress != null) ...[
            15.verticalSpace,
            _buildDetailRow(
              Icons.location_on,
              AppStrings.address.tr,
              appointment.visitAddress!,
            ),
          ],
          if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
            15.verticalSpace,
            _buildDetailRow(
              Icons.note,
              AppStrings.notes.tr,
              appointment.notes!,
            ),
          ],
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
          height: 80.h,
          width: 80.w,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildFallbackImage(),
        ),
      );
    }
    return _buildFallbackImage();
  }

  Widget _buildFallbackImage() {
    return Container(
      height: 80.h,
      width: 80.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.primaryColor.withOpacity(0.1),
      ),
      child: Center(
        child: Text(
          _getConsultationTypeEmoji(appointment.consultationType),
          style: TextStyle(fontSize: 35.sp),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 20.h),
        10.horizontalSpace,
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.jakartaMedium,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.jakartaMedium,
              color: Colors.black,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(appointmentController.tabs.length, (index) {
          bool isSelected =
              appointmentController.selectedTab.value ==
              appointmentController.tabs[index];
          return GestureDetector(
            onTap:
                () =>
                    appointmentController.selectedTab.value =
                        appointmentController.tabs[index],
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    appointmentController.tabs[index],
                    style: TextStyle(
                      color:
                          isSelected
                              ? const Color(0xFF3B82F6)
                              : const Color(0xFF94A3B8),
                      fontSize: 10.sp,
                      fontFamily: AppFonts.jakartaMedium,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  if (isSelected) ...[
                    4.verticalSpace,
                    Container(
                      height: 2.5.h,
                      width: 60.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ] else ...[
                    6.5.verticalSpace,
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentAppointmentContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusSection(),
        10.verticalSpace,
        _buildNotesSection(),
        70.verticalSpace,
        (appointment.status == AppointmentStatus.pending&&appointment.isReschedule!.isAccept!="pending")
            ? CustomButton(
              borderRadius: 15,
              text: AppStrings.reschedule.tr,
              onTap: () {
                Get.to(
                  PatientReschduleAppoinmentScreen(
                    appointmentId: appointment.id,
                    doctorId: appointment.doctorId.id,
                  ),
                );
              },
              bgColor: AppColors.inACtiveButtonColor,
              fontColor: Colors.black,
            )
            : _buildActionButtons(),
        20.verticalSpace,
      ],
    );
  }

  Widget _buildStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: AlignmentDirectional.topStart,
          child: Text(
            AppStrings.status.tr,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              fontFamily: AppFonts.jakartaBold,
            ),
          ),
        ),
        10.verticalSpace,
        AppointmentStatusWidget(
          status: appointment.status.displayName,
        ),
        5.verticalSpace,
        if (_hasRescheduleStatus)
          Align(
            alignment: AlignmentDirectional.topStart,
            child: Text(
              AppStrings.reschedule.tr,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                fontFamily: AppFonts.jakartaBold,
              ),
            ),
          ),
        if (_hasRescheduleReason) 10.verticalSpace,
        if (_hasRescheduleReason) ...{
          RescheduleRequestWidget(
            patientName: appointment.doctorId.fullName,
            patientImage: appointment.doctorId.profileImage ?? '',
            rescheduleReason: appointment.isReschedule?.reason,
            onAccept: () {
               appointmentController.acceptRescheduleRequest(appointment.id);
            },
            onReject: () {
              appointmentController.rejectRescheduleRequest(appointment.id);
            },
          ),
        } else if (_hasRescheduleStatus) ...{
          Align(
            alignment: AlignmentGeometry.centerLeft,
            child: AppointmentStatusWidget(
              status: appointment.isReschedule!.isAccept,
            ),
          ),
        },
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: AlignmentDirectional.topStart,
          child: Text(
            AppStrings.notes.tr,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              fontFamily: AppFonts.jakartaBold,
            ),
          ),
        ),
        10.verticalSpace,
        Text(
          appointment.notes ?? AppStrings.medicalNotesDemo.tr,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            fontFamily: AppFonts.jakartaMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return (appointment.status == AppointmentStatus.confirmed &&
            appointment.isReschedule!.isAccept != "pending")
        ? Column(
          children: [
            CustomButton(
              borderRadius: 15,
              text: AppStrings.joinConsultation.tr,
              onTap: () {
                Get.to(PreviewScreen(appointment: appointment));
              },
            ),
            10.verticalSpace,
            CustomButton(
              borderRadius: 15,
              text: AppStrings.reschedule.tr,
              onTap: () {
                Get.to(
                  PatientReschduleAppoinmentScreen(
                    appointmentId: appointment.id,
                    doctorId: appointment.doctorId.id,
                  ),
                );
              },
              bgColor: AppColors.inACtiveButtonColor,
              fontColor: Colors.black,
            ),
          ],
        )
        : SizedBox();
  }

  String _getConsultationTypeEmoji(ConsultationType type) {
    switch (type) {
      case ConsultationType.homevisit:
        return '🏠';
      case ConsultationType.inperson:
        return '🏥';
      case ConsultationType.remote:
        return '📱';
      case ConsultationType.video:
        return '📹';
    }
  }

  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return Colors.orange;
      case AppointmentStatus.confirmed:
        return Colors.green;
      case AppointmentStatus.completed:
        return Colors.blue;
      case AppointmentStatus.cancelled:
        return Colors.red;
      case AppointmentStatus.ongoing:
        return Colors.purple;
      case AppointmentStatus.rescheduled:
        return Colors.amber;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final appointmentDay = DateTime(date.year, date.month, date.day);

    if (appointmentDay == today) {
      return "Today";
    } else if (appointmentDay == today.add(Duration(days: 1))) {
      return "Tomorrow";
    } else {
      final weekdayMap = {
        1: 'Monday',
        2: 'Tuesday',
        3: 'Wednesday',
        4: 'Thursday',
        5: 'Friday',
        6: 'Saturday',
        7: 'Sunday',
      };

      final monthMap = {
        1: 'January',
        2: 'February',
        3: 'March',
        4: 'April',
        5: 'May',
        6: 'June',
        7: 'July',
        8: 'August',
        9: 'September',
        10: 'October',
        11: 'November',
        12: 'December',
      };

      final weekday = weekdayMap[date.weekday] ?? 'Day';
      final month = monthMap[date.month] ?? 'Month';

      return '$weekday, ${date.day} $month ${date.year}';
    }
  }

  String _formatTime(DateTime startTime, DateTime endTime) {
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
}
