import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';

class DoctorDetailWidget extends StatelessWidget {
  // These would typically come from a model, but I've kept them here as per your snippet
  final String aboutMeText =
      'Dr. David Patel, a dedicated cardiologist, brings a wealth of experience to Golden Gate Cardiology Center in Golden Gate, CA.';
  final String experienceText = 'Charles Medical Office 2018 - Present';
  final String reviewerName = 'Emily Anderson';
  final double rating = 5.0;
  final String reviewText =
      'Dr. Patel is a true professional who genuinely cares about his patients. I highly recommend Dr. Patel to anyone seeking exceptional cardiac care.';
  final String reviewerImageUrl = 'assets/demo_images/Frame 1000000981.png';

  const DoctorDetailWidget({super.key});

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color.fromARGB(25, 0, 0, 0),
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor() ? Icons.star : Icons.star_border,
          color: Colors.orange,
          size: 18,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(AppStrings.aboutMe.tr),
          Text(
            aboutMeText.tr, // Translating the dynamic bio if keys exist
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          _buildDivider(),

          _buildSectionTitle(AppStrings.experienceLabel.tr),
          Text(
            experienceText.tr,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[900],
            ),
          ),
          const SizedBox(height: 16),
          _buildDivider(),

          _buildSectionTitle(AppStrings.feesLabel.tr),
          Text(
            AppStrings.consultationFeeText.tr,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[900],
            ),
          ),
          const SizedBox(height: 16),
          _buildDivider(),
          _buildSectionTitle(AppStrings.clinicAddress.tr),
          Text(
            "Degree College road, near Zarai Tarqiati Bank Limited, Bahawalnagar, Punjab",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[900],
            ),
          ),
          const SizedBox(height: 16),
          _buildDivider(),
          _buildSectionTitle(AppStrings.languages.tr),
          Text(
            "English, French, Arabic",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[900],
            ),
          ),
          const SizedBox(height: 16),
          _buildDivider(),
          _buildSectionTitle(AppStrings.acceptedPaymentMethod.tr),
          Text(
            "Credit / Debit card, Cash, Bank transfer",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[900],
            ),
          ),
          const SizedBox(height: 16),
          _buildDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionTitle(AppStrings.reviewOptional.tr),
              TextButton(
                onPressed: () {},
                child: Text(
                  AppStrings.seeAll.tr,
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primaryColor,
                    color:AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(reviewerImageUrl),
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reviewerName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildStarRating(rating),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          Text(
            reviewText.tr,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}