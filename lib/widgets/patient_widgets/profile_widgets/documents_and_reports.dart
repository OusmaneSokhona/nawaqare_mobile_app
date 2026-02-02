import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/home_controller.dart';
import 'package:patient_app/controllers/patient_controllers/profile_controller.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../../screens/document_view_screen.dart';
import 'heatlh_space_grid.dart';

class DocumentsAndReportsProfile extends GetView<ProfileController> {
  const DocumentsAndReportsProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();

    return Obx(() {
      final user = homeController.currentUser.value;
      final userName = user?.fullName ?? '';
      final userImage = user?.patientData?.profileImage;
      final userReports = user?.patientData?.reports ?? [];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: CircleAvatar(
              radius: 50.w,
              backgroundColor: Colors.white,
              backgroundImage: userImage != null && userImage.isNotEmpty
                  ? NetworkImage(userImage)
                  : AssetImage("assets/demo_images/home_demo_image.png") as ImageProvider,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              '${AppStrings.hello.tr} ${userName.isNotEmpty ? userName.split(' ').first : AppStrings.user.tr}',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 88.w),
            child: ElevatedButton(
              onPressed: controller.uploadNewDocument,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                AppStrings.uploadNew.tr,
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ),
          15.verticalSpace,
          Container(
            height: userReports.length<2?0.10.sh:0.26.sh,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: userReports.isNotEmpty
                ? ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: userReports.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _buildDocumentItem(userReports[index], index < userReports.length - 1);
              },
            )
                : Center(
              child: Padding(
                padding: EdgeInsets.all(20.sp),
                child: Text(
                  AppStrings.noDocuments.tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            AppStrings.docsAndReports.tr,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          HeatlhSpaceGrid(profileController: controller),
        ],
      );
    });
  }

  Widget _buildDocumentItem(String reportUrl, bool showDivider) {
    final fileName = reportUrl.split('/').last;
    final fileType = fileName.split('.').last.toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.description,
                color: const Color(0xFF3B82F6).withOpacity(0.8),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName.length > 30 ? '${fileName.substring(0, 30)}...' : fileName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 14,
                          color: Colors.green.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          fileType,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.remove_red_eye_outlined,
                  color: Colors.grey.shade600,
                ),
                onPressed: () {
                  Get.to(
                        () => DocumentViewerScreen(
                      documentUrl: reportUrl,
                      fileName: 'My Report',
                    ),
                  );

                },
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
                onPressed: () {
                  // Handle delete
                  Get.snackbar(
                    AppStrings.action.tr,
                    '${AppStrings.deleting.tr} $fileName',
                  );
                },
              ),
            ],
          ),
          showDivider
              ? Divider(
            color: Colors.grey.shade300,
            thickness: 1,
            height: 20,
          )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}