import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final IconData icon;
  final Color iconCircleColor;
  final String metricText;
  final String labelText;
  final double width;

  const RatingWidget({
    super.key,
    required this.icon,
    required this.iconCircleColor,
    this.width=80,
    required this.metricText,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: iconCircleColor,
            child: Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            metricText,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            labelText,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}