import 'package:flutter/material.dart';

class ValidationChecklist extends StatelessWidget {
  final List<ValidationRule> rules;

  const ValidationChecklist({super.key, required this.rules});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Use at least 8 characters include:',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8.0),
          ...rules.map((rule) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Icon(
                    rule.isValid ? Icons.check_box : Icons.check_box_outline_blank,
                    color: rule.isValid ? const Color(0xFF4CAF50) : Colors.grey.shade400,
                    size: 20.0,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    rule.text,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: rule.isValid ? Colors.black87 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
class ValidationRule {
  final String text;
  final bool isValid;
  ValidationRule({required this.text, required this.isValid});
}