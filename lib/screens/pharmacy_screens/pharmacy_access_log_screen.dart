import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/pharmacy_controllers/pharmacy_access_log_controller.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';

class PharmacyAccessLogScreen extends StatelessWidget {
  PharmacyAccessLogScreen({super.key});

  final PharmacyAccessLogController controller = Get.put(
    PharmacyAccessLogController(),
  );

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
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              70.verticalSpace,
              // Bouton retour
              InkWell(
                onTap: () => Get.back(),
                child: Icon(Icons.arrow_back, size: 25.sp),
              ),
              15.verticalSpace,
              // Titre
              Text(
                'Logs d\'Accès',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 23.sp,
                  fontWeight: FontWeight.w800,
                  fontFamily: AppFonts.jakartaBold,
                ),
              ),
              8.verticalSpace,
              Text(
                'Historique des actions sur les prescriptions',
                style: TextStyle(
                  color: AppColors.lightGrey,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              15.verticalSpace,
              // Filtres
              _buildFilterSection(),
              15.verticalSpace,
              // Liste des logs
              Expanded(
                child: Obx(
                  () => controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : controller.filteredLogs.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.history,
                                    size: 50.sp,
                                    color: AppColors.lightGrey,
                                  ),
                                  10.verticalSpace,
                                  Text(
                                    'Aucun log disponible',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.lightGrey,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: controller.filteredLogs.length,
                              itemBuilder: (context, index) {
                                final log = controller.filteredLogs[index];
                                return _buildLogItem(log);
                              },
                            ),
                ),
              ),
              15.verticalSpace,
              // Section info
              _buildInfoSection(),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.sp),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(
              'Tous',
              'all',
              controller.selectedFilter,
              () => controller.applyFilter('all'),
            ),
            8.horizontalSpace,
            _buildFilterChip(
              'Délivrance',
              'dispensing',
              controller.selectedFilter,
              () => controller.applyFilter('dispensing'),
            ),
            8.horizontalSpace,
            _buildFilterChip(
              'Consultation',
              'consultation',
              controller.selectedFilter,
              () => controller.applyFilter('consultation'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String value,
    RxString selectedFilter,
    VoidCallback onTap,
  ) {
    return Obx(
      () => InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: selectedFilter.value == value
                ? AppColors.primaryColor
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16.sp),
            border: Border.all(
              color: selectedFilter.value == value
                  ? AppColors.primaryColor
                  : Colors.grey.shade300,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: selectedFilter.value == value
                  ? Colors.white
                  : AppColors.darkGrey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogItem(AccessLogEntry log) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.sp),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec icône et action
          Row(
            children: [
              // Icône d'action
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: _getActionColor(log.action).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.sp),
                ),
                child: Text(
                  log.actionIcon,
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
              12.horizontalSpace,
              // Info action
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      log.actionLabel,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      'Prescription #${log.resourceId}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.lightGrey,
                      ),
                    ),
                  ],
                ),
              ),
              // Date/Heure
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatDate(log.createdAt),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGrey,
                    ),
                  ),
                  3.verticalSpace,
                  Text(
                    _formatTime(log.createdAt),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.lightGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Détails supplémentaires si présents
          if (log.details != null) ...[
            10.verticalSpace,
            Divider(color: Colors.grey.shade300),
            10.verticalSpace,
            _buildDetailsSection(log.details!),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailsSection(Map<String, dynamic> details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: details.entries.map((entry) {
        return Padding(
          padding: EdgeInsets.only(bottom: 5.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 80.w,
                child: Text(
                  '${entry.key}:',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.lightGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  entry.value.toString(),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.darkGrey,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8.sp),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.info, color: AppColors.primaryColor, size: 18.sp),
          12.horizontalSpace,
          Expanded(
            child: Text(
              'Vous ne voyez que les activités de votre propre pharmacie.',
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.primaryColor,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getActionColor(String action) {
    switch (action.toUpperCase()) {
      case 'READ':
        return Colors.blue;
      case 'WRITE':
        return Colors.orange;
      case 'EXPORT':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return 'Aujourd\'hui';
    } else if (date == yesterday) {
      return 'Hier';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}