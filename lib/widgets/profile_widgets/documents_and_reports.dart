import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/profile_controller.dart';
import 'package:patient_app/widgets/profile_widgets/heatlh_space_grid.dart';

import '../../models/profile_models.dart';

class DocumentsAndReportsProfile extends GetView<ProfileController> {
  DocumentsAndReportsProfile({super.key});


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
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Hello, ${controller.user.value.name.split(' ').first}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
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
              child: const Text('Upload now', style: TextStyle(fontSize: 16)),
            ),
          ),
         15.verticalSpace,
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount:controller.documents.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _buildDocumentItem(controller.documents[index]);
            },
          ),
          const SizedBox(height: 30),
          const Text(
            'Health Space',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          HeatlhSpaceGrid(profileController: controller),

        ],
      ),
    );
  }

  Widget _buildDocumentItem(Document doc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
      child: Row(
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
                  doc.type,
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
                      doc.date,
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
            onPressed: () => Get.snackbar('Action', 'Viewing ${doc.type}'),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
            onPressed: () => Get.snackbar('Action', 'Deleting ${doc.type}'),
          ),
        ],
      ),
    );
  }
}
