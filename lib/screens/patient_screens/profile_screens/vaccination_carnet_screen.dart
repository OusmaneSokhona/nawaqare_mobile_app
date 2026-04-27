import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/vaccination_controller.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_images.dart';

class VaccinationCarnetScreen extends StatelessWidget {
  VaccinationCarnetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final VaccinationController controller = Get.put(VaccinationController());

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
            _buildHeader(controller),
            // Tab buttons
            _buildTabButtons(controller),
            // Content
            Expanded(
              child: Obx(
                () {
                  if (controller.isLoading.value && controller.allVaccinations.isEmpty) {
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
                            onPressed: controller.fetchVaccinations,
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

                  final displayList = controller.activeTab.value == 'My Vaccines'
                      ? controller.completedVaccinations
                      : controller.upcomingVaccinations;

                  if (displayList.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.vaccines,
                            size: 60.sp,
                            color: AppColors.lightGrey,
                          ),
                          16.verticalSpace,
                          Text(
                            controller.activeTab.value == 'My Vaccines'
                                ? 'No completed vaccinations'
                                : 'No upcoming vaccinations',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkGrey,
                              fontFamily: AppFonts.jakartaBold,
                            ),
                          ),
                          8.verticalSpace,
                          Text(
                            'Your vaccination records will appear here',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.lightGrey,
                              fontFamily: AppFonts.jakartaMedium,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: controller.refreshVaccinations,
                    color: AppColors.primaryColor,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      itemCount: displayList.length,
                      itemBuilder: (context, index) {
                        final vaccine = displayList[index];
                        return _buildVaccineCard(vaccine, controller);
                      },
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
  Widget _buildHeader(VaccinationController controller) {
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
            'Vaccination Carnet',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              fontFamily: AppFonts.jakartaBold,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.vaccines_outlined,
            color: AppColors.primaryColor,
            size: 24.sp,
          ),
        ],
      ),
    );
  }

  /// Build tab buttons
  Widget _buildTabButtons(VaccinationController controller) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          children: [
            Expanded(
              child: _buildTabButton(
                'My Vaccines',
                controller.activeTab.value == 'My Vaccines',
                () => controller.switchTab('My Vaccines'),
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: _buildTabButton(
                'Upcoming',
                controller.activeTab.value == 'Upcoming',
                () => controller.switchTab('Upcoming'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build individual tab button
  Widget _buildTabButton(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primaryColor : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? AppColors.primaryColor : AppColors.lightGrey,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
      ),
    );
  }

  /// Build individual vaccine card
  Widget _buildVaccineCard(VaccinationRecord vaccine, VaccinationController controller) {
    final statusColor = _getStatusColor(vaccine.status);

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
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
        child: Padding(
          padding: EdgeInsets.all(14.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Vaccine name and status badge
              Row(
                children: [
                  // Vaccine icon
                  Container(
                    width: 44.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Text(
                        '💉',
                        style: TextStyle(fontSize: 22.sp),
                      ),
                    ),
                  ),
                  12.horizontalSpace,
                  // Vaccine name and dose info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vaccine.vaccineName,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontFamily: AppFonts.jakartaBold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        4.verticalSpace,
                        Text(
                          'Dose ${vaccine.doseNumber} of ${vaccine.totalDoses}',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.lightGrey,
                            fontFamily: AppFonts.jakartaMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      controller.getStatusLabel(vaccine.status),
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                        fontFamily: AppFonts.jakartaBold,
                      ),
                    ),
                  ),
                ],
              ),
              12.verticalSpace,
              // Divider
              Container(
                height: 1,
                color: AppColors.inACtiveButtonColor,
              ),
              12.verticalSpace,
              // Admin info and dates
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Given on',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.lightGrey,
                          fontFamily: AppFonts.jakartaMedium,
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        _formatDate(vaccine.dateGiven),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontFamily: AppFonts.jakartaBold,
                        ),
                      ),
                      if (vaccine.administeredBy != null) ...[
                        8.verticalSpace,
                        Text(
                          'by ${vaccine.administeredBy}',
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: AppColors.lightGrey,
                            fontFamily: AppFonts.jakartaMedium,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                  // Next due date reminder
                  if (vaccine.nextDueDate != null && vaccine.isReminderDue)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: AppColors.orange.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rappel prévu',
                            style: TextStyle(
                              fontSize: 9.sp,
                              color: AppColors.orange,
                              fontWeight: FontWeight.w700,
                              fontFamily: AppFonts.jakartaBold,
                            ),
                          ),
                          4.verticalSpace,
                          Text(
                            _formatDate(vaccine.nextDueDate!),
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.orange,
                              fontFamily: AppFonts.jakartaBold,
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (vaccine.nextDueDate != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Next due',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.lightGrey,
                            fontFamily: AppFonts.jakartaMedium,
                          ),
                        ),
                        4.verticalSpace,
                        Text(
                          _formatDate(vaccine.nextDueDate!),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontFamily: AppFonts.jakartaBold,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              // Download certificate button
              if (vaccine.isCompleted) ...[
                12.verticalSpace,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => controller.downloadCertificate(vaccine.id),
                    icon: Icon(
                      Icons.download_outlined,
                      size: 14.sp,
                    ),
                    label: Text(
                      'Download Certificate',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.jakartaBold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Get status color
  Color _getStatusColor(String status) {
    switch (status) {
      case 'COMPLETED':
        return AppColors.green;
      case 'SCHEDULED':
        return AppColors.orange;
      case 'OVERDUE':
        return AppColors.red;
      default:
        return AppColors.lightGrey;
    }
  }

  /// Format date
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
