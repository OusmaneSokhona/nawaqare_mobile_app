import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/patient_controller.dart';
import 'package:patient_app/models/patient_model_doctor.dart';
import 'package:patient_app/widgets/doctor_widgets/patient_widgets/medical_record_widgets.dart';
import 'package:patient_app/widgets/doctor_widgets/patient_widgets/notes_widget.dart';
import 'package:patient_app/widgets/doctor_widgets/patient_widgets/patient_detail_card.dart';
import 'package:patient_app/widgets/doctor_widgets/patient_widgets/report_widget.dart';
import 'package:intl/intl.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../../widgets/patient_widgets/search_widgets/rating_widget.dart';

class PatientDetailScreen extends StatelessWidget {
  final PatientSummary patient;

  PatientDetailScreen({super.key, required this.patient});

  final PatientController patientController = Get.find<PatientController>();

  // Format date for display
  String get formattedLastAppointment {
    if (patient.lastAppointmentDate == null) return 'No appointments';
    return DateFormat('dd/MMM/yyyy').format(patient.lastAppointmentDate!);
  }

  @override
  Widget build(BuildContext context) {
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
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              70.verticalSpace,
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      20.verticalSpace,
                      PatientDetailCard(patientSummary: patient),
                      10.verticalSpace,
                      _buildStatsRow(),
                      10.verticalSpace,
                      _buildCategoryTabs(),
                      10.verticalSpace,
                      _buildCategoryContent(),
                      20.verticalSpace,
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

  Widget _buildAppBar() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Get.back();
          },
          child: Image.asset(
            AppImages.backIcon,
            height: 33.h,
            fit: BoxFit.fill,
          ),
        ),
        10.horizontalSpace,
        Text(
          AppStrings.patientDetails.tr,
          style: TextStyle(
            color: Colors.black,
            fontSize: 23.sp,
            fontWeight: FontWeight.w800,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            // Add more options like share, edit, etc.
            _showOptionsMenu();
          },
          icon: Icon(
            Icons.more_vert,
            color: AppColors.primaryColor,
            size: 24.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RatingWidget(
          icon: Icons.person_outline_outlined,
          iconCircleColor: AppColors.primaryColor,
          metricText: "${patient.totalAppointments}",
          labelText: AppStrings.totalConsultations.tr,
          width: 100.w,
        ),
        RatingWidget(
          icon: Icons.medical_services_outlined,
          iconCircleColor: AppColors.green,
          metricText: "${patient.totalAppointments > 0 ? (patient.totalAppointments * 0.3).toInt() : 0}+",
          labelText: AppStrings.lastPrescriptions.tr,
          width: 100.w,
        ),
        RatingWidget(
          icon: Icons.calendar_today_outlined,
          iconCircleColor: AppColors.orange,
          metricText: formattedLastAppointment,
          labelText: AppStrings.nextFollowUp.tr,
          width: 100.w,
        ),
      ],
    );
  }

  Widget _buildCategoryTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCategoryTab("Overview", AppStrings.overview.tr),
        _buildCategoryTab("Reports", AppStrings.reports.tr),
        _buildCategoryTab("Notes", AppStrings.notes.tr),
      ],
    );
  }

  Widget _buildCategoryTab(String value, String label) {
    return Obx(
          () => InkWell(
        onTap: () {
          patientController.selectedCategory.value = value;
        },
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: patientController.selectedCategory.value == value
                    ? AppColors.primaryColor
                    : AppColors.lightGrey,
              ),
            ),
            3.verticalSpace,
            Container(
              height: 3.h,
              width: 90.w,
              decoration: BoxDecoration(
                color: patientController.selectedCategory.value == value
                    ? AppColors.primaryColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryContent() {
    return Obx(
          () {
        switch (patientController.selectedCategory.value) {
          case "Overview":
            return MedicalRecordWidgets(patientId: patient.patientId);
          case "Reports":
            return ReportWidget(patientId: patient.patientId);
          case "Notes":
            return NotesWidget(patientId: patient.patientId);
          default:
            return MedicalRecordWidgets(patientId: patient.patientId);
        }
      },
    );
  }

  void _showOptionsMenu() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            20.verticalSpace,
            _buildOptionTile(
              Icons.edit_outlined,
              'Edit Patient',
                  () {
                Get.back();
                // Navigate to edit patient screen
              },
            ),
            _buildOptionTile(
              Icons.share_outlined,
              'Share Profile',
                  () {
                Get.back();
                // Share patient profile
              },
            ),
            _buildOptionTile(
              Icons.block_outlined,
              'Block Patient',
                  () {
                Get.back();
                _showBlockConfirmation();
              },
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? AppColors.primaryColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.black,
          fontSize: 16.sp,
          fontFamily: AppFonts.jakartaMedium,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showBlockConfirmation() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Block Patient',
          style: TextStyle(
            fontSize: 18.sp,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        content: Text(
          'Are you sure you want to block ${patient.fullName}?',
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: AppFonts.jakartaRegular,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.lightGrey,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
              // Implement block functionality
              Get.snackbar(
                'Blocked',
                'Patient has been blocked',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            },
            child: Text(
              'Block',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}