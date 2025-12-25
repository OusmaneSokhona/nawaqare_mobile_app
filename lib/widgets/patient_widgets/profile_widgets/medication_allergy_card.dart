import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';

import '../../../models/allergy_model.dart';
import '../../../screens/patient_screens/profile_screens/edit_allergy_screen.dart';

class MedicationAllergyCard extends StatelessWidget {
  final AllergyData data;

  const MedicationAllergyCard({required this.data, super.key});

  Color color() {
    if (data.status.toLowerCase() == "active") {
      return AppColors.orange;
    } else if (data.status.toLowerCase() == "resolved") {
      return AppColors.green;
    } else {
      return AppColors.red;
    }
  }

  String _getLocalizedStatus(String status) {
    switch (status.toLowerCase()) {
      case "active":
        return AppStrings.activeStatus.tr;
      case "resolved":
        return AppStrings.resolvedStatus.tr;
      default:
        return AppStrings.inactiveStatus.tr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  AppStrings.medication.tr,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const Spacer(),
                InkWell(
                    onTap: () {},
                    child: const Icon(
                      Icons.delete_outline,
                      color: AppColors.red,
                    )),
                3.horizontalSpace,
                InkWell(
                    onTap: () {
                      Get.to(const EditAllergyScreen());
                    },
                    child: const Icon(Icons.edit_calendar_outlined,
                        color: Color(0xFF3B82F6))),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              data.medication,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 16),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: _buildInfoColumn(
                        AppStrings.reaction.tr, data.reaction),
                  ),
                  Expanded(
                    child: _buildInfoColumn(
                        AppStrings.severity.tr, data.severity),
                  ),
                  Expanded(
                    child: _buildInfoColumn(
                        AppStrings.dateIdentified.tr, data.dateIdentified),
                  ),
                ],
              ),
            ),
            const Divider(height: 24, thickness: 1, color: Color(0xFFE5E7EB)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.picture_as_pdf,
                            color: Color(0xFF3B82F6),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            data.documentFileName,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF3B82F6),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${AppStrings.noteLabel.tr}: ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F2937),
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: data.note,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF1F2937),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: color(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getLocalizedStatus(data.status),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}