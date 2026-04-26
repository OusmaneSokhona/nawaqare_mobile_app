import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/review_controller.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import 'package:patient_app/widgets/doctor_widgets/patient_widgets/filter_dopdown_button.dart';
import 'package:patient_app/widgets/doctor_widgets/statics_widgets/review_filter_bottom_sheet.dart';

import '../../../models/review_models.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';

class ReviewScreen extends StatelessWidget {
  ReviewScreen({Key? key}) : super(key: key);
  final ReviewsController controller = Get.put(ReviewsController());

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
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              70.verticalSpace,
              Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: Image.asset(
                      AppImages.backIcon,
                      height: 33.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    AppStrings.reviewsCount.tr, // Or create a generic 'Reviews' string
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSegmentedControl(),
                      const SizedBox(height: 24),
                      Obx(() => controller.selectedTab.value == 0
                          ? _buildPatientReviewsTab()
                          : _buildStatisticsTab()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientReviewsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.patientReviews.tr,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppStrings.feedbackSubtitle.tr,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.lightGrey,
          ),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          prefixIcon: Icons.search,
          suffixIcon: Icons.filter_list,
          prefixIconColor: AppColors.lightGrey,
          suffixIconColor: AppColors.primaryColor,
          hintText: AppStrings.searchByPatient.tr,
          onSuffixIconTap: () {
            Get.bottomSheet(
                backgroundColor: Colors.white,
                ReviewFilterBottomSheet(onApply: () {}, onReset: () {}));
          },
        ),
        const SizedBox(height: 24),
        _buildSummaryAndCriteria(),
        const SizedBox(height: 20),
        Obx(() => ListView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.reviews.length,
          itemBuilder: (context, index) {
            return _buildReviewCard(controller.reviews[index]);
          },
        )),
        30.verticalSpace,
      ],
    );
  }

  Widget _buildStatisticsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.performanceStatistics.tr,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppStrings.feedbackSubtitle.tr,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.lightGrey,
          ),
        ),
        10.verticalSpace,
         FilterControlBar(),
        10.verticalSpace,
        Obx(() {
          String imagePath = "assets/demo_images/demo1.png";
          if (controller.selectedActivityValue.value == "Performance") {
            imagePath = "assets/demo_images/demo2.png";
          } else if (controller.selectedActivityValue.value == "Compliance") {
            imagePath = "assets/demo_images/demo3.png";
          } else if (controller.selectedActivityValue.value != "Activity") {
            imagePath = "assets/demo_images/demo4.png";
          }
          return Image.asset(imagePath);
        }),
      ],
    );
  }

  Widget _buildReviewCard(Review review) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  review.imageUrl,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          review.reviewerName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        Text(
                          review.date,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          review.rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              Icons.star,
                              color: index < review.rating
                                  ? Colors.amber
                                  : Colors.grey.shade300,
                              size: 16.sp,
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Text(
          review.reviewText,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey.shade700,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {},
              child: Text(
                AppStrings.reply.tr,
                style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline),
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.flag_outlined, size: 16.sp, color: Colors.grey.shade600),
              label: Text(
                AppStrings.report.tr,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13.sp),
              ),
            ),
          ],
        ),
        Divider(height: 1.h, color: AppColors.lightGrey.withOpacity(0.3)),
      ],
    );
  }

  Widget _buildSegmentedControl() {
    return Obx(() => Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _buildSegmentButton(
            AppStrings.patientReviews.tr,
            controller.selectedTab.value == 0,
                () => controller.selectTab(0),
          ),
          _buildSegmentButton(
            AppStrings.statistics.tr,
            controller.selectedTab.value == 1,
                () => controller.selectTab(1),
          ),
        ],
      ),
    ));
  }

  Widget _buildSegmentButton(String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48.h,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryAndCriteria() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        Icons.star,
                        color: index < 4 ? Colors.amber : Colors.grey.shade300,
                        size: 18.sp,
                      );
                    }),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '4.0',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '05 ${AppStrings.reviewsCount.tr}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.ios_share, color: AppColors.primaryColor),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.criteria.tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.sp,
            ),
          ),
          const SizedBox(height: 8),
          _buildRatingBar(AppStrings.communication.tr, controller.communication.value),
          _buildRatingBar(AppStrings.clarity.tr, controller.clarity.value),
          _buildRatingBar(AppStrings.punctuality.tr, controller.punctuality.value),
          _buildRatingBar(AppStrings.behaviors.tr, controller.behaviors.value),
          _buildRatingBar(AppStrings.quality.tr, controller.quality.value),
        ],
      )),
    );
  }

  Widget _buildRatingBar(String criterion, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              criterion,
              maxLines: 1,
              style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade700),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 8.h,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}