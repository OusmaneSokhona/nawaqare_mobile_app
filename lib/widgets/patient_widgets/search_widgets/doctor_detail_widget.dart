import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/models/doctor_model.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';

class DoctorDetailWidget extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorDetailWidget({super.key, required this.doctor});

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

  String _getExperienceText() {
    if (doctor.experience != null && doctor.experience! > 0) {
      return '${doctor.experience} ${AppStrings.years.tr}';
    }
    return AppStrings.notAvailable.tr;
  }

  String _getFeeText() {
    if (doctor.fee != null) {
      final fee = doctor.fee!;
      final List<String> feeLines = [];

      if (fee.remoteConsultation != null) {
        feeLines.add('Remote Consultation: ${fee.displayRemoteFee}');
      }

      if (fee.inPersonConsultation != null) {
        feeLines.add('In-Person Consultation: ${fee.displayInPersonFee}');
      }

      if (fee.homeVisitConsultation != null) {
        feeLines.add('Home Visit Consultation: ${fee.displayHomeVisitFee}');
      }

      if (feeLines.isNotEmpty) {
        return feeLines.join('\n');
      }
    }
    return AppStrings.notAvailable.tr;
  }

  String _getLanguages() {
    final languages = <String>[];
    if (doctor.nationality?.isNotEmpty == true) {
      languages.add(doctor.nationality!);
    }
    if (doctor.country?.isNotEmpty == true) {
      languages.add(doctor.country!);
    }
    if (languages.isEmpty) {
      return 'English';
    }
    return languages.join(', ');
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
            doctor.aboutMe?.isNotEmpty == true ? doctor.aboutMe! : "Not Available",
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
            _getExperienceText(),
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[900],
            ),
          ),
          const SizedBox(height: 16),
          _buildDivider(),

          _buildSectionTitle(AppStrings.feesLabel.tr),
          Text(
            _getFeeText(),
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[900],
            ),
          ),
          const SizedBox(height: 16),
          _buildDivider(),

          _buildSectionTitle(AppStrings.clinicAddress.tr),
          Text(
            doctor.clinicAddress?.isNotEmpty == true ? doctor.clinicAddress! : AppStrings.notAvailable.tr,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[900],
            ),
          ),
          const SizedBox(height: 16),
          _buildDivider(),

          _buildSectionTitle(AppStrings.languages.tr),
          Text(
            _getLanguages(),
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
                    color: AppColors.primaryColor,
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
                backgroundColor: Colors.grey[200],
                child: doctor.displayImage.startsWith('http')
                    ? ClipOval(
                  child: Image.network(
                    doctor.displayImage,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/demo_images/doctor_1.png',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                )
                    : Image.asset(
                  doctor.displayImage,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.displayName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildStarRating(doctor.ratingValue),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          Text(
            doctor.aboutMe?.isNotEmpty == true
                ? doctor.aboutMe!
                : '${doctor.displayName} is a professional doctor providing quality healthcare services.',
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