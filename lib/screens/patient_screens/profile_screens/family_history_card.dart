import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/patient_controllers/medical_history_controller.dart';
import '../../../models/family_history_model.dart';
import '../../../utils/app_strings.dart';

class FamilyHistoryCard extends StatelessWidget {
  final FamilyHistoryModel familyHistory;

  const FamilyHistoryCard({
    super.key,
    required this.familyHistory,
  });

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

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
              familyHistory.relation,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              familyHistory.condition,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                height: 1.5,
              ),
            ),
            Text(
              'Age at diagnosis: ${familyHistory.age} years',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                height: 1.5,
              ),
            ),
            Text(
              'Severity: ${_capitalize(familyHistory.severity)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                height: 1.5,
              ),
            ),
            if (familyHistory.notes.isNotEmpty) ...[
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    height: 1.5,
                  ),
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'Note: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: familyHistory.notes,
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            const Divider(
              color: Color(0xFFE5E7EB),
              thickness: 1,
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: ${_formatDate(familyHistory.updatedAt)}',
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