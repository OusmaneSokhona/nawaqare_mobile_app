import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_strings.dart';

class FamilyHistoryCard extends StatelessWidget {
  const FamilyHistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              // Using trParams for dynamic relation name
              AppStrings.relationLabel.trParams({'relation': 'Father'}),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.diabetes.tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                height: 1.5,
              ),
            ),
            Text(
              AppStrings.ageLabel.trParams({'age': '60'}),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                height: 1.5,
              ),
            ),
            Text(
              AppStrings.severityLabel.trParams({'severity': AppStrings.mild.tr}),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  height: 1.5,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: AppStrings.note.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: AppStrings.antibioticWarning.tr,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Divider(
              color: Color(0xFFE5E7EB),
              thickness: 1,
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.lastUpdated.trParams({'date': '12 Sept 2025'}),
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}