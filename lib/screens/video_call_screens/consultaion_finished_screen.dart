
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/appointment_controllers/feedback_controller.dart';

import '../../utils/app_colors.dart';

class ConsultaionFinishedScreen extends StatelessWidget {
  ConsultaionFinishedScreen({super.key});

  @override
  FeedbackController controller = Get.put(FeedbackController());

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
          padding:  EdgeInsets.symmetric(horizontal: 20.sp),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 70.verticalSpace,
                Row(
                  children: const [
                    Icon(Icons.check_circle, color: Colors.green, size: 36),
                    SizedBox(width: 10),
                    Text(
                      'Consultation Finished',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Thank You For Visiting Dr. Maria Waston',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 50),
                const Text(
                  'How would you rate this\nvisit?',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.2),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Obx(() => Center(child: _buildStarRating())),
                const SizedBox(height: 40),
                Container(
                  height: 250.h,
                  child: TextField(
                    onChanged: controller.updateReviewText,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      hintText: 'Tell us about your experience......',
                      hintStyle:  TextStyle(color:AppColors.darkGrey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildBottomButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final rating = index + 1;
        return IconButton(
          icon: Icon(
            Icons.star,
            size: 48,
            color: controller.selectedRating.value >= rating
                ? Colors.amber
                : AppColors.lightGrey.withOpacity(0.2),
          ),
          onPressed: () => controller.setRating(rating),
        );
      }),
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: controller.viewPrescription,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade100,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child:  Text(
                'View Prescription',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Obx(() => SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: controller.isSendButtonEnabled ? controller.sendFeedback : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4285F4),
                disabledBackgroundColor: const Color(0xFF4285F4).withOpacity(0.5),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child:  Text(
                'Send',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          )),
        ),
      ],
    );
  }
}