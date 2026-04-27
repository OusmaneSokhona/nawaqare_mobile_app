import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/appointment_controllers/consultation_summary_controller.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_images.dart';

class ConsultationSummaryScreen extends StatelessWidget {
  ConsultationSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ConsultationSummaryController controller = Get.put(ConsultationSummaryController());

    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.onboardingBackground, AppColors.lightWhite],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Header
            _buildHeader(),
            // Content
            Expanded(
              child: Obx(
                () {
                  if (controller.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    );
                  }

                  if (controller.errorMessage.value.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 60.sp,
                            color: AppColors.red,
                          ),
                          16.verticalSpace,
                          Text(
                            controller.errorMessage.value,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.darkGrey,
                              fontFamily: AppFonts.jakartaMedium,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          16.verticalSpace,
                          ElevatedButton(
                            onPressed: controller.fetchConsultationSummary,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                            ),
                            child: Text(
                              'Retry',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white,
                                fontFamily: AppFonts.jakartaBold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final summary = controller.consultationSummary.value;
                  if (summary == null) {
                    return Center(
                      child: Text(
                        'No consultation data available',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.darkGrey,
                          fontFamily: AppFonts.jakartaMedium,
                        ),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Doctor info card
                        if (summary.doctorName != null || summary.consultationDate != null)
                          _buildDoctorInfoCard(summary),
                        20.verticalSpace,
                        // What the doctor found section
                        _buildSectionCard(
                          title: 'What the doctor found',
                          icon: '🔍',
                          content: controller.simplifyAssessment(summary.assessment),
                        ),
                        20.verticalSpace,
                        // My treatment section
                        if (summary.prescriptions.isNotEmpty) ...[
                          _buildPrescriptionsSection(summary),
                          20.verticalSpace,
                        ],
                        // What to do next section
                        _buildSectionCard(
                          title: 'What to do next',
                          icon: '📋',
                          content: controller.simplifyPlan(summary.plan),
                        ),
                        20.verticalSpace,
                        // When to seek help section
                        if (summary.followUpPlan != null &&
                            summary.followUpPlan!.redFlags.isNotEmpty) ...[
                          _buildRedFlagsSection(summary),
                          20.verticalSpace,
                        ],
                        // My exam orders section
                        if (summary.examOrders.isNotEmpty) ...[
                          _buildExamOrdersSection(summary),
                          20.verticalSpace,
                        ],
                        // Action buttons
                        _buildActionButtons(controller),
                        24.verticalSpace,
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build header with back button and title
  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(top: 60.h, left: 20.w, right: 20.w, bottom: 16.h),
      child: Row(
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: Image.asset(
              AppImages.backIcon,
              height: 30.h,
            ),
          ),
          12.horizontalSpace,
          Text(
            'Consultation Summary',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              fontFamily: AppFonts.jakartaBold,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.description_outlined,
            color: AppColors.primaryColor,
            size: 24.sp,
          ),
        ],
      ),
    );
  }

  /// Build doctor info card
  Widget _buildDoctorInfoCard(ConsultationSummary summary) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(14.w),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: Text('👨‍⚕️', style: TextStyle(fontSize: 24.sp)),
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  summary.doctorName ?? 'Doctor',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontFamily: AppFonts.jakartaBold,
                  ),
                ),
                4.verticalSpace,
                if (summary.consultationDate != null)
                  Text(
                    _formatDate(summary.consultationDate!),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.lightGrey,
                      fontFamily: AppFonts.jakartaMedium,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build generic section card
  Widget _buildSectionCard({
    required String title,
    required String icon,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              icon,
              style: TextStyle(fontSize: 20.sp),
            ),
            8.horizontalSpace,
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontFamily: AppFonts.jakartaBold,
              ),
            ),
          ],
        ),
        12.verticalSpace,
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.inACtiveButtonColor),
          ),
          padding: EdgeInsets.all(12.w),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.darkGrey,
              fontFamily: AppFonts.jakartaMedium,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  /// Build prescriptions section
  Widget _buildPrescriptionsSection(ConsultationSummary summary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '💊',
              style: TextStyle(fontSize: 20.sp),
            ),
            8.horizontalSpace,
            Text(
              'My treatment',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontFamily: AppFonts.jakartaBold,
              ),
            ),
          ],
        ),
        12.verticalSpace,
        Column(
          children: [
            ...summary.prescriptions.map((prescription) {
              return _buildPrescriptionItem(prescription);
            }).toList(),
          ],
        ),
      ],
    );
  }

  /// Build individual prescription item
  Widget _buildPrescriptionItem(Prescription prescription) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.inACtiveButtonColor),
      ),
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            prescription.medicationName,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              fontFamily: AppFonts.jakartaBold,
            ),
          ),
          8.verticalSpace,
          Text(
            'How to take: ${prescription.readableDosageFrequency}',
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.darkGrey,
              fontFamily: AppFonts.jakartaMedium,
            ),
          ),
          4.verticalSpace,
          Text(
            'Duration: ${prescription.readableDuration}',
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.darkGrey,
              fontFamily: AppFonts.jakartaMedium,
            ),
          ),
          if (prescription.notes != null && prescription.notes!.isNotEmpty) ...[
            8.verticalSpace,
            Text(
              'Notes: ${prescription.notes}',
              style: TextStyle(
                fontSize: 10.sp,
                color: AppColors.lightGrey,
                fontStyle: FontStyle.italic,
                fontFamily: AppFonts.jakartaMedium,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build red flags section
  Widget _buildRedFlagsSection(ConsultationSummary summary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '⚠️',
              style: TextStyle(fontSize: 20.sp),
            ),
            8.horizontalSpace,
            Text(
              'When to seek help',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontFamily: AppFonts.jakartaBold,
              ),
            ),
          ],
        ),
        12.verticalSpace,
        Container(
          decoration: BoxDecoration(
            color: AppColors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.red.withOpacity(0.3)),
          ),
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...summary.followUpPlan!.redFlags.map((flag) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '•',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      8.horizontalSpace,
                      Expanded(
                        child: Text(
                          flag,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.darkGrey,
                            fontFamily: AppFonts.jakartaMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  /// Build exam orders section
  Widget _buildExamOrdersSection(ConsultationSummary summary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '🔬',
              style: TextStyle(fontSize: 20.sp),
            ),
            8.horizontalSpace,
            Text(
              'My exam orders',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontFamily: AppFonts.jakartaBold,
              ),
            ),
          ],
        ),
        12.verticalSpace,
        Column(
          children: [
            ...summary.examOrders.map((exam) {
              return _buildExamOrderItem(exam);
            }).toList(),
          ],
        ),
      ],
    );
  }

  /// Build individual exam order item
  Widget _buildExamOrderItem(ExamOrder exam) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.inACtiveButtonColor),
      ),
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exam.examName,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              fontFamily: AppFonts.jakartaBold,
            ),
          ),
          if (exam.description != null && exam.description!.isNotEmpty) ...[
            8.verticalSpace,
            Text(
              exam.description!,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.darkGrey,
                fontFamily: AppFonts.jakartaMedium,
              ),
            ),
          ],
          if (exam.scheduledDate != null) ...[
            8.verticalSpace,
            Text(
              'Scheduled: ${_formatDate(exam.scheduledDate!)}',
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.lightGrey,
                fontFamily: AppFonts.jakartaMedium,
              ),
            ),
          ],
          if (exam.location != null && exam.location!.isNotEmpty) ...[
            4.verticalSpace,
            Text(
              'Location: ${exam.location}',
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.lightGrey,
                fontFamily: AppFonts.jakartaMedium,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build action buttons
  Widget _buildActionButtons(ConsultationSummaryController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: controller.downloadSummaryPdf,
          icon: Icon(Icons.download_outlined, size: 18.sp),
          label: Text(
            'Download Summary as PDF',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.jakartaBold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
        12.verticalSpace,
        OutlinedButton.icon(
          onPressed: () {
            Get.snackbar(
              'Prescriptions',
              'View full prescriptions coming soon',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
          icon: Icon(Icons.receipt_long_outlined, size: 18.sp),
          label: Text(
            'View Full Prescription',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor,
              fontFamily: AppFonts.jakartaBold,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primaryColor),
            padding: EdgeInsets.symmetric(vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
      ],
    );
  }

  /// Format date to readable string
  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
