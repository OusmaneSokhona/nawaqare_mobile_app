import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/auth_controllers/sign_up_controller.dart';
import 'package:patient_app/controllers/patient_controllers/home_controller.dart';
import 'package:patient_app/controllers/patient_controllers/profile_controller.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../../screens/document_view_screen.dart';
import 'heatlh_space_grid.dart';

class DocumentsAndReportsProfile extends GetView<ProfileController> {
  const DocumentsAndReportsProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    final SignUpController signUpController = Get.find<SignUpController>();

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
                  : const AssetImage("assets/demo_images/home_demo_image.png") as ImageProvider,
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
            child: Obx(
                  () => signUpController.isLoading.value
                  ? SizedBox(
                height: 45.h,
                width: 25.w,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                ),
              )
                  : ElevatedButton(
                onPressed: () async {
                  // Create a completer to wait for file selection
                  final completer = Completer<bool>();

                  // Set up a listener for the selectedFileName
                  late Worker worker;
                  worker = ever(signUpController.selectedFileName, (String? value) {
                    if (value != null && value.isNotEmpty) {
                      if (!completer.isCompleted) {
                        completer.complete(true);
                      }
                      worker.dispose();
                    }
                  });

                  // Call pickFileNew (don't await since it returns void)
                  signUpController.pickFileNew(signUpController.selectedFileName);

                  // Wait for file selection with timeout
                  try {
                    await completer.future.timeout(
                      const Duration(seconds: 30),
                      onTimeout: () {
                        if (!completer.isCompleted) {
                          completer.complete(false);
                          worker.dispose();
                        }
                        return false;
                      },
                    );

                    // Check if file was selected
                    if (signUpController.selectedFileName.value != null &&
                        signUpController.selectedFileName.value!.isNotEmpty) {
                      bool success = await signUpController.uploadDocuments();
                      if (success) {
                        // Clear the selected file after successful upload
                        signUpController.selectedFileName.value = null;
                        Get.snackbar(
                          "Success",
                          "Document uploaded successfully",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      }
                    } else {
                      Get.snackbar(
                        "No File Selected",
                        "Please select a file first",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                      );
                    }
                  } catch (e) {
                    // Timeout or error
                    worker.dispose();
                    Get.snackbar(
                      "Timeout",
                      "File selection timed out",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
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
          ),
          15.verticalSpace,
          Container(
            height: userReports.isEmpty
                ? 0.15.sh
                : (userReports.length < 2 ? 0.20.sh : 0.26.sh),
            padding: EdgeInsets.only(top: 10),
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
                return _buildDocumentItem(
                  userReports[index],
                  index < userReports.length - 1,
                  signUpController,
                  homeController,
                );
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

  Widget _buildDocumentItem(
      String reportUrl,
      bool showDivider,
      SignUpController signUpController,
      HomeController homeController,
      ) {
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
                      fileName: fileName,
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
                onPressed: () async {
                  // Show confirmation dialog
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Delete Document'),
                      content: const Text('Are you sure you want to delete this document?'),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Get.back(); // Close dialog
                            // TODO: Implement delete functionality
                            Get.snackbar(
                              'Info',
                              'Delete functionality to be implemented',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          if (showDivider)
            Divider(
              color: Colors.grey.shade300,
              thickness: 1,
              height: 20,
            ),
        ],
      ),
    );
  }
}