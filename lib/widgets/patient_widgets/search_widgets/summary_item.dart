import 'package:flutter/material.dart';

class SummaryItem extends StatelessWidget {
  const SummaryItem({
    super.key,
    required this.label,
    required this.value,
    this.valueColor = Colors.grey, // Default color for most values
    this.valueWeight = FontWeight.normal,
    this.isTotal = false,
    this.subtitle,
  });

  final String label;
  final String value;
  final Color valueColor;
  final FontWeight valueWeight;
  final bool isTotal;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label (Left side)
              Text(
                label,
                style: TextStyle(
                  fontSize: isTotal ? 18 : 16,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  color: Colors.grey.shade800,
                ),
              ),

              // Value (Right side)
              Text(
                value,
                style: TextStyle(
                  fontSize: isTotal ? 18 : 16,
                  fontWeight: valueWeight,
                  color: valueColor,
                ),
              ),
            ],
          ),

          // Subtitle for Consultation Fee
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}