import 'package:get/get.dart';

import '../../models/review_models.dart';

class ReviewsController extends GetxController {
  final RxInt selectedTab = 0.obs;

  final RxDouble communication = 0.8.obs;
  final RxDouble clarity = 0.9.obs;
  final RxDouble punctuality = 0.7.obs;
  final RxDouble behaviors = 0.5.obs;
  final RxDouble quality = 0.6.obs;

  final RxList<Review> reviews = <Review>[
    Review(
      reviewerName: 'Emily Anderson',
      reviewText: 'Dr. Patel is a true professional who genuinely cares about his patients. I highly recommend Dr. Patel to anyone seeking exceptional cardiac care.',
      rating: 5.0,
      date: '12/oct',
      imageUrl: 'assets/demo_images/patient_3.png',
    ),
    Review(
      reviewerName: 'Emily Anderson',
      reviewText: 'Dr. Patel is a true professional who genuinely cares about his patients. I highly recommend Dr. Patel to anyone seeking exceptional cardiac care.',
      rating: 5.0,
      date: '12/oct',
      imageUrl: 'assets/demo_images/patient_2.png',
    ),
    Review(
      reviewerName: 'Emily Anderson',
      reviewText: 'Dr. Patel is a true professional who genuinely cares about his patients. I highly recommend Dr. Patel to anyone seeking exceptional cardiac care.',
      rating: 5.0,
      date: '12/oct',
      imageUrl: 'assets/demo_images/patient_1.png',
    ),
  ].obs;

  void selectTab(int index) {
    selectedTab.value = index;
  }
  List<String> periodList=[
    "7 days",
    "14 days",
    "30 days",
    "60 days",
  ];
  List<String> activityList=[
    "Activity",
    "Performance",
    "Compliance",
    "Engagement",
  ];

  final Rx<String> activePillTitle = 'Export'.obs;

  // Initial values must match one of the items in the respective lists.
  final Rx<String> selectedTimeValue = '7 days'.obs; // Changed from '7d'
  final Rx<String> selectedActivityValue = 'Activity'.obs; // Changed from 'all'

  // Renaming to match usage and remove redundant/unused fields
  RxString selectedPeriod="7 days".obs;

  void setActivePill(String title) {
    activePillTitle.value = title;
  }

  void setTimeValue(String? newValue) {
    if (newValue != null) {
      selectedTimeValue.value = newValue;
      selectedPeriod.value = newValue;
    }
  }

  void setActivityValue(String? newValue) {
    if (newValue != null) {
      selectedActivityValue.value = newValue;
    }
  }

  void handleExportTap(String title) {
    setActivePill(title);
    print('$title button tapped!');
  }
}