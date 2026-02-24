import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/patient_controllers/appointment_controllers/feedback_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_strings.dart';

class ConsultaionFinishedScreen extends StatelessWidget {
  final String appointmentId;
  final String doctorName;
  final Function onComplete;

  const ConsultaionFinishedScreen({
    super.key,
    required this.appointmentId,
    required this.doctorName,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final FeedbackController controller = Get.put(
      FeedbackController(appointmentId: appointmentId),
    );
    print("id = ${appointmentId}");

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
          padding: EdgeInsets.symmetric(horizontal: 20.sp),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                70.verticalSpace,
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 36),
                    const SizedBox(width: 10),
                    Text(
                      AppStrings.consultationFinished.tr,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.thankYouDoctor.trParams({'name': doctorName}),
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 50),
                Center(
                  child: Text(
                    AppStrings.visitRatingTitle.tr,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.2),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                Obx(() => Center(child: _buildStarRating(controller))),
                const SizedBox(height: 40),
                SizedBox(
                  height: 250.h,
                  child: TextField(
                    onChanged: controller.updateReviewText,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      hintText: AppStrings.feedbackHint.tr,
                      hintStyle: TextStyle(color: AppColors.darkGrey),
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
                _buildBottomButtons(controller),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStarRating(FeedbackController controller) {
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

  Widget _buildBottomButtons(FeedbackController controller) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed:(){
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade100,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                AppStrings.back.tr,
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
              onPressed: (){
                controller.isSendButtonEnabled ? controller.sendFeedback(onComplete): null;
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4285F4),
                disabledBackgroundColor: const Color(0xFF4285F4).withOpacity(0.5),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: controller.isSubmitting.value
                  ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : Text(
                AppStrings.send.tr,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          )),
        ),
      ],
    );
  }
}