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
  List<String> ratingList=[
    "5 stars",
    "3 stars",
    "1 star",
    "2 stars",
    "4 stars",
  ];
  RxString selectedPeriod="7 days".obs;
  RxString selectedRating="5 stars".obs;
}