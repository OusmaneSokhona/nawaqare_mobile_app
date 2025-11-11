import 'package:flutter/material.dart';
import 'package:patient_app/utils/app_colors.dart';

class VerificationViaWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconPath;
  final Color? iconColor;
  final VoidCallback onTap;
  const VerificationViaWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconPath,
    this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            Container(
              width: 56.0,
              height: 56.0,
              decoration: BoxDecoration(
                color: AppColors.darkWhite,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Center(
                child: Image.asset(iconPath,
                width: 28.0,
                  height: 28.0,
                  color: iconColor ?? AppColors.primaryColor,
                ),
              ),
            ),

            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios,
              size: 16.0,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}