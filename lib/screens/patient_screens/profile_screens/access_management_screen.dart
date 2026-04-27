import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/access_management_controller.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_images.dart';

class AccessManagementScreen extends StatelessWidget {
  AccessManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AccessManagementController controller = Get.put(AccessManagementController());

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
                            onPressed: controller.fetchAllAccessData,
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

                  return RefreshIndicator(
                    onRefresh: controller.refreshAccessData,
                    color: AppColors.primaryColor,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Medical Data Consent Section
                          _buildConsentSection(controller),
                          24.verticalSpace,
                          // Who can access my data
                          _buildAuthorizedActorsSection(controller),
                          24.verticalSpace,
                          // Access history
                          _buildAccessHistorySection(controller),
                          24.verticalSpace,
                          // Emergency access info
                          _buildEmergencyAccessSection(),
                          24.verticalSpace,
                          // Notification preferences
                          _buildNotificationPreferencesSection(controller),
                          24.verticalSpace,
                        ],
                      ),
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
            'Access & Privacy',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              fontFamily: AppFonts.jakartaBold,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.lock_outlined,
            color: AppColors.primaryColor,
            size: 24.sp,
          ),
        ],
      ),
    );
  }

  /// Build consent section
  Widget _buildConsentSection(AccessManagementController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Medical Data Consent',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        12.verticalSpace,
        Container(
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
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Allow data sharing',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontFamily: AppFonts.jakartaBold,
                        ),
                      ),
                      6.verticalSpace,
                      Text(
                        'Authorized healthcare providers can access your medical records',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.lightGrey,
                          fontFamily: AppFonts.jakartaMedium,
                        ),
                      ),
                    ],
                  ),
                  Obx(
                    () => Switch(
                      value: controller.medicalDataConsent.value,
                      onChanged: (_) => controller.toggleMedicalDataConsent(),
                      activeColor: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
              if (controller.consentGrantedDate.value != null) ...[
                12.verticalSpace,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    'Granted on ${_formatDate(controller.consentGrantedDate.value!)}',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.green,
                      fontFamily: AppFonts.jakartaMedium,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// Build authorized actors section
  Widget _buildAuthorizedActorsSection(AccessManagementController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Who can access my data',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        12.verticalSpace,
        Obx(
          () {
            if (controller.authorizedActors.isEmpty) {
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
                padding: EdgeInsets.all(16.w),
                child: Center(
                  child: Text(
                    'No authorized actors yet',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.lightGrey,
                      fontFamily: AppFonts.jakartaMedium,
                    ),
                  ),
                ),
              );
            }

            return Column(
              children: [
                ...controller.authorizedActors.map((actor) {
                  return _buildActorCard(actor, controller);
                }).toList(),
              ],
            );
          },
        ),
      ],
    );
  }

  /// Build individual actor card
  Widget _buildActorCard(AuthorizedActor actor, AccessManagementController controller) {
    final icon = controller.getActorTypeIcon(actor.type);
    final typeLabel = controller.getActorTypeLabel(actor.type);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Text(icon, style: TextStyle(fontSize: 22.sp)),
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      actor.name,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontFamily: AppFonts.jakartaBold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.verticalSpace,
                    Text(
                      typeLabel,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.lightGrey,
                        fontFamily: AppFonts.jakartaMedium,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => _showRevokeDialog(controller, actor),
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Icon(
                    Icons.close,
                    color: AppColors.red,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),
          if (actor.institution != null) ...[
            12.verticalSpace,
            Text(
              'Institution: ${actor.institution}',
              style: TextStyle(
                fontSize: 10.sp,
                color: AppColors.lightGrey,
                fontFamily: AppFonts.jakartaMedium,
              ),
            ),
          ],
          8.verticalSpace,
          Text(
            'Authorized on ${_formatDate(actor.authorizedDate)}',
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.lightGrey,
              fontFamily: AppFonts.jakartaMedium,
            ),
          ),
        ],
      ),
    );
  }

  /// Show revoke confirmation dialog
  void _showRevokeDialog(AccessManagementController controller, AuthorizedActor actor) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Revoke Access?',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        content: Text(
          'Are you sure you want to revoke access for ${actor.name}? They will no longer be able to view your medical records.',
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.darkGrey,
            fontFamily: AppFonts.jakartaMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
                fontFamily: AppFonts.jakartaBold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.revokeActorAccess(actor.id);
            },
            child: Text(
              'Revoke',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.red,
                fontWeight: FontWeight.w600,
                fontFamily: AppFonts.jakartaBold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build access history section
  Widget _buildAccessHistorySection(AccessManagementController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Access History',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        12.verticalSpace,
        Obx(
          () {
            final history = controller.accessHistory.take(5).toList();

            if (history.isEmpty) {
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
                padding: EdgeInsets.all(16.w),
                child: Center(
                  child: Text(
                    'No access history',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.lightGrey,
                      fontFamily: AppFonts.jakartaMedium,
                    ),
                  ),
                ),
              );
            }

            return Column(
              children: [
                ...history.map((log) {
                  return _buildAccessLogItem(log);
                }).toList(),
                if (controller.accessHistory.length > 5) ...[
                  12.verticalSpace,
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Get.snackbar(
                          'Full History',
                          'Complete access history coming soon',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      child: Text(
                        'View All History',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppFonts.jakartaBold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  /// Build access log item
  Widget _buildAccessLogItem(AccessLog log) {
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
          Row(
            children: [
              Text(
                '📋',
                style: TextStyle(fontSize: 18.sp),
              ),
              8.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      log.actorName,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontFamily: AppFonts.jakartaBold,
                      ),
                    ),
                    2.verticalSpace,
                    Text(
                      log.action,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.lightGrey,
                        fontFamily: AppFonts.jakartaMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          8.verticalSpace,
          Text(
            _formatDate(log.accessDate),
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.lightGrey,
              fontFamily: AppFonts.jakartaMedium,
            ),
          ),
        ],
      ),
    );
  }

  /// Build emergency access info section
  Widget _buildEmergencyAccessSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Emergency Access',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        12.verticalSpace,
        Container(
          decoration: BoxDecoration(
            color: AppColors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.orange.withOpacity(0.3)),
          ),
          padding: EdgeInsets.all(14.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ℹ️',
                style: TextStyle(fontSize: 20.sp),
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Emergency Access Protocol',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.orange,
                        fontFamily: AppFonts.jakartaBold,
                      ),
                    ),
                    8.verticalSpace,
                    Text(
                      'In medical emergencies, authorized healthcare providers may access your complete medical records regardless of your current consent settings.',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.darkGrey,
                        fontFamily: AppFonts.jakartaMedium,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build notification preferences section
  Widget _buildNotificationPreferencesSection(AccessManagementController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notification Preferences',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        12.verticalSpace,
        Container(
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
          padding: EdgeInsets.all(12.w),
          child: Column(
            children: [
              _buildPreferenceToggle(
                'Notify when my data is accessed',
                controller.notifyOnAccess,
                () => controller.updateNotificationPreference('access', !controller.notifyOnAccess.value),
              ),
              Divider(color: AppColors.inACtiveButtonColor),
              _buildPreferenceToggle(
                'Notify on consent changes',
                controller.notifyOnConsent,
                () => controller.updateNotificationPreference('consent', !controller.notifyOnConsent.value),
              ),
              Divider(color: AppColors.inACtiveButtonColor),
              _buildPreferenceToggle(
                'Notify when access is revoked',
                controller.notifyOnRevokedAccess,
                () => controller.updateNotificationPreference('revoked', !controller.notifyOnRevokedAccess.value),
              ),
            ],
          ),
        ),
        12.verticalSpace,
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightWhite,
            borderRadius: BorderRadius.circular(10.r),
          ),
          padding: EdgeInsets.all(10.w),
          child: Text(
            'Messages may be added to your medical record',
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.lightGrey,
              fontFamily: AppFonts.jakartaMedium,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  /// Build preference toggle
  Widget _buildPreferenceToggle(String label, RxBool value, VoidCallback onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.darkGrey,
              fontFamily: AppFonts.jakartaMedium,
            ),
          ),
          Obx(
            () => Switch(
              value: value.value,
              onChanged: (_) => onChanged(),
              activeColor: AppColors.primaryColor,
            ),
          ),
        ],
      ),
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
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final eventDay = DateTime(date.year, date.month, date.day);

    if (eventDay == today) {
      return 'Today at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (eventDay == yesterday) {
      return 'Yesterday at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    }
  }
}
