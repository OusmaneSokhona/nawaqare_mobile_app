import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/health_timeline_controller.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_images.dart';

class HealthTimelineScreen extends StatelessWidget {
  HealthTimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HealthTimelineController controller = Get.put(HealthTimelineController());

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
            // Event type filter chips
            _buildFilterChips(controller),
            // Timeline events list
            Expanded(
              child: Obx(
                () {
                  if (controller.isLoading.value && controller.timelineEvents.isEmpty) {
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
                            onPressed: controller.fetchTimelineEvents,
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

                  if (controller.timelineEvents.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_note,
                            size: 60.sp,
                            color: AppColors.lightGrey,
                          ),
                          16.verticalSpace,
                          Text(
                            'No medical events found',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkGrey,
                              fontFamily: AppFonts.jakartaBold,
                            ),
                          ),
                          8.verticalSpace,
                          Text(
                            'Your medical history will appear here',
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
                    onRefresh: controller.refreshTimeline,
                    color: AppColors.primaryColor,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                      itemCount: controller.timelineEvents.length,
                      itemBuilder: (context, index) {
                        final event = controller.timelineEvents[index];
                        return _buildTimelineCard(event, controller);
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

  /// Build the header with back button and title
  Widget _buildHeader(HealthTimelineController controller) {
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
            'Health Timeline',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              fontFamily: AppFonts.jakartaBold,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.calendar_today_outlined,
            color: AppColors.primaryColor,
            size: 24.sp,
          ),
        ],
      ),
    );
  }

  /// Build filter chips for event types
  Widget _buildFilterChips(HealthTimelineController controller) {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          children: [
            ...controller.eventTypes.map((type) {
              final isSelected = controller.selectedEventType.value == type;
              return Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: FilterChip(
                  label: Text(
                    type,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isSelected ? Colors.white : AppColors.darkGrey,
                      fontFamily: AppFonts.jakartaMedium,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (_) => controller.filterByEventType(type),
                  backgroundColor: AppColors.lightWhite,
                  selectedColor: AppColors.primaryColor,
                  side: BorderSide(
                    color: isSelected ? AppColors.primaryColor : AppColors.lightGrey,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                ),
              );
            }).toList(),
            if (controller.selectedEventType.value != 'All' ||
                controller.startDate.value != null ||
                controller.endDate.value != null)
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: InkWell(
                  onTap: controller.clearFilters,
                  child: Chip(
                    label: Text(
                      'Clear',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.red,
                        fontFamily: AppFonts.jakartaMedium,
                      ),
                    ),
                    backgroundColor: AppColors.lightWhite,
                    side: const BorderSide(color: AppColors.red),
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Build individual timeline event card
  Widget _buildTimelineCard(
    HealthTimelineEvent event,
    HealthTimelineController controller,
  ) {
    final formattedDate = _formatDate(event.date);

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: InkWell(
        onTap: () {
          Get.snackbar(
            'Event Details',
            'Detail view coming soon',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.primaryColor,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        },
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
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event icon
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: _getEventBackgroundColor(event.type),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Text(
                      controller.getEventIcon(event.type),
                      style: TextStyle(fontSize: 24.sp),
                    ),
                  ),
                ),
                16.horizontalSpace,
                // Event details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event type badge
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: _getEventBadgeColor(event.type),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          event.type.replaceAll('_', ' '),
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppFonts.jakartaBold,
                          ),
                        ),
                      ),
                      8.verticalSpace,
                      // Event title
                      Text(
                        event.title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontFamily: AppFonts.jakartaBold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      6.verticalSpace,
                      // Doctor and structure info
                      if (event.doctorName != null || event.structure != null)
                        Text(
                          '${event.doctorName ?? ''} ${event.structure != null ? '• ${event.structure}' : ''}',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.lightGrey,
                            fontFamily: AppFonts.jakartaMedium,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      8.verticalSpace,
                      // Date and time
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14.sp,
                            color: AppColors.lightGrey,
                          ),
                          6.horizontalSpace,
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.lightGrey,
                              fontFamily: AppFonts.jakartaMedium,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Arrow icon
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14.sp,
                  color: AppColors.lightGrey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Get background color for event icon
  Color _getEventBackgroundColor(String eventType) {
    switch (eventType) {
      case 'CONSULTATION':
        return AppColors.primaryColor.withOpacity(0.1);
      case 'PRESCRIPTION':
        return AppColors.green.withOpacity(0.1);
      case 'EXAM_ORDER':
        return AppColors.orange.withOpacity(0.1);
      case 'VACCINATION':
        return AppColors.red.withOpacity(0.1);
      default:
        return AppColors.lightGrey.withOpacity(0.1);
    }
  }

  /// Get badge color for event type
  Color _getEventBadgeColor(String eventType) {
    switch (eventType) {
      case 'CONSULTATION':
        return AppColors.primaryColor;
      case 'PRESCRIPTION':
        return AppColors.green;
      case 'EXAM_ORDER':
        return AppColors.orange;
      case 'VACCINATION':
        return AppColors.red;
      default:
        return AppColors.lightGrey;
    }
  }

  /// Format date to readable string
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final eventDay = DateTime(date.year, date.month, date.day);

    if (eventDay == today) {
      return 'Today at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (eventDay == yesterday) {
      return 'Yesterday at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day} ${_getMonthName(date.month)} ${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
  }

  /// Get month name from month number
  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}
