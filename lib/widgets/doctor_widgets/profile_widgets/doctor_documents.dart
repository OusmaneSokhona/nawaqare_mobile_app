import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_profile_controller.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/widgets/doctor_widgets/profile_widgets/doctor_health_space_grid.dart';
import 'package:patient_app/widgets/doctor_widgets/profile_widgets/document_item_widget.dart';
import 'package:patient_app/widgets/doctor_widgets/profile_widgets/profile_completion_loading.dart';

class DoctorDocuments extends StatelessWidget {
  DoctorDocuments({super.key});

  DoctorProfileController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: ClipOval(
              child: Image.asset(
                controller.user.value.profileImageUrl,
                width: 100.w,
                height: 100.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              controller.user.value.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
          Center(
            child: Text(
              'Last update: ${controller.user.value.lastUpdate}',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 52.w),
            child: ElevatedButton(
              onPressed: (){
                controller.editDocumentsInfo();
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
                'Re-upload Expired Document',
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ),
          10.verticalSpace,
          ProfileCompletionLoading(),
          15.verticalSpace,
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                DocumentItemWidget(
                  documentName: "National Identity Document.png",
                  documentStatus: "Uploaded",
                ),
                15.verticalSpace,
                DocumentItemWidget(
                  documentName: "Medical Diploma.JPEG",
                  documentStatus: "Pending review",
                ),
                15.verticalSpace,
                DocumentItemWidget(
                  documentName: "Registration Certificate.JPEG",
                  documentStatus: "Uploaded",
                ),
                15.verticalSpace,
                DocumentItemWidget(
                  documentName: "Professional Photo",
                  documentStatus: "Rejected",
                ),
                15.verticalSpace,
                DocumentItemWidget(documentName: "Liability Insurance Proof", documentStatus: "Expired"),
                15.verticalSpace,
                DocumentItemWidget(
                  documentName: "Bank Details Proof",
                  documentStatus: "Uploaded",
                  showDivider: false,
                ),
                7.verticalSpace,
                Container(
                  padding:  EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: AppColors.orange.withOpacity(0.3), // Use the same color for a smooth look
                      width: 1,
                    ),
                  ),
                  child:  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.error_outline,
                        color: AppColors.orange,
                        size: 24,
                      ),
                      SizedBox(width: 12.0),
                      // Banner Text
                      Expanded(
                        child: Text(
                          'All documents are encrypted and stored under HDS standards',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Color(0xFF333333),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 10.h),
          DoctorHealthSpaceGrid(profileController: controller),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
